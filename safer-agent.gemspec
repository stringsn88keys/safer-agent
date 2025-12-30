# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "safer-agent"
  spec.version       = "0.1.0"
  spec.authors       = ["safer-agent"]
  spec.email         = ["info@example.com"]

  spec.summary       = "Dockerize your current location and below, ignoring sensitive files but preserving agent access and settings"
  spec.description   = "Mount a temporary Docker container from the current working directory with .dockerignore for sensitive files, but with named volumes for agent settings"
  spec.homepage      = "https://github.com/stringsn88keys/safer-agent"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir["lib/**/*", "bin/*", "README.md", "LICENSE"]
  spec.bindir = "bin"
  spec.executables = ["safer-agent"]
  spec.require_paths = ["lib"]
end
