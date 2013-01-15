desc "Generates a .ssh/config file with all the public keys in the database"
task :generate_ssh_config => :environment do
  PublicKey.generate_ssh_config
end
