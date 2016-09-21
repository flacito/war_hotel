def escape_docker_image_name(name)
  return name.gsub(':','_')
end

def instance_directory(instance)
  return "/opt/war_hotel_manager/#{instance['id']}-__-#{escape_docker_image_name(instance['docker_image'])}"
end
