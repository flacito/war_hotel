require 'test_war'

def test_instance (instance)

  control "Instance directory for #{instance['id']}" do
    impact 1.0
    title "#{instance_directory(instance)} should be properly configured"

    describe file("#{instance_directory(instance)}") do
      it { should be_directory }
    end

    # describe file("#{instance_directory(instance)}/conf") do
    #   it { should be_directory }
    # end
    #
    # describe file("#{instance_directory(instance)}/lib") do
    #   it { should be_directory }
    # end
    #
    # describe file("#{instance_directory(instance)}/bin/setenv.sh") do
    #   it { should exist }
    # end
  end

  control "Dockerfile for #{instance['id']}" do
    impact 1.0
    title "#{instance_directory(instance)}/Dockerfile should be properly configured"

    describe file("#{instance_directory(instance)}/Dockerfile") do
      it { should exist }
    end

    describe file("#{instance_directory(instance)}/Dockerfile") do
      its('content') { should match /FROM #{instance['docker_image']}/ }
      its('content') { should match /RUN rm -Rf \/usr\/local\/tomcat\/webapps\/ROOT/ }
      # its('content') { should match /COPY conf\/* \/usr\/local\/tomcat\/conf/ }
      # its('content') { should match /COPY lib\/* \/usr\/local\/tomcat\/lib/ }
    end

  end

  instance['wars'].each do |war|
    test_war instance, war
  end

  control "No ROOT webapp installed for #{instance['id']}" do
    impact 1.0
    title "Instance #{instance['id']} must not have the ROOT web application installed"

    describe file("#{instance_directory(instance)}/webapps/ROOT") do
      it { should_not be_directory }
    end

    describe command("curl -s -o /dev/null -w \"%{http_code}\" http://localhost:#{instance['tomcat']['http_port']}") do
      its('stdout') { should eq '404' }
    end
  end

end
