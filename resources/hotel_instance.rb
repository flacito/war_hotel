resource_name :hotel_instance

actions :run

attribute :image_name, :name_attribute => true, :kind_of => String
attribute :image_tag, :name_attribute => false, :kind_of => String
attribute :container_name, :name_attribute => true, :kind_of => String
attribute :cwd, :required => true, :name_attribute => false, :kind_of => String
attribute :https_port, :required => true, :kind_of => Integer
attribute :http_port, :required => true, :kind_of => Integer
attribute :jmx_port, :required => true, :kind_of => Integer

action :build do

  name = new_resource.name
  if (new_resource.image_tag)
    name = "#{name}:#{image_tag}"
  end

  execute "docker build -t #{name} ." do
    cwd new_resource.cwd
  end
end

action :run do

  name = new_resource.name
  if (new_resource.image_tag)
    name = "#{name}:#{image_tag}"
  end

  execute "docker run -d --name #{new_resource.container_name} \
            -p #{new_resource.https_port}:8443 \
            -p #{new_resource.http_port}:8080 \
            -p #{new_resource.jmx_port}:8090 \
            -v #{new_resource.cwd}/webapps:/usr/local/tomcat/webapps \
            -v #{new_resource.cwd}/logs:/usr/local/tomcat/logs \
            #{name}" do
    cwd new_resource.cwd
    not_if "docker inspect #{new_resource.image_name}"
  end
end
