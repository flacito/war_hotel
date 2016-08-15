
control "WAR Hotel User" do
  impact 1.0
  title "WAR Hotel User should be properly configured"

  describe user('war_hotel_manager') do
    it { should exist }
    its('group') { should eq 'docker' }
    its('home') { should eq '/opt/war_hotel_manager' }
  end
end
