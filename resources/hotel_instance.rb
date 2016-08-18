resource_name :hotel_instance

actions :run

attribute :container_name, :name_attribute => true, :kind_of => String
attribute :image_name, :required => true, :kind_of => String
attribute :cwd, :required => true, :name_attribute => false, :kind_of => String
attribute :https_port, :required => true, :kind_of => Integer
attribute :http_port, :required => true, :kind_of => Integer
attribute :jmx_port, :required => true, :kind_of => Integer

action :run do

  iname = "#{name}:#{escape_docker_image_name(new_resource.image_name)}"
  cname = "#{container_name}-__-#{image_name.gsub(':','_')}"

  execute "docker run -d --name #{cname} \
            -p #{new_resource.https_port}:8443 \
            -p #{new_resource.http_port}:8080 \
            -p #{new_resource.jmx_port}:8090 \
            -v #{new_resource.cwd}/webapps:/usr/local/tomcat/webapps \
            -v #{new_resource.cwd}/logs:/usr/local/tomcat/logs \
            #{iname}" do
    cwd new_resource.cwd
    not_if "docker ps -a | grep #{new_resource.container_name} | grep #{escape_docker_image_name(new_resource.image_name)}"
  end

  # wait for 5 seconds for the WARs to extract (so our integration tests don't fail)
  ruby_block 'wait for WAR' do
    block do
      retry_count = 0

      while (not system("curl -I http://localhost:#{new_resource.http_port}"))
        sleep(1)
        Chef::Log.warn("#{new_resource.image_name} is not online yet: retry #{retry_count+1}")
        retry_count = retry_count + 1

        if (retry_count > 60)
          Chef::Application.fatal!("Instance failed to deploy: instance_id=#{new_resource.image_name}")
        end
      end
    end
    action :run
  end

end
