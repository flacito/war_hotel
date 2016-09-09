require 'net/smtp'
module CompanyName
  class FileHandler < Chef::Handler
    def report
   message = ""
   if run_status.updated_resources.empty?
     message += "No resources changed by chef-client - #{Time.now}"
   else
     run_status.updated_resources.each do |r|
       message = "From: Chef WAR Hotel #{node['war_hotel']['id']} <do_not_reply@bbandt.com>\n"
       message << "To: WAR Hotel Admins <chef_admins@bbandt.com>\n"
       message << "Subject: WAR Hotel configuration report\n"
       message << "Date: #{Time.now.rfc2822}\n"
       message << "\n"

      message << "Linux Version: #{node['kernel']['release']}\n"
      message << "#{node['platform']} Version: #{node['platform_version']}\n"
      message << "Java Version: #{node['languages']['java']['version']}\n"
      message << "Maven Version: #{'tbd'}\n"
      message << "Docker Version: #{'tbd'}\n"

      node['war_hotel']['instances'].each do |instance|

      message << "Docker Image used for war hotel #{instance['id']} is #{instance['docker_image']}\n"
      message << "Tomcat ports used for  #{instance['id']} are #{instance['tomcat']['http_port']} and #{instance['tomcat']['https_port']}\n"

        instance['wars'].each do |war|
        message << "Artifacts deployed are  #{war['artifact_id']} with Group id  #{war['group_id']} with version #{war['version']}\n"

        war['smoke_test_commands'].each do |smoke_commands|
        message << "Smoke test commands that were run are #{smoke_commands['command']}\n"

       Net::SMTP.start('localhost', 25) do |smtp|
              smtp.send_message message, 'ramyakailas99@gmail.com', 'rkailas@chef.io'
     end
   end
   File.write("/var/log/chef-client_updated.log",message)
 end
   end
    end
  end
end
end
end
