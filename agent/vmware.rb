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

      action "installer_version" do
        reply.fail! "Cannot find /root/vmware-tools-distrib/vmware-install.pl" unless File.exist?("/root/vmware-tools-distrib/vmware-install.pl")

        reply[:exitcode] = run("/bin/grep -e '$buildNr = ' /root/vmware-tools-distrib/vmware-install.pl | /bin/cut -d \"'\" -f 2", :stdout => :version, :chomp => true)

        reply.fail! "Installer version failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end

      action "install" do
        reply.fail! "Cannot find /tb/jobs/system/vmware_tools_distribution_upgrade.sh" unless File.exist?("/tb/jobs/system/vmware_tools_distribution_upgrade.sh")

        reply[:exitcode] = run("/tb/jobs/system/vmware_tools_distribution_upgrade.sh install", :stdout => :output, :chomp => true)

        reply.fail! "VMware Tools Installer failed, exit code was #{reply[:exitcode]}" unless reply[:exitcode] == 0
      end

    end
  end
end

# vi:tabstop=2:expandtab:ai:filetype=ruby
