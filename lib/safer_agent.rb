# frozen_string_literal: true

require_relative "safer_agent/version"
require_relative "safer_agent/docker_manager"
require_relative "safer_agent/cli"

module SaferAgent
  class Error < StandardError; end
end
