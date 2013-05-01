module MCollective
  module Agent
    class Vmware<RPC::Agent


      activate_when do
        File.executable?("/usr/bin/vmware-toolbox-cmd")
      end


      action "version" do
        reply.fail! "Cannot find /usr/bin/vmware-toolbox-cmd" unless File.exist?("/usr/bin/vmware-toolbox-cmd")

        reply[:exitcode] = run("/usr/bin/vmware-toolbox-cmd -v", :stdout => :version, :chomp => true)

        reply.fail! "Running version failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end


      action "version_installer" do
        reply.fail! "Cannot find /root/vmware-tools-distrib/vmware-install.pl" unless File.exist?("/root/vmware-tools-distrib/vmware-install.pl")

        reply[:exitcode] = run("/bin/grep -e '$buildNr = ' /root/vmware-tools-distrib/vmware-install.pl | /bin/cut -d \"'\" -f 2", :stdout => :version, :chomp => true)

        reply.fail! "Determine Installer version failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end


      action "version_old_installer" do
        reply.fail! "Cannot find /root/vmware-tools-distrib.old/vmware-install.pl" unless File.exist?("/root/vmware-tools-distrib.old/vmware-install.pl")

        reply[:exitcode] = run("/bin/grep -e '$buildNr = ' /root/vmware-tools-distrib.old/vmware-install.pl | /bin/cut -d \"'\" -f 2", :stdout => :version, :chomp => true)

        reply.fail! "Determine old Installer version failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end


      action "check" do
        reply.fail! "Cannot find /tb/jobs/system/vmware_tools_distribution_upgrade.sh" unless File.exist?("/tb/jobs/system/vmware_tools_distribution_upgrade.sh")

        reply[:exitcode] = run("/tb/jobs/system/vmware_tools_distribution_upgrade.sh check", :stdout => :output, :chomp => true)

        reply.fail! "VMware Tools check failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end

      action "update" do
        reply.fail! "Cannot find /tb/jobs/system/vmware_tools_distribution_upgrade.sh" unless File.exist?("/tb/jobs/system/vmware_tools_distribution_upgrade.sh")

        reply[:exitcode] = run("/tb/jobs/system/vmware_tools_distribution_upgrade.sh update", :stdout => :output, :chomp => true)

        reply.fail! "VMware Tools update failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end

      action "uptime" do
        reply.fail! "Cannot find /usr/bin/uptime" unless File.exist?("/usr/bin/uptime")

        reply[:exitcode] = run("/usr/bin/uptime | /bin/cut -d ',' -f1", :stdout => :output, :chomp => true)

        reply.fail! "uptime failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end

      action "install" do
        reply.fail! "Cannot find /tb/jobs/system/vmware_tools_distribution_upgrade.sh" unless File.exist?("/tb/jobs/system/vmware_tools_distribution_upgrade.sh")

        reply[:exitcode] = run("/tb/jobs/system/vmware_tools_distribution_upgrade.sh install", :stdout => :output, :chomp => true)

        reply.fail! "VMware Tools Installer failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end


      action "remove_old_installer" do
        reply.fail! "Cannot find /tb/jobs/system/vmware_tools_distribution_upgrade.sh" unless File.exist?("/tb/jobs/system/vmware_tools_distribution_upgrade.sh")

        reply[:exitcode] = run("/tb/jobs/system/vmware_tools_distribution_upgrade.sh remove", :stdout => :output, :chomp => true)

        reply.fail! "Remove old VMware Tools Installer failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end


      action "timesync_status" do
        reply.fail! "Cannot find /usr/bin/vmware-toolbox-cmd" unless File.exist?("/usr/bin/vmware-toolbox-cmd")

        reply[:exitcode] = run("/usr/bin/vmware-toolbox-cmd timesync status", :stdout => :timesync, :chomp => true)

        reply.fail! "Timesync status failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end


      action "stat" do
        reply.fail! "Cannot find /usr/bin/vmware-toolbox-cmd" unless File.exist?("/usr/bin/vmware-toolbox-cmd")

        reply[:exitcode] = run("/usr/bin/vmware-toolbox-cmd stat #{request[:stat_option]}", :stdout => :output, :chomp => true)

        reply.fail! "stat failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end


    end
  end
end

# vi:tabstop=2:expandtab:ai:filetype=ruby
