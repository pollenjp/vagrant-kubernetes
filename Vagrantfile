# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# linux_os = "ubuntu/bionic64"   # Ubuntu 18.04
linux_os = "ubuntu/focal64"    # Ubuntu 20.04
#linux_os  = "generic/centos7"  # CentOS 7.7
bridge_if = "enp4s0"

vm_spec = [
  {
    name: "master",
    cpu: 2,
    memory: 2048,
    box: linux_os,
    public_ip: "192.168.56.11",
    storage: [],
    playbook: "install_master.yml",
    comment: "Master node",
  },
  {
    name: "node1",
    cpu: 4,
    memory: 8192,
    box: linux_os,
    public_ip: "192.168.56.12",
    storage: [],
    playbook: "install_node.yml",
    comment: "Worker node #1",
  },
  {
    name: "node2",
    cpu: 4,
    memory: 8192,
    box: linux_os,
    public_ip: "192.168.56.13",
    storage: [],
    playbook: "install_node.yml",
    comment: "Worker node #2",
  },
]

Vagrant.configure("2") do |config|
  vm_spec.each do |spec|
    config.vm.define spec[:name] do |v|
      v.vm.box = spec[:box]
      v.vm.hostname = spec[:name]
      # v.vm.network :private_network, ip: spec[:private_ip]
      v.vm.network :public_network, ip: spec[:public_ip], bridge: bridge_if
      v.vm.provider "virtualbox" do |vbox|
        vbox.gui = false
        vbox.cpus = spec[:cpu]
        vbox.memory = spec[:memory]
        i = 1
        spec[:storage].each do |vol|
          vdisk = "vdisks/sd-" + spec[:name] + "-" + i.to_s + ".vdi"
          if not File.exist?(vdisk)
            if i == 1
              vbox.customize [
                               "storagectl", :id,
                               "--name", "SATA Controller",
                               "--add", "sata",
                               "--controller", "IntelAHCI",
                             ]
            end
            vbox.customize [
                             "createmedium", "disk",
                             "--filename", vdisk,
                             "--format", "VDI",
                             "--size", vol * 1024,
                           ]
          end
          vbox.customize [
                           "storageattach", :id,
                           "--storagectl", "SATA Controller",
                           "--port", i,
                           "--device", 0,
                           "--type", "hdd",
                           "--medium", vdisk,
                         ]
          i = i + 1
        end
      end
      v.vm.synced_folder ".",
                         "/vagrant",
                         owner: "vagrant",
                         group: "vagrant",
                         mount_options: [
                           "dmode=700",
                           "fmode=700",
                         ]

      v.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "playbook/" + spec[:playbook]
        ansible.verbose = false
        ansible.install = true
        ansible.limit = spec[:name]
        ansible.inventory_path = "hosts"
      end

      # v.vm.provision "shell", inline: <<-SHELL
      #   apt-get update
      #   apt-get install -y apache2
      # SHELL
    end
  end
end
