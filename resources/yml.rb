require 'yaml'
property :file_name, String, default: ''
property :network, String, required: false

action :create do
  puts "STACK PATH"
  puts new_resource.file_name
  stack = YAML.load_file(new_resource.file_name)
  puts stack.inspect

  puts "have network"
  puts new_source.network

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

    if !stack_volumes.nil?
      stack_volumes.each { |volume|
        #puts volume
        volumes.push(volume)
      }
    end

    if !stack_ports.nil?
      stack_ports.each { |port|
        ports.push(port)
      }
    end

    if !stack_networks.nil?
      stack_networks.each { |network|
      }
    end

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
      network_mode new_resource.network
    end

  }
end

action :delete do
  puts 'DELETE THE STACK'
end
