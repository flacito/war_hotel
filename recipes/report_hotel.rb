require 'net/smtp'

Chef.event_handler do
  on :run_completed do

    message = "From: Chef WAR Hotel #{node['war_hotel']['id']} <do_not_reply@bbandt.com>\n"
    message << "To: WAR Hotel Admins <chef_admins@bbandt.com>\n"
    message << "Subject: WAR Hotel configuration report\n"
    message << "Date: #{Time.now.rfc2822}\n"
    message << "\n"

    # Host Program Versions
    message << "Linux Version: #{'tbd'}\n"
    message << "RHEL Version: #{'tbd'}\n"
    message << "Java Version: #{'tbd'}\n"
    message << "Maven Version: #{'tbd'}\n"
    message << "Docker Version: #{'tbd'}\n"

    # For each instance, report info
    node['war_hotel']['instances'].each do |instance|
      # Docker image used

      # Tomcat ports used

      # If there was a config pulled down, report it's group_id, artifact_id, version

      instance['wars'].each do |war|
        # Report WAR group_id, artifact_id, version

        # List smoke test commands that were run (if we're this far we can assume they ran completed)
      end
    end
  end

  Net::SMTP.start('smtp server', 25) do |smtp|
    smtp.send_message message, 'do_not_reply@bbandt.com', 'chef_admins@bbandt.com'
  end
end
