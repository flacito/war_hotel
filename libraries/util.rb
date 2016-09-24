require 'open3'

def escape_docker_image_name(name)
  return name.gsub(':','_')
end

def instance_directory(instance)
  return "#{node['war_hotel']['instances_directory']}/#{instance['id']}-__-#{escape_docker_image_name(instance['docker_image'])}"
end

def get_java_info(chef_node)
  chef_node.default['war_hotel']['java_version'] = 'error'
  if File.file?('/usr/bin/java')
    cmd = '/usr/bin/java -version'
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      stderr.read.split(/\r?\n/).each do |line|
        case line
        when /java version \"([0-9\.\_]+)\"/
          chef_node.default['war_hotel']['java_version'] = $1
        end
      end
    end
  end
end

def get_docker_info(chef_node)
  chef_node.default['war_hotel']['docker_version'] = 'error'
  if File.file?('/usr/bin/docker')
    cmd = '/usr/bin/docker -v'
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      chef_node.default['war_hotel']['docker_version'] = stdout.read.split($/)[0]
    end
  end
end

def get_maven_info(chef_node)
  chef_node.default['war_hotel']['maven_version'] = 'error'
  if File.file?('/usr/local/maven/bin/mvn')
    cmd = '/usr/local/maven/bin/mvn -v'
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      chef_node.default['war_hotel']['maven_version'] = stdout.read.split(/\r?\n/)[0]
    end
  end
end
