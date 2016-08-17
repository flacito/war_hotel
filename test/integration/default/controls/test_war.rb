require 'helpers'

def test_war (instance, war)

  control "WAR installations #{instance['id']}, #{war['artifact_id']}" do
    impact 1.0
    title "Instance #{instance['id']}, war #{war['artifact_id']} is in the right places"

    describe file("#{instance_directory(instance)}/webapps/#{war['artifact_id']}") do
      it { should be_directory }
    end
  end

  control "Tomcat process #{instance['id']}, #{war['artifact_id']}" do
    impact 1.0
    title "Instance #{instance['id']} Tomcat process is running"

    describe processes('java') do
      its('users') { should eq ['root'] }
    end

    describe command("ps -ef | grep java") do
      its('stdout') { should match /-Dcatalina.base=\/usr\/local\/tomcat/ }
    end
  end

  control "Tomcat web sites #{instance['id']}, #{war['artifact_id']}" do
    impact 1.0
    title "The WAR, #{war['artifact_id']}, in tc instance #{instance['id']} is operating properly"

      describe command("curl -I http://localhost:#{instance['tomcat']['http_port']}/#{war['artifact_id']}/index.jsp") do
      its('stdout') { should match /HTTP\/1.1 200 OK/ }
    end
  end

  control "Delete WARs in instance #{instance['id']}" do
    impact 1.0
    title "The WAR, deleteme, in tc instance #{instance['id']} should not be there"

    describe file("#{instance_directory(instance)}/webapps/deleteme") do
      it { should_not be_directory }
    end

    describe command("curl -I http://localhost:#{instance['tomcat']['http_port']}/deleteme/index.jsp") do
      its('stdout') { should_not match /HTTP\/1.1 200 OK/ }
    end
  end
end
