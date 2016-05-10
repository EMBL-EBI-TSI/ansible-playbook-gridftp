# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.ssh.insert_key = true

  config.vm.box = "boxcutter/centos72"

  config.vm.define "gridftp-server.local" do |box|
    box.vm.network "private_network", ip: "192.168.77.11"
    box.vm.hostname = "gridftp-server.local"
  end

  config.vm.define "gridftp-client.local" do |box|
    box.vm.network "private_network", ip: "192.168.77.12"
    box.vm.hostname = "gridftp-client.local"

    box.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
      ansible.limit = "all"

      ansible.groups = {
        "gridftp-servers" => ["gridftp-server.local"],
        "gridftp-clients" => ["gridftp-client.local"]
      }

      ansible.sudo = true
      # ansible.ask_vault_pass = true
      # ansible.vault_password_file = "vault_pass_file"
      # ansible.tags = ""
      # ansible.skip_tags = ""
      # ansible.verbose = "vv"
    end
  end
end
