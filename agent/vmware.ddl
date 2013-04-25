metadata :name        => "VMware Tools Agent",
         :description => "Manage VMware Tools on your VMware guest",
         :author      => "S. Heijmans",
         :license     => "ASL2",
         :version     => "1.1.2",
         :url         => "https://github.com/sheijmans/vmware",
         :timeout     => 360

requires :mcollective => "2.2.0"

action "version", :description => "Display version of current running VMware Tools" do
    display :always

    output :version,
           :description => "Output from version",
           :display_as  => "Running version"

    if respond_to?(:summarize)
        summarize do
            aggregate summary(:version)
        end
    end
end

action "version_installer", :description => "Display version of VMware Tools installer" do
    display :always

    output :version,
           :description => "Output from version",
           :display_as  => "Installer version"

    if respond_to?(:summarize)
        summarize do
            aggregate summary(:version)
        end
    end
end

action "version_old_installer", :description => "Display version of old VMware Tools installer" do
    display :always

    output :version,
           :description => "Output from version",
           :display_as  => "Old Installer version"

    if respond_to?(:summarize)
        summarize do
            aggregate summary(:version)
        end
    end
end

action "install", :description => "Install VMware Tools from the installer directory" do
    display :always

    output :output,
           :description => "Output from the VMware Tools installer",
           :display_as  => "Installer ouput"

    output :exitcode,
           :description => "The exitcode from the VMware Tools installer",
           :display_as => "Exit Code"
end

action "remove_old_installer", :description => "Remove old VMware Tools installer" do
    display :always

    output :output,
           :description => "Output from the remove old VMware Tools installer",
           :display_as  => "Remove ouput"

    output :exitcode,
           :description => "The exitcode from deleting the old VMware Tools installer",
           :display_as => "Exit Code"
end

action "timesync_status", :description => "Display timesync status of VMware Tools" do
    display :always

    output :timesync,
           :description => "Output from timesync status",
           :display_as  => "Timesync status"

    if respond_to?(:summarize)
        summarize do
            aggregate summary(:timesync)
        end
    end
end

action "stat", :description => "print useful guest and host information" do
    display :always

    input :stat_option,
          :prompt      => "Option for stat",
          :description => "Option for stat",
          :type        => :string,
          :validation  => '.',
          :optional    => false,
          :maxlength   => 10

    output :output,
           :description => "Output from stat",
           :display_as  => "stat output"

    output :exitcode,
           :description => "The exitcode from stat",
           :display_as => "Exit Code"

    if respond_to?(:summarize)
        summarize do
            aggregate summary(:output)
        end
    end
end

