
# for each instance
node['war_hotel']['instances'].each do |instance|

  hotel_instance_config instance['id'] do
    cwd "#{node['war_hotel']['instances_directory']}/#{instance['id']}"
    user "#{node['war_hotel']['user_id']}"
    instance instance
    action :create
  end

  instance['wars'].each do |war|
    # pull down the WARs
    war "install #{war['artifact_id']}" do
      user node['war_hotel']['user_id']
      repository  node['war_hotel']['maven']['repository']
      instance_id instance['id']
      artifact_id war['artifact_id']
      group_id  war['group_id']
      version   war['version']
      destination "#{node['war_hotel']['instances_directory']}/#{instance['id']}/webapps"
      verify_war false
      action :install
    end
  end

end
