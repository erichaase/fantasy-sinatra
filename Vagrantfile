Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y libxslt-dev libxml2-dev bundler
    cd /vagrant
    bundle install
  SHELL
  # bundle exec rackup config.ru -p 5000
end
