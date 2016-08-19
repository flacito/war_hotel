instance = {
  "id" => "test-instance1",
  "version" => "1.0.0",
  "docker_image" => "tomcat:alpine",
  "tomcat" => {
    "https_port" => 19443,
    "http_port" => 19080,
    "jmx_port" => 19099,
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
  cwd instance_directory(instance)
  user "#{node['war_hotel']['user_id']}"
  instance instance
end

war "install test-instance1 war 3" do
  user node['war_hotel']['user_id']
  instance_id 'test-instance1'
  artifact_id 'test-instance1-war3'
  group_id  'com.bbt.bcb'
  version   '2.0.0'
  destination "#{instance_directory(instance)}/webapps"
  action :install
end

hotel_instance instance['id'] do
  image_name instance['docker_image']
  cwd instance_directory(instance)
  https_port instance['tomcat']['https_port']
  http_port instance['tomcat']['http_port']
  jmx_port instance['tomcat']['jmx_port']
  action :run
end
