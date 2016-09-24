require 'net/smtp'

module ReportHanders
  class WarHotelHandler < Chef::Handler
    def report
      get_docker_info(Chef.run_context.node)
      get_maven_info(Chef.run_context.node)
      get_java_info(Chef.run_context.node)

      message = ""
      message = "From: Chef WAR Hotel #{Chef.run_context.node['war_hotel']['id']} <do_not_reply@bbandt.com>\n"
      message << "To: WAR Hotel Admins <chef_admins@bbandt.com>\n"
      message << "Subject: WAR Hotel configuration report for #{Chef.run_context.node['war_hotel']['id']}\n"
      message << "Date: #{Time.now.rfc2822}\n"
      message << "\n"

      message << "Greetings,\n"
      message << "\n"
      message << "Chef just recently configured the WAR Hotel with the ID #{Chef.run_context.node['war_hotel']['id']}.\n"
      message << "\n"
      message << "\n"

      message << "------------------------------------------\n"
      message << "╦ ╦┌─┐┌─┐┌┬┐  ╔═╗┌┬┐┌┬┐┬─┐┬┌┐ ┬ ┬┌┬┐┌─┐┌─┐\n"
      message << "╠═╣│ │└─┐ │   ╠═╣ │  │ ├┬┘│├┴┐│ │ │ ├┤ └─┐\n"
      message << "╩ ╩└─┘└─┘ ┴   ╩ ╩ ┴  ┴ ┴└─┴└─┘└─┘ ┴ └─┘└─┘\n"
      message << "------------------------------------------\n"
      message << "Linux Version: #{Chef.run_context.node['kernel']['release']}\n"
      message << "Linux Distro: #{Chef.run_context.node['platform']} #{Chef.run_context.node['platform_version']}\n"
      message << "Java Version: #{Chef.run_context.node['war_hotel']['java_version']}\n"
      message << "Maven Version: #{Chef.run_context.node['war_hotel']['maven_version']}\n"
      message << "Docker Version: #{Chef.run_context.node['war_hotel']['docker_version']}\n"
      message << "\n"

      message << "--------------------------\n"
      message << "╦ ┌┐┌┌─┐┌┬┐┌─┐┌┐┌┌─┐┌─┐┌─┐\n"
      message << "║ │││└─┐ │ ├─┤││││  ├┤ └─┐\n"
      message << "╩ ┘└┘└─┘ ┴ ┴ ┴┘└┘└─┘└─┘└─┘\n"
      message << "--------------------------\n"
      Chef.run_context.node['war_hotel']['instances'].each do |instance|

        message << "#{instance['id']}\n"
        message << "  Docker Image: #{instance['docker_image']}\n"
        message << "  Tomcat ports: https=#{instance['tomcat']['https_port']}, http=#{instance['tomcat']['https_port']}, jmx=#{instance['tomcat']['jmx_port']}\n"

        if instance['tomcat']['config']
          message << "  Tomcat configuration for #{instance['id']}: artifact_id=#{instance['tomcat']['config']['artifact_id']}, group_id=#{instance['tomcat']['config']['group_id']}, version=#{instance['tomcat']['config']['version']}\n"
        end

        message << "\n"
        message << "  WARs\n"
        message << "  ----\n"
        instance['wars'].each do |war|
          message << "  artifact_id=#{war['artifact_id']}, group_id=#{war['group_id']}, version=#{war['version']}\n"

          message << "  Smoke tests:\n"
          war['smoke_test_commands'].each do |smoke_commands|
            message << "    #{smoke_commands['command']}\n"
          end
          message << "\n"
        end

        File.write('/var/log/war_hotel_report.log',message)
        Chef::Log.warn('WAR Hotel report copy in /var/log/war_hotel_report.log')

        Net::SMTP.start('localhost', 25) do |smtp|
          smtp.send_message message, 'chef_admins@bbandt.com', 'do_not_reply@bbandt.com'
        end
      end

    end
  end
end
