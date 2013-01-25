# MCollective Agent vmware_tools

MCollective Agent to manage VMware Tools

To use this agent you need:

  * MCollective 2.2.1 at least
  * VMware Tools
  * local script: vmware_tools_distribution_upgrade.sh

# TODO

  * ???

## Agent Installation

Follow the basic [plugin install guide](http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/InstalingPlugins)

## Usage

All options and filters are available.

### Requesting VMware Tools version(s)

VMware Tools running version:

    $ mco vmware version

     * [ ============================================================> ] 1 / 1

    host.atsome.domain                       8.6.5.11214 (build-621624)

    Summary of Running version:

       8.6.5.11214 (build-621624) = 1


    Finished processing 1 / 1 hosts in 220.37 ms

VMware Tools installer version:

    $ mco vmware installer_version
 
     * [ ============================================================> ] 1 / 1
 
    host.atsome.domain                       8.6.10 build-913593
 
    Summary of Installer version:
 
       8.6.10 build-913593 = 1
 

    Finished processing 1 / 1 hosts in 184.41 ms

### Install/update VMware Tools

To install/update the VMware Tools from the available installer_version:

    $ mco vmware install


