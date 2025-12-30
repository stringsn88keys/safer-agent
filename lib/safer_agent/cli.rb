# frozen_string_literal: true

require "optparse"

module SaferAgent
  class CLI
    def initialize(args)
      @args = args
      @options = {
        working_dir: Dir.pwd,
        image: "ubuntu:latest",
        command: "/bin/bash",
        interactive: true
      }
    end

    def run
      parse_options
      
      docker_manager = DockerManager.new(working_dir: @options[:working_dir])
      
      # Run the container - this replaces the current process
      docker_manager.run_container(
        image: @options[:image],
        command: @options[:command],
        interactive: @options[:interactive]
      )
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: safer-agent [options]"
        opts.separator ""
        opts.separator "Dockerize your current location and below, ignoring sensitive files"
        opts.separator "but preserving agent access and settings"
        opts.separator ""
        opts.separator "Options:"

        opts.on("-d", "--dir DIRECTORY", "Working directory (default: current directory)") do |dir|
          @options[:working_dir] = dir
        end

        opts.on("-i", "--image IMAGE", "Docker image to use (default: ubuntu:latest)") do |image|
          @options[:image] = image
        end

        opts.on("-c", "--command COMMAND", "Command to run (default: /bin/bash)") do |cmd|
          @options[:command] = cmd
        end

        opts.on("-n", "--non-interactive", "Run in non-interactive mode") do
          @options[:interactive] = false
        end

        opts.on("--create-dockerignore", "Create .dockerignore and exit") do
          docker_manager = DockerManager.new(working_dir: @options[:working_dir])
          docker_manager.create_dockerignore
          exit(0)
        end

        opts.on("-h", "--help", "Show this help message") do
          puts opts
          exit(0)
        end

        opts.on("-v", "--version", "Show version") do
          puts "safer-agent #{SaferAgent::VERSION}"
          exit(0)
        end
      end.parse!(@args)
    end
  end
end
