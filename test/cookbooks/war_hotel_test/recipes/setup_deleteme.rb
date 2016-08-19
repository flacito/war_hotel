deleteme_instance = {
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
      "repository_url" => "http://dl.bintray.com/flacito/wars-dev",
      "artifact_id" => "test-instance1-war1",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "repository_url" => "http://dl.bintray.com/flacito/wars-dev",
      "artifact_id" => "test-instance1-war2",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "repository_url" => "http://dl.bintray.com/flacito/wars-dev",
      "artifact_id" => "test-instance1-war3",
      "group_id" => "com.bbt.bcb",
      "version" => "2.0.0"
    }
  ]
}

hotel_instance_config 'test-instance1' do
  cwd instance_directory(node['war_hotel']['instances'][0])
  user "#{node['war_hotel']['user_id']}"
  instance node['war_hotel']['instances'][0]
end

hotel_instance_config deleteme_instance['id'] do
  cwd "#{node['war_hotel']['instances_directory']}/#{deleteme_instance['id']}"
  user "#{node['war_hotel']['user_id']}"
  instance deleteme_instance
end

war = deleteme_instance['wars'][0]
war "install deletme war 1" do
  user node['war_hotel']['user_id']
  instance_id "deleteme"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   war['version']
  destination "#{node['war_hotel']['instances_directory']}/#{deleteme_instance['id']}/webapps"
  repository_url war['repository_url']
  verify_war false
  action :install
end

war = deleteme_instance['wars'][1]
war "install deletme war 2" do
  user node['war_hotel']['user_id']
  instance_id "deleteme"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   '1.0.0'
  destination "#{node['war_hotel']['instances_directory']}/#{deleteme_instance['id']}/webapps"
  repository_url war['repository_url']
  verify_war false
  action :install
end

war = deleteme_instance['wars'][2]
war "install deletme war 3" do
  user node['war_hotel']['user_id']
  instance_id "deleteme"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   '1.0.0'
  destination "#{node['war_hotel']['instances_directory']}/#{deleteme_instance['id']}/webapps"
  verify_war false
  repository_url war['repository_url']
  action :install
end

hotel_instance deleteme_instance['id'] do
  image_name deleteme_instance['docker_image']
  cwd "#{node['war_hotel']['instances_directory']}/#{deleteme_instance['id']}/webapps"
  https_port deleteme_instance['tomcat']['https_port']
  http_port deleteme_instance['tomcat']['http_port']
  jmx_port deleteme_instance['tomcat']['jmx_port']
  action :run
end

war "install test-instance1 war deleteme" do
  user node['war_hotel']['user_id']
  instance_id "test-instance1"
  artifact_id war['artifact_id']
  group_id  war['group_id']
  version   '1.0.0'
  destination "/tmp"
  verify_war false
  repository_url war['repository_url']
  action :install
end

execute "mv /tmp/test-instance1-war3.war #{instance_directory(node['war_hotel']['instances'][0])}" do
end
