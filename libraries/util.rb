def escape_docker_image_name(name)
  return name.gsub(':','_')
end

def instance_directory(instance)

  return "#{node['war_hotel']['instances_directory']}/#{instance['id']}-_-#{escape_docker_image_name(instance['docker_image'])}"
end
