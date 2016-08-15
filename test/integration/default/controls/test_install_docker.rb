
control "WAR Hotel Docker Installation" do
  impact 1.0
  title "Docker should be properly installed"

  describe command('docker -v') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /1.12.0/ }
  end

  describe service('docker') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
