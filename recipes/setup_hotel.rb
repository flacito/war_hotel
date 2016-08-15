
# for each instance
node['war_hotel']['instances'].each do |instance|

  directory "#{node['war_hotel']['instances_directory']}/#{instance['id']}" do
    recursive true
    user node['war_hotel']['user_id']
    action :create
  end

  # Create the Dockerfile
  template "#{node['war_hotel']['instances_directory']}/#{instance['id']}/Dockerfile" do
    source 'Dockerfile.erb'
    user node['war_hotel']['user_id']
    action :create
    variables :instance => instance
  end

  # pull down the specific tomcat config if any
  if (instance['conf'])
    # pull down the Tomcat config if any
    directory "#{node['war_hotel']['instances_directory']}/#{instance['id']}/conf" do
      user node['war_hotel']['user_id']
      action :create
    end

    # maven instance['conf'].artifact_id do
    #   repositories   node['bbt_war_hotel']['maven']['repositories']
    #   group_id  instance.group_id
    #   version   instance.version
    #   dest      "#{node['war_hotel']['instances_directory']}/#{instance['id']}/conf"
    #   packaging 'zip'
    #   action    :put
    # end
  end

  # pull down dependent libraries if any
  if (instance['lib'])
    directory "#{node['war_hotel']['instances_directory']}/#{instance['id']}/lib" do
      user node['war_hotel']['user_id']
      action :create
    end

    # maven instance['lib'].artifact_id do
    #   repositories   node['bbt_war_hotel']['maven']['repositories']
    #   group_id  instance.group_id
    #   version   instance.version
    #   dest      "#{node['war_hotel']['instances_directory']}/#{instance['id']}/conf"
    #   packaging 'zip'
    #   action    :put
    # end
  end

  directory "#{node['war_hotel']['instances_directory']}/#{instance['id']}/logs" do
    user node['war_hotel']['user_id']
    action :create
  end

  directory "#{node['war_hotel']['instances_directory']}/#{instance['id']}/webapps" do
    user node['war_hotel']['user_id']
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
