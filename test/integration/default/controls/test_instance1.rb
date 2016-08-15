instance1 = {
  "id" => "test-instance1",
  "docker_image" => "tomcat:alpine",
  "tomcat" => {
    "https_port" => 10443,
    "http_port" => 10080,
    "jmx_port" => 10099,
  },
  "env" =>  {
    "artifact_id" => "test-instance1-env",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "conf" =>  {
    "artifact_id" => "test-instance1-conf",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "lib" =>  {
    "artifact_id" => "test-instance1-lib",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
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

require 'test_instance'
test_instance (instance1)
