def instance_directory(instance)

  return "#{node['war_hotel']['instances_directory']}/#{instance['id']}-#{instance['docker_image'].gsub(':','_')}"
end
