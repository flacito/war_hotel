# require 'test_war'

def test_instance (instance)
  instances_directory = '/opt/war_hotel_manager'

  control "Instance directory for #{instance['id']}" do
    impact 1.0
    title "Instance #{instance['id']} directory should be properly configured"

    describe file("#{instances_directory}/#{instance['id']}") do
      it { should be_directory }
    end

    # describe file("#{instances_directory}/#{instance['id']}/conf") do
    #   it { should be_directory }
    # end
    #
    # describe file("#{instances_directory}/#{instance['id']}/lib") do
    #   it { should be_directory }
    # end
    #
    # describe file("#{instances_directory}/#{instance['id']}/bin/setenv.sh") do
    #   it { should exist }
    # end
  end

  control "Dockerfile for #{instance['id']}" do
    impact 1.0
    title "Dockerfile for #{instance['id']} should be properly configured"

    describe file("#{instances_directory}/#{instance['id']}/Dockerfile") do
      it { should exist }
    end

    describe file("#{instances_directory}/#{instance['id']}/Dockerfile") do
      its('content') { should match /FROM #{instance['docker_image']}/ }
      its('content') { should match /RUN rm -Rf \/usr\/local\/tomcat\/webapps\/ROOT/ }
      # its('content') { should match /COPY conf\/* \/usr\/local\/tomcat\/conf/ }
      # its('content') { should match /COPY lib\/* \/usr\/local\/tomcat\/lib/ }
    end

  end

  # instance['wars'].each do |war|
  #   test_war instance, war
  # end

  # control "No ROOT webapp installed for #{instance['id']}" do
  #   impact 1.0
  #   title "Instance #{instance['id']} must not have the ROOT web application installed"
  #
  #   describe file("#{instances_directory}/#{instance['id']}/webapps/ROOT") do
  #     it { should_not be_directory }
  #   end
  #
  #   describe command("curl -s -o /dev/null -w \"%{http_code}\" http://localhost:#{instance['tomcat']['http_port']}") do
  #     its('stdout') { should eq '404' }
  #   end
  # end

end
