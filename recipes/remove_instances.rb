
role_instances = {}

ruby_block 'remove WARs not in role' do
  block do
    # Create a convenience Hash for comparison
    node['war_hotel']['instances'].each do |instance|
      wars = {}
      instance['wars'].each do |war|
        wars[war['artifact_id']] = war['version']
      end

      role_instances[instance['id']] = wars
    end

    # Walk all the instances and their WARs that are on this machine
    require 'fileutils'
    require "pathname"


    # Loop over the children of the instances
    Pathname.new(node['war_hotel']['instances_directory']).children.select { |instance_dir|
      Chef::Log.warn(role_instances)
      if instance_dir.directory?
        sc = "#{node['war_hotel']['instances_directory']}/#{instance_dir.basename}"

        # if the instance isn't in the role, remove the whole instance directory
        Chef::Log.warn("role_instances.has_key?(instance_dir.basename.to_s) == #{role_instances.has_key?(instance_dir.basename.to_s)}")
        if not role_instances.has_key?(instance_dir.basename.to_s)
          Chef::Log.warn("Deleting #{instance_dir.basename}")
          FileUtils.remove_dir(sc)
        # instance should still be there, but maybe the webapps not
        else
          if (File.directory?("#{sc}/webapps"))
            role_instance = role_instances[instance_dir.basename.to_s]
            if not role_instance == nil
              # Loop over the children of instance/webapps
              Pathname.new("#{sc}/webapps").children.select { |war_dir|
                if war_dir.directory? and not role_instance.has_key?(war_dir.basename.to_s)
                  # Oops, we found a WAR dir in the webapps directory that isn't in the role, remove it
                  FileUtils.remove("#{sc}/webapps/#{war_dir.basename.to_s}.war")
                  FileUtils.remove_dir("#{sc}/webapps/#{war_dir.basename.to_s}")
                  Chef::Log.warn("Removed WAR directory not in role: #{sc}/#{war_dir.basename.to_s}")
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
