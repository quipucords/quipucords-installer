Vagrant.configure("2") do |config|
  # unnoficial RHEL images
  (8..9).each do |n|
    config.vm.define "rhel%d" % n do |vmconfig|
      vmconfig.vm.box = "generic/rhel%d" % n
    end
  end
  # allow ssh'ing with password authentication (username and password are "vagrant")
  config.vm.provision "shell", inline: <<-EOF
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    # fallback to service for systems that don't use systemd
    systemctl restart sshd.service
  EOF
end
