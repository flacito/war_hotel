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

  change_conf = ::File.directory?("#{new_resource.cwd}/conf")
  change_lib = ::File.directory?("#{new_resource.cwd}/lib")
  change_env = ::File.directory?("#{new_resource.cwd}/bin")

  # pull down the specific tomcat config if any
  if new_resource.instance['tomcat']['config']
    maven new_resource.instance['tomcat']['config']['artifact_id'] do
      repositories node['war_hotel']['maven']['repositories']
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

  # Create the Dockerfile
  template "#{new_resource.cwd}/Dockerfile" do
    source 'Dockerfile.erb'
    user new_resource.user
    action :create
    variables :instance => new_resource.instance, :change_conf => change_conf, :change_lib => change_lib, :change_env => change_env
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
  iname = "#{name}:#{escape_docker_image_name(instance['docker_image'])}"

  execute "docker build -t #{iname} ." do
    cwd new_resource.cwd
    not_if { not "docker inspect #{iname}" }
  end

end
