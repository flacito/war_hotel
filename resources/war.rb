resource_name :war

actions :install

default_action :install

attribute :instance_id, :name_attribute => false, :kind_of => String
attribute :artifact_id, :name_attribute => false, :kind_of => String
attribute :group_id, :name_attribute => false, :kind_of => String
attribute :version, :name_attribute => false, :kind_of => String
attribute :destination, :name_attribute => false, :kind_of => String
attribute :verify_war, :name_attribute => false, :kind_of => [TrueClass, FalseClass]
attribute :user, :name_attribute => false, :kind_of => String

action :install do
  maven new_resource.artifact_id do
    repositories node['war_hotel']['maven']['repositories']
    group_id  new_resource.group_id
    version   new_resource.version
    dest      new_resource.destination
    packaging 'war'
    owner     new_resource.user
    action    :put
  end

  # wait for 5 seconds for the WARs to extract (so our integration tests don't fail)
  if verify_war
    ruby_block 'start WAR' do
      block do
        sleep(15)
        retry_count = 0
        while (not ::File.directory?("#{node['war_hotel']['instances_directory']}/#{new_resource.instance_id}/webapps/#{new_resource.artifact_id}"))
          sleep(1)
          Chef::Log.warn("#{new_resource.instance_id} WAR #{new_resource.artifact_id} is not online yet: retry #{retry_count+1}")
          retry_count = retry_count + 1

          if (retry_count > 60)
            Chef::Application.fatal!("WAR failed to deploy: instance_id=#{new_resource.instance_id}, war_name=#{new_resource.artifact_id}")
          end
        end
      end
      action :run
    end
  end

  new_resource.updated_by_last_action(true)
end
