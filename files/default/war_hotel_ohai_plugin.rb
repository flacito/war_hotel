Ohai.plugin(:Warhotel) do
  provides 'war_hotel'
  depends 'languages'
  depends 'platform_family', 'platform'
  depends 'os', 'os_version'

  def create_objects
    war_hotel Mash.new
  end

  def get_java_info
    so = shell_out('java -version')
    if so.exitstatus == 0
      so.stderr.split(/\r?\n/).each do |line|
        case line
        when /java version \"([0-9\.\_]+)\"/
          war_hotel[:java_version] = $1
        when /^(.+Runtime Environment.*) \((build )?(.+)\)$/
          war_hotel[:runtime] = { "name" => $1, "build" => $3 }
        when /^(.+ (Client|Server) VM) \(build (.+)\)$/
          war_hotel[:hotspot] = { "name" => $1, "build" => $3 }
        end
      end
    end
  end

  def get_docker_info
    so = shell_out('docker -v')
    if so.exitstatus == 0
      war_hotel[:docker_version] = so.stdout.split($/)[0]
    else
      war_hotel[:docker_version] = so.stderr.split($/)[0]
    end
  end

  def get_maven_info
    so = shell_out('mvn -v')
    if so.exitstatus == 0
      war_hotel[:maven_version] = so.stdout.split($/)[0]
    else
      war_hotel[:maven_version] = so.stderr.split($/)[0]
      Ohai::Log.warn('no Maven info found')
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
