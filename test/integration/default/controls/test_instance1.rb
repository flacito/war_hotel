instance1 = {
  "id" => "test-instance1",
  "docker_image" => "tomcat:8.5",
  "tomcat" => {
    "https_port" => 10443,
    "http_port" => 10080,
    "jmx_port" => 10099,
    "config" =>  {
      "artifact_id" => "test-instance1-tomcat-config",
      "group_id" => "com.bbt.bcb",
      "version" =>  "1.0.0"
    }
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
      "version" => "1.0.0"
    }
  ]
}

require 'test_instance'
test_instance (instance1)

control "Tomcat config" do
  impact 1.0
  title "Test Instance 1 has a specific Tomcat configuration that should be downloaded and extracted."

  describe file("#{instance_directory(instance1)}/conf") do
    it { should be_directory }
  end

  describe file("#{instance_directory(instance1)}/Dockerfile") do
    its('content') { should match /COPY conf/ }
    its('content') { should match /COPY lib/ }
  end

  describe command("curl -L http://localhost:#{instance1['tomcat']['http_port']}/test-instance1-war1/index.jsp") do
    its('stdout') { should match /maxPostSize=2097152/ }
  end
end
