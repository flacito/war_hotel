def instance_directory(instance)

  return "#{node['war_hotel']['instances_directory']}/#{instance['id']}-_-#{instance['docker_image'].gsub(':','_')}"
end
