def test_war (instance, war)
  instances_directory = '/opt/war_hotel_manager'

  control "WAR installations #{instance['id']}, #{war['artifact_id']}" do
    impact 1.0
    title "Instance #{instance['id']}, war #{war['artifact_id']} is in the right places"

    describe file("#{instances_directory}/#{instance['id']}/webapps/#{war['artifact_id']}") do
      it { should be_directory }
    end
  end

  control "tc Server process(es) #{instance['id']}, #{war['artifact_id']}" do
    impact 1.0
    title "Instance #{instance['id']} tc Server process is running"

    describe processes('java') do
      its('users') { should eq ['root'] }
    end

    describe command("ps -ef | grep java") do
      its('stdout') { should match /-Dcatalina.base=\/usr\/local\/tomcat/ }
    end
  end

  control "tc Server web sites(s) #{instance['id']}, #{war['artifact_id']}" do
    impact 1.0
    title "The WAR, #{war['artifact_id']}, in tc instance #{instance['id']} is operating properly"

      describe command("curl -I http://localhost:#{instance['tomcat']['http_port']}/#{war['artifact_id']}/index.jsp") do
      its('stdout') { should match /HTTP\/1.1 200 OK/ }
    end
  end
end
