# frozen_string_literal: true

module SaferAgent
  class DockerfileGenerator
    NODE_VERSION = "20.x"
    
    def self.generate(config)
      # Validate inputs
      username = validate_username(config.user_name)
      uid = validate_id(config.user_id, "UID")
      gid = validate_id(config.group_id, "GID")
      agents = config.selected_agents
      
      dockerfile = <<~DOCKERFILE
        FROM ubuntu:22.04
        
        # Avoid prompts during package installation
        ENV DEBIAN_FRONTEND=noninteractive
        
        # Install basic tools and Node.js
        RUN apt-get update && apt-get install -y \\
            curl \\
            wget \\
            git \\
            build-essential \\
            python3 \\
            python3-pip \\
            sudo \\
            ca-certificates \\
            gnupg \\
            && mkdir -p /etc/apt/keyrings \\
            && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \\
            && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_#{NODE_VERSION} nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \\
            && apt-get update \\
            && apt-get install -y nodejs \\
            && rm -rf /var/lib/apt/lists/*
        
        # Create non-root user
        RUN groupadd -g #{gid} #{username} \\
            && useradd -m -u #{uid} -g #{gid} -s /bin/bash #{username} \\
            && echo "#{username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
        
        # Switch to non-root user
        USER #{username}
        WORKDIR /home/#{username}
        
        # Set up npm global directory for non-root user
        RUN mkdir -p ~/.npm-global \\
            && npm config set prefix '~/.npm-global'
        
        ENV PATH=/home/#{username}/.npm-global/bin:$PATH
        
      DOCKERFILE
      
      # Add agent installations
      unless agents.empty?
        dockerfile += "# Install selected agents\n"
        agents.each do |agent_key|
          agent_info = Config::AVAILABLE_AGENTS[agent_key]
          if agent_info
            dockerfile += "RUN #{agent_info[:install_cmd]}\n"
          end
        end
        dockerfile += "\n"
      end
      
      dockerfile += <<~DOCKERFILE
        # Set working directory
        WORKDIR /workspace
        
        # Default command
        CMD ["/bin/bash"]
      DOCKERFILE
      
      dockerfile
    end
    
    private
    
    def self.validate_username(username)
      unless username =~ /^[a-z_][a-z0-9_-]*$/
        raise ArgumentError, "Invalid username: #{username}"
      end
      username
    end
    
    def self.validate_id(id, name)
      unless id.to_s =~ /^\d+$/ && id.to_i >= 1000 && id.to_i <= 60000
        raise ArgumentError, "Invalid #{name}: #{id}"
      end
      id.to_s
    end
  end
end
