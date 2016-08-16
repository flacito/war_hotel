
# for each instance
node['war_hotel']['instances'].each do |instance|

  # Start the instance container image
  hotel_instance instance['id'] do
    version instance['version']
    cwd "#{node['war_hotel']['instances_directory']}/#{instance['id']}"
    https_port instance['tomcat']['https_port']
    http_port instance['tomcat']['http_port']
    jmx_port instance['tomcat']['jmx_port']
    action :run
  end

  instance['wars'].each do |war|
    # Run the smoke tests
    war['smoke_test_commands'].each do |smoker|
      execute "run smoke test command #{smoker['command']} == #{smoker['expected_return_code']}" do
        command smoker['command']
        returns smoker['expected_return_code']
        retries 7
        retry_delay 3
      end
    end

  end
end
