# safer-agent

Dockerize your current location and below, ignoring sensitive files but preserving agent access and settings.

## Overview

`safer-agent` is a Ruby gem that helps you run your project in a Docker container while:
- Automatically excluding sensitive files (like `.env`, `*.key`, credentials, etc.) via `.dockerignore`
- Preserving agent settings and configurations (`.claude`, `.cursor`, `.copilot`, etc.) in a named Docker volume
- Mounting your current working directory into the container

## Installation

Install the gem:

```bash
gem install safer-agent
```

Or add to your Gemfile:

```ruby
gem 'safer-agent'
```

## Usage

Basic usage - run an interactive shell in the current directory:

```bash
safer-agent
```

Specify a different Docker image:

```bash
safer-agent --image ruby:3.2
```

Run a specific command:

```bash
safer-agent --command "bundle install && rake test"
```

Create a `.dockerignore` file without running a container:

```bash
safer-agent --create-dockerignore
```

### Options

- `-d, --dir DIRECTORY` - Working directory (default: current directory)
- `-i, --image IMAGE` - Docker image to use (default: ubuntu:latest)
- `-c, --command COMMAND` - Command to run (default: /bin/bash)
- `-n, --non-interactive` - Run in non-interactive mode
- `--create-dockerignore` - Create .dockerignore and exit
- `-h, --help` - Show help message
- `-v, --version` - Show version

## Features

### Automatic .dockerignore Generation

The gem automatically creates a `.dockerignore` file (if one doesn't exist) that excludes:
- Environment files: `.env`, `.env.*`
- Credentials: `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.crt`
- SSH keys: `id_rsa*`, `.ssh/id_*`
- Secrets: `*.secret`, `secrets.yml`, `credentials.yml`
- Build artifacts: `node_modules/`, `vendor/`, `*.log`
- Git directory: `.git/`

### Named Volume for Agent Settings

Agent configuration directories are preserved in a named Docker volume (`safer-agent-settings`):
- `.claude`
- `.cursor`
- `.copilot`
- `.aider`
- `.continue`

This ensures your agent settings persist across container runs and aren't lost when containers are removed.

## Requirements

- Ruby >= 2.7.0
- Docker installed and running

## License

MIT
