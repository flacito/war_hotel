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
    variables :instance => new_resource.instance
  end

  # pull down the specific tomcat config if any
  if new_resource.instance['tomcat']['config']
    maven new_resource.instance['tomcat']['config']['artifact_id'] do
      repositories [ new_resource.instance['tomcat']['config']['repository_url'] ]
      owner new_resource.user
      group_id  new_resource.instance['tomcat']['config']['group_id']
      version   new_resource.instance['tomcat']['config']['version']
      dest      new_resource.cwd
      packaging 'jar'
      action    :put
    end

    execute "unzip -o #{new_resource.cwd}/#{new_resource.instance['tomcat']['config']['artifact_id']}.jar -x *META-INF*" do
      user new_resource.user
      cwd new_resource.cwd
    end
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
    name = "#{name}:#{new_resource.instance['docker_image'].gsub(':','_')}"
  end

  execute "docker build -t #{name} ." do
    cwd new_resource.cwd
    not_if { not "docker inspect #{name}" }
  end

end
