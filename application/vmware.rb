class MCollective::Application::Vmware<MCollective::Application
   description "Reports on VMware Tools"

    usage <<-END_OF_USAGE
mco vmware [OPTIONS] [FILTERS] <ACTION>

The ACTION can be one of the following:

    version           - report current version of VMware Tools
    installer_version - report version of VMware Tools installer
    END_OF_USAGE

    def post_option_parser(configuration)
      if ARGV.size < 1
        raise "Please specify action"
      else
        action  = ARGV.shift

        unless action.match(/^(version|installer_version|install)$/)
          raise "Action can only be version,installer_version or install" 
        end

        configuration[:action]  = action
      end
    end

    def validate_configuration(configuration)
      if MCollective::Util.empty_filter?(options[:filter])
        print "Do you really want to operate on " +
          "services unfiltered? (y/n): "

        STDOUT.flush

        # Only match letter "y" or complete word "yes" ...
        exit! unless STDIN.gets.strip.match(/^(?:y|yes)$/i)
      end
    end

    def main
      action  = configuration[:action]

      mc = rpcclient("vmware", {:options => options})

      #printrpc mc.version(:options => options)
      mc.send(action).each do |node|

        sender = node[:sender]
        data = node[:data]

        if action == "install"
	  result = "FAILED"
          output = data[:output]
          if output.include?("running kernel completed successfully.") and 
             output.include?("Enjoy,") and 
             output.include?("--the VMware team") and 
             data[:exitcode] == 0
            result="OK"
          end
          printf("%-40s Installation result: %s\n", sender, result)
        else
            printf("%-40s %s\n", sender, data[:version])
        end

      end

      mc.disconnect

      puts
      printrpcstats :summarize => true
    end
end
