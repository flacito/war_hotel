
control "WAR Hotel Report" do
  impact 1.0
  title "Host versions should be properly indicated"

  describe file('/var/log/war_hotel_report.log') do
    its('content') { should match %r{Maven Version: Apache Maven 3.3.9} }
    its('content') { should match %r{Docker Version: Docker version 1.12.1} }
    its('content') { should match %r{Java Version: 1.8.0_101} }
    its('content') { should match %r{Linux Distro: centos 7.1} }
    its('content') { should match %r{Linux Version: 3.10} }
  end
end
