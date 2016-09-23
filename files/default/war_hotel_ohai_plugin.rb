  Ohai.plugin(:Warhotel) do
  provides 'war_hotel'
  depends 'languages'
  depends 'platform_family', 'platform'
  depends 'os', 'os_version'

  def create_objects
    war_hotel Mash.new
  end

  def get_java_info
    so = shell_out('/usr/bin/java -version')
    if so.exitstatus == 0
      so.stderr.split(/\r?\n/).each do |line|
        case line
        when /java version \"([0-9\.\_]+)\"/
          war_hotel[:java_version] = $1
        end
      end
    end
  end

  def get_docker_info
    so = shell_out('/usr/bin/docker -v')
    if so.exitstatus == 0
      war_hotel[:docker_version] = so.stdout.split($/)[0]
    else
      war_hotel[:docker_version] = so.stderr.split($/)[0]
    end
  end

  def get_maven_info
    war_hotel[:maven_version] = 'error'
    so = shell_out('/usr/local/maven/bin/mvn -v')
    if so.exitstatus == 0
      war_hotel[:maven_version] = so.stdout.split(/\r?\n/)[0]
    else
      war_hotel[:maven_message] = so.stderr
    end
  end

  collect_data(:default) do
    create_objects
    war_hotel[:platform] = platform
    war_hotel[:platform_version] = platform_version
    war_hotel[:platform_family] = platform_family
    get_docker_info
    get_maven_info
    get_java_info
  end
end
