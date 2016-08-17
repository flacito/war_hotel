instance = {
  "id" => "test-instance1",
  "version" => "1.0.0",
  "docker_image" => "tomcat:alpine",
  "tomcat" => {
    "https_port" => 10443,
    "http_port" => 10080,
    "jmx_port" => 10099,
  },
  "wars" => [
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

war "install test-instance1 war 3" do
  user node['war_hotel']['user_id']
  repository  node['war_hotel']['maven']['repository']
  instance_id 'test-instance1'
  artifact_id 'test-instance1-war3'
  group_id  'com.bbt.bcb'
  version   '2.0.0'
  destination "#{node['war_hotel']['instances_directory']}/#{instance['id']}/webapps"
  verify_war false
  action :install
end

hotel_instance instance['id'] do
  version instance['version']
  cwd "#{node['war_hotel']['instances_directory']}/#{instance['id']}"
  https_port instance['tomcat']['https_port']
  http_port instance['tomcat']['http_port']
  jmx_port instance['tomcat']['jmx_port']
  action :run
end
