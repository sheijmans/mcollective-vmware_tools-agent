class MCollective::Application::Vmware<MCollective::Application
   description "Reports on VMware Tools"

    usage <<-END_OF_USAGE
mco vmware [OPTIONS] [FILTERS] <ACTION>

The ACTION can be one of the following:

    version               - report current version of VMware Tools
    version_installer     - report version of VMware Tools installer
    version_old_installer - report version of old VMware Tools installer
    check                 - check if new VMware Tools installer is needed from deployment server
    update                - update VMware Tools installer from deployment server
    install               - installs the new VMware Tools
    remove_old_installer  - removes the old VMware Tools installer from the system
    timesync_status       - displays timesync status of VMware Tools
    uptime                - display the uptime of the server

    stat                  - print useful guest and host information
    stat options:
                          hosttime:  print the host time
                          speed:     print the CPU speed in MHz
                          ESX guests only subcommands:
                          sessionid: print the current session id
                          balloon:   print memory ballooning information
                          swap:      print memory swapping information
                          memlimit:  print memory limit information
                          memres:    print memory reservation information
                          cpures:    print CPU reservation information
                          cpulimit:  print CPU limit information
    END_OF_USAGE

    def post_option_parser(configuration)
      if ARGV.size < 1
        raise "Please specify action"
      else
        action  = ARGV.shift

        unless action.match(/^(version|version_installer|version_old_installer|check|update|install|remove_old_installer|timesync_status|stat|uptime)$/)
          raise "Action can only be version,version_installer,version_old_installer, remove_old_installer,check,update,install,timesync_status,uptime or stat" 
        end

        configuration[:action]  = action

        if action == "stat"
          stat_option  = ARGV.shift

          unless stat_option.match(/^(hosttime|speed|sessionid|balloon|swap|memlimit|memres|cpures|cpulimit)$/)
            raise "stat option can only be hosttime,speed,sessionid,balloon,swap,memlimit,memres,cpures or cpulimit" 
          end

          configuration[:stat_option]  = stat_option
        end
      end
    end

    def validate_configuration(configuration)
      if MCollective::Util.empty_filter?(options[:filter]) and
      options[:discovery_options].empty?
       
        print "Do you really want to operate on " +
          "vmware tools unfiltered? (y/n): "

        STDOUT.flush

        # Only match letter "y" or complete word "yes" ...
        exit! unless STDIN.gets.strip.match(/^(?:y|yes)$/i)
      end
    end

    def main
      action  = configuration[:action]
      stat_option  = configuration[:stat_option]

      mc = rpcclient("vmware", {:options => options})

      #printrpc mc.version(:options => options)
      mc.send(action, {:stat_option => stat_option}).each do |node|

        sender = node[:sender]
        data = node[:data]

        case action
          when /^version$/
            if data[:version] != nil
              printf("%-40s %s\n", sender, data[:version])
            else
              printf("%-40s %s\n", sender, "N/A")
            end

          when /^version_installer$/
            if data[:version] != nil
              printf("%-40s %s\n", sender, data[:version])
            else
              printf("%-40s %s\n", sender, "N/A")
            end

          when /^version_old_installer$/
            if data[:version] != nil
              printf("%-40s %s\n", sender, data[:version])
            else
              printf("%-40s %s\n", sender, "N/A")
            end

          when /^timesync_status$/
            if data[:timesync] != nil
              printf("%-40s %s\n", sender, data[:timesync])
            else
              printf("%-40s %s\n", sender, "N/A")
            end

          when /^stat$/
            printf("%-40s %-10s: %s\n", sender, stat_option, data[:output])

          when /^uptime$/
            printf("%-40s uptime: %s\n", sender, data[:output])

          when /^check$/
	    result = "FAILED"
            output = data[:output]
	    if output.match(/VMware version: .*, update needed to .*/m)
                result="NEEED TO DOWNLOAD UPDATE"
            else
	      if output.match(/VMware version: .* is already active, update not needed/m)
                result="VERSION IS OK"
              end
            end
            printf("%-40s Check result: %s\n", sender, result)

          when /^update$/
	    result = "FAILED"
            output = data[:output]
	    if output.match(/VMware version: .* is already active, update not needed/m)
              result="VERSION IS OK"
            end
            printf("%-40s Update result: %s\n", sender, result)

          when /^install$/
	    result = "FAILED"
            output = data[:output]

            # Check output for succesfull installation and configuration
	    if output.match(/The installation of VMware Tools .* for Linux completed \nsuccessfully./m) and
	    output.match(/The configuration of VMware Tools .* for Linux for this \nrunning kernel completed successfully./m) and
	    output.match(/Enjoy,\n\n--the VMware team/m)
            data[:exitcode] == 0
               result="OK"
            else
              # Check output maybe version is already current
              if output.include?("Version running VMware Tools is the same as installing version, installation not needed!!!") and
              data[:exitcode] == 1
                result="VERSION IS OK"
              end
            end
            printf("%-40s Installation result: %s\n", sender, result)

          when /^remove_old_installer$/
	    result = "FAILED"
            output = data[:output]

            # Check output for succesfull deletion
	    if output.match(/deleted./) and data[:exitcode] == 0
               result="OK"
            else
              # Check output maybe old VMware Tools installer is already deleted
              if output.include?("not available, deletion not performed.") and data[:exitcode] == 1
                result="NOT AVAILABLE"
              end
            end
            printf("%-40s Deletion result: %s\n", sender, result)
        end

      end

      mc.disconnect

      puts
      printrpcstats :summarize => true
    end
end
