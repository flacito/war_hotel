resource_name :hotel_instance_config

actions :create

attribute :instance_id, :name_attribute => true, :kind_of => String
attribute :cwd, :required => true, :name_attribute => false, :kind_of => String
attribute :user, :required => true, :name_attribute => false, :kind_of => String
attribute :instance, :required => true, :name_attribute => false, :kind_of => Object

action :create do

  directory "#{new_resource.cwd}" do
    recursive true
    user new_resource.user
    action :create
  end

  # Create the Dockerfile
  template "#{new_resource.cwd}/Dockerfile" do
    source 'Dockerfile.erb'
    user new_resource.user
    action :create
    variables :instance => instance
  end

  # pull down the specific tomcat config if any
  if (instance['conf'])
    # pull down the Tomcat config if any
    directory "#{new_resource.cwd}/conf" do
      user new_resource.user
      action :create
    end

    # maven instance['conf'].artifact_id do
    #   owner new_resource.user
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
    directory "#{new_resource.cwd}/lib" do
      user new_resource.user
      action :create
    end

    # maven instance['lib'].artifact_id do
    #   owner new_resource.user
    #   repositories   node['bbt_war_hotel']['maven']['repositories']
    #   group_id  instance.group_id
    #   version   instance.version
    #   dest      "#{node['war_hotel']['instances_directory']}/#{instance['id']}/conf"
    #   packaging 'zip'
    #   action    :put
    # end
  end

  directory "#{new_resource.cwd}/logs" do
    user new_resource.user
    action :create
  end

  directory "#{new_resource.cwd}/webapps" do
    user new_resource.user
    action :create
  end

  # Create the instance container image
  name = new_resource.instance_id
  if (instance['version'])
    name = "#{name}:#{instance['version']}"
  end

  execute "docker build -t #{name} ." do
    cwd new_resource.cwd
    not_if { not "docker inspect #{new_resource.instance_id}:#{instance['version']}" }
  end

end
