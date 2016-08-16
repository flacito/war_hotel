
control "Delete instance called deleteme" do
  impact 1.0
  title "The instance, deleteme, should not be there"

  describe file("/opt/war_hotel_manager/deleteme/") do
    it { should_not be_directory }
  end

  describe command("docker ps -a | grep deleteme | grep 1.0.0") do
    its('exit_status') { should_not eq 0 }
  end

  describe command("curl -I http://localhost:18080/test-instance1-war1/index.jsp") do
    its('stdout') { should_not match /HTTP\/1.1 200 OK/ }
  end
end
