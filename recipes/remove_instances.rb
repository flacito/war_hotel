
roles_to_wars_hash = {}
instances_hash = {}

ruby_block 'remove WARs not in role' do
  block do
    # Create a convenience Hash for comparison
    node['war_hotel']['instances'].each do |instance|
      wars = {}
      instance['wars'].each do |war|
        wars[war['artifact_id']] = war['version']
      end

      roles_to_wars_hash[instance_directory(instance)] = wars
      instances_hash[instance_directory(instance)] = instance
    end

    # Walk all the instances and their WARs that are on this machine
    require 'fileutils'
    require "pathname"

    # Loop over the children of the instances
    Pathname.new(node['war_hotel']['instances_directory']).children.select { |instance_dir|
      if instance_dir.directory?
        dirname = "#{node['war_hotel']['instances_directory']}/#{instance_dir.basename.to_s}"

        # if the instance isn't in the role, remove the whole instance directory
        if not instances_hash.has_key?(dirname)
          Chef::Log.warn("Deleting #{dirname}")
          instance = instances_hash[dirname]
          # Chef::Log.warn("Instance = #{instance} of #{instances_hash}")
          if instance == nil
            system "sudo docker ps -a | awk '{ print $1,$2 }' | grep #{instance_dir.basename.to_s} | awk '{print $1 }' | xargs -I {} sudo docker rm -f {} | awk '{print $2 }' | xargs -I {} sudo docker rmi -f {}"
            FileUtils.remove_dir(dirname)
          else
            system "sudo docker ps -a | awk '{ print $1,$2 }' | grep #{instance['id']} | awk '{print $1 }' | xargs -I {} sudo docker rm -f {} | awk '{print $2 }' | xargs -I {} sudo docker rmi -f {}"
            FileUtils.remove_dir(dirname)
          end
        # instance should still be there, but maybe the webapps not
        else
          if (File.directory?("#{dirname}/webapps"))
            role_instance = roles_to_wars_hash[instance_dir.basename.to_s]
            if not role_instance == nil
              Chef::Log.warn("role_instance = #{role_instance} of #{roles_to_wars_hash}")
              # Loop over the children of instance/webapps
              Pathname.new("#{dirname}/webapps").children.select { |war_dir|
                if war_dir.directory? and not role_instance.has_key?(war_dir.basename.to_s)
                  # Oops, we found a WAR dir in the webapps directory that isn't in the role, remove it
                  FileUtils.remove("#{dirname}/webapps/#{war_dir.basename.to_s}.war")
                  FileUtils.remove_dir("#{dirname}/webapps/#{war_dir.basename.to_s}")
                  Chef::Log.warn("Removed WAR directory not in role: #{dirname}/#{war_dir.basename.to_s}")
                end
              }
            end
          end
        end
      end
    }

  end
  action :run
end
