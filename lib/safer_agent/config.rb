# frozen_string_literal: true

require "yaml"

module SaferAgent
  class Config
    CONFIG_FILE = File.expand_path("~/.safer-agent/config.yml")
    
    AVAILABLE_AGENTS = {
      "claude" => {
        name: "Claude Code",
        install_cmd: "npm install -g @anthropic-ai/claude-cli"
      },
      "copilot" => {
        name: "GitHub Copilot CLI",
        install_cmd: "npm install -g @githubnext/github-copilot-cli"
      },
      "aider" => {
        name: "Aider",
        install_cmd: "pip3 install aider-chat"
      }
    }.freeze
    
    attr_reader :config_data
    
    def initialize
      @config_data = load_config
    end
    
    def load_config
      if File.exist?(CONFIG_FILE)
        YAML.load_file(CONFIG_FILE) || {}
      else
        {}
      end
    end
    
    def save_config(data)
      FileUtils.mkdir_p(File.dirname(CONFIG_FILE))
      File.write(CONFIG_FILE, YAML.dump(data))
      @config_data = data
    end
    
    def configured?
      !config_data.empty? && config_data.key?("agents")
    end
    
    def selected_agents
      config_data["agents"] || []
    end
    
    def user_name
      config_data["user_name"] || "safer"
    end
    
    def user_id
      config_data["user_id"] || "1000"
    end
    
    def group_id
      config_data["group_id"] || "1000"
    end
    
    def interactive_setup
      puts "\n=== Safer Agent Configuration ==="
      puts "\nThis is your first time running safer-agent."
      puts "Let's configure your environment.\n\n"
      
      # Configure user
      print "Enter username for Docker container (default: safer): "
      username = gets.chomp
      username = "safer" if username.empty?
      
      print "Enter user ID (default: 1000): "
      uid = gets.chomp
      uid = "1000" if uid.empty?
      
      print "Enter group ID (default: 1000): "
      gid = gets.chomp
      gid = "1000" if gid.empty?
      
      # Configure agents
      puts "\nSelect agents to install (space-separated numbers, or 'all', or 'none'):"
      AVAILABLE_AGENTS.each_with_index do |(key, info), idx|
        puts "  #{idx + 1}. #{info[:name]} (#{key})"
      end
      print "Your choice: "
      choice = gets.chomp.downcase
      
      selected = []
      if choice == "all"
        selected = AVAILABLE_AGENTS.keys
      elsif choice != "none" && !choice.empty?
        indices = choice.split.map(&:to_i)
        selected = indices.map { |i| AVAILABLE_AGENTS.keys[i - 1] }.compact
      end
      
      config = {
        "user_name" => username,
        "user_id" => uid,
        "group_id" => gid,
        "agents" => selected,
        "configured_at" => Time.now.to_s
      }
      
      save_config(config)
      
      puts "\n✓ Configuration saved to #{CONFIG_FILE}"
      puts "Selected agents: #{selected.empty? ? 'none' : selected.join(', ')}"
      puts "\nYou can reconfigure anytime by deleting the config file.\n"
      
      config
    end
  end
end
