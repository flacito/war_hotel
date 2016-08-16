instance3 = {
  "id" => "test-instance3",
  "docker_image" => "tomcat:alpine",
  "tomcat" => {
    "https_port" => 12443,
    "http_port" => 12080,
    "jmx_port" => 12099,
  },
  "env" =>  {
    "artifact_id" => "test-instance3-env",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "conf" =>  {
    "artifact_id" => "test-instance3-conf",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "lib" =>  {
    "artifact_id" => "test-instance3-lib",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "wars" => [
    {
      "artifact_id" => "test-instance3-war1",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "artifact_id" => "test-instance3-war2",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "artifact_id" => "test-instance3-war3",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    }
  ]
}

require 'test_instance'
test_instance (instance3)

control "test-instance3 war3 version" do
  impact 1.0
  title " should definitely be version 1.0.0"

  describe command("curl -I http://localhost:12080/test-instance3-war3/index.jsp") do
    its('stdout') { should match /HTTP\/1.1 200 OK/ }
  end
end
