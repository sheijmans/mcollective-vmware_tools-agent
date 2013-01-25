metadata :name        => "VMware Tools Agent",
         :description => "Manage VMware Tools on your VMware guest",
         :author      => "S. Heijmans",
         :license     => "ASL2",
         :version     => "0.1",
         :url         => "https://github.com/sheijmans/vmware",
         :timeout     => 300

requires :mcollective => "2.2.1"

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

action "installer_version", :description => "Display version of current running VMware Tools" do
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

action "install", :description => "Install VMware Tools from the installer directory" do
    display :always

    output :output,
           :description => "Output from the VMware Tools installler",
           :display_as  => "Installer ouput"

    output :exitcode,
           :description => "The exitcode from the VMware Tools installer",
           :display_as => "Exit Code"

end
