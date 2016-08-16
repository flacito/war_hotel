include_recipe 'war_hotel::install_java'
include_recipe 'maven'
include_recipe 'war_hotel::setup_users'
include_recipe 'war_hotel::install_docker'

instance = {
  "id" => "deleteme",
  "version" => "1.0.0",
  "docker_image" => "tomcat:alpine",
  "tomcat" => {
    "https_port" => 18443,
    "http_port" => 18080,
    "jmx_port" => 18099,
  },
  "wars" => [
    {
      "artifact_id" => "test-instance1-war1",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "artifact_id" => "test-instance1-war2",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "artifact_id" => "test-instance1-war3",
      "group_id" => "com.bbt.bcb",
      "version" => "2.0.0"
    }
  ]
}

hotel_instance_config instance['id'] do
  cwd "#{node['war_hotel']['instances_directory']}/#{instance['id']}"
  user "#{node['war_hotel']['user_id']}"
  instance instance
end

war = instance['wars'][0]
war "install deletme war 1" do
  user node['war_hotel']['user_id']
  repository  node['war_hotel']['maven']['repository']
  instance_id "deleteme"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   war['version']
  destination "#{node['war_hotel']['instances_directory']}/#{instance['id']}"
  verify_war false
  action :install
end

war = instance['wars'][1]
war "install deletme war 2" do
  user node['war_hotel']['user_id']
  repository  node['war_hotel']['maven']['repository']
  instance_id "deleteme"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   '1.0.0'
  destination "#{node['war_hotel']['instances_directory']}/#{instance['id']}/webapps"
  verify_war false
  action :install
end

war = instance['wars'][2]
war "install deletme war 3" do
  user node['war_hotel']['user_id']
  repository  node['war_hotel']['maven']['repository']
  instance_id "deleteme"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   '1.0.0'
  destination "#{node['war_hotel']['instances_directory']}/#{instance['id']}/webapps"
  verify_war false
  action :install
end

hotel_instance instance['id'] do
  version instance['version']
  cwd "#{node['war_hotel']['instances_directory']}/#{instance['id']}/webapps"
  https_port instance['tomcat']['https_port']
  http_port instance['tomcat']['http_port']
  jmx_port instance['tomcat']['jmx_port']
  action :run
end

war "install test-instance1 war deleteme" do
  user node['war_hotel']['user_id']
  repository  node['war_hotel']['maven']['repository']
  instance_id "test-instance1"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   '1.0.0'
  destination "/tmp"
  verify_war false
  action :install
end

execute "mv /tmp/test-instance1-war3.war #{node['war_hotel']['instances_directory']}/test-instance1/webapps/deleteme.war" do
end
