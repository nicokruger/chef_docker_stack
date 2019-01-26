require 'yaml'
property :file_name, String, default: ''

action :create do
  puts "STACK PATH"
  puts new_resource.file_name
  stack = YAML.load_file(new_resource.file_name)
  puts stack.inspect

  stack['networks'].each { |network|
    puts network.inspect
  }

  stack['services'].each { |service|
    #puts service.inspect
    name,data = service
    puts data

    image_and_tag = data['image']
    stack_volumes = data.fetch('volumes', [])
    stack_ports = data.fetch('ports', [])
    stack_networks = data.fetch('networks', [])

    volumes = []
    ports = []

    stack_volumes.each { |volume|
      #puts volume
      volumes.push(volume)
    }

    stack_ports.each { |port|
      ports.push(port)
    }

    stack_networks.each { |network|
    }

    image, tag = image_and_tag.split(':')
    puts image
    puts tag

    puts 'adding it'
    puts 'VOLUMES'
    puts volumes.inspect

    docker_image name do
      repo image
      tag tag
      action :pull
    end

    docker_container name do
      repo image
      tag tag
      container_name name
      port ports
      action :run
      volumes volumes
    end

  }
end

action :delete do
  puts 'DELETE THE STACK'
end
