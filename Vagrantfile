Vagrant.configure("2") do |config|
  config.vm.define "vrhel6" do |rhel6|
    rhel6.vm.box = "samdoran/rhel6"
    rhel6.vm.hostname = "vrhel6"
    rhel6.vm.network "forwarded_port", guest: 9443, host: 8750
    rhel6.vm.synced_folder "./test/rhel6/", "/quipucords_installer", :mount_options => ["dmode=777", "fmode=777"]
  end

  config.vm.define "vrhel7" do |rhel7|
    rhel7.vm.box = "generic/rhel7"
    rhel7.vm.hostname = "vrhel7"
    rhel7.vm.network "forwarded_port", guest: 9443, host: 8751
    rhel7.vm.synced_folder "./test/rhel7/", "/quipucords_installer", :mount_options => ["dmode=777", "fmode=777"]
  end

  config.vm.define "vcentos6" do |centos6|
    centos6.vm.box = "geerlingguy/centos6"
    centos6.vm.hostname = "vcentos6"
    centos6.vm.network "forwarded_port", guest: 9443, host: 8752
    centos6.vm.synced_folder "./test/centos6/", "/quipucords_installer", :mount_options => ["dmode=777", "fmode=777"]
  end

  config.vm.define "vcentos7" do |centos7|
    centos7.vm.box = "geerlingguy/centos7"
    centos7.vm.hostname = "vcentos7"
    centos7.vm.network "forwarded_port", guest: 9443, host: 8753
    centos7.vm.synced_folder "./test/centos7/", "/quipucords_installer", :mount_options => ["dmode=777", "fmode=777"]
  end
end
