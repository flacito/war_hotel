instance2 = {
  "id" => "test-instance2",
  "docker_image" => "tomcat:alpine",
  "tomcat" => {
    "https_port" => 11443,
    "http_port" => 11080,
    "jmx_port" => 11099,
  },
  "env" =>  {
    "artifact_id" => "test-instance2-env",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "conf" =>  {
    "artifact_id" => "test-instance2-conf",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "lib" =>  {
    "artifact_id" => "test-instance2-lib",
    "group_id" => "com.bbt.bcb",
    "version" =>  "1.0.0"
  },
  "wars" => [
    {
      "artifact_id" => "test-instance2-war1",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "artifact_id" => "test-instance2-war2",
      "group_id" => "com.bbt.bcb",
      "version" => "1.0.0"
    },
    {
      "artifact_id" => "test-instance2-war3",
      "group_id" => "com.bbt.bcb",
      "version" => "2.0.0"
    }
  ]
}

require 'test_instance'
test_instance (instance2)
