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

## First-Time Setup

On first run, `safer-agent` will guide you through a configuration process:

```bash
safer-agent
```

You'll be asked to configure:
- **Username**: The non-root user to run as in the container (default: safer)
- **User ID**: The UID for the user (default: 1000)
- **Group ID**: The GID for the user (default: 1000)
- **Agents**: Which coding agents to pre-install (Claude, Copilot, Aider, or none)

This creates a custom Docker image with:
- Node.js installed for the non-root user
- Selected coding agents pre-installed
- Proper permissions for the non-root user

You can reconfigure anytime by running:

```bash
safer-agent --setup
```

Or by deleting the config file at `~/.safer-agent/config.yml`

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
- `-i, --image IMAGE` - Docker image to use (default: custom image if configured, otherwise ubuntu:latest)
- `-c, --command COMMAND` - Command to run (default: /bin/bash)
- `-n, --non-interactive` - Run in non-interactive mode
- `--setup` - Run configuration setup (or reconfigure)
- `--create-dockerignore` - Create .dockerignore and exit
- `-h, --help` - Show help message
- `-v, --version` - Show version

## Features

### Non-Root User Execution

Containers run as a non-root user for improved security. The user is created during the initial setup with:
- Configurable username, UID, and GID
- Sudo access within the container
- Proper home directory and shell

### Pre-installed Coding Agents

Choose from popular coding agents to pre-install in your custom image:
- **Claude Code** - Anthropic's Claude CLI
- **GitHub Copilot CLI** - GitHub's Copilot command-line tool
- **Aider** - AI pair programming in your terminal

Agents are installed during the first-time setup and are immediately available in your containers.

### Node.js Environment

Node.js (version 20.x) is automatically installed in the custom image for the non-root user, with:
- Global npm packages directory configured
- PATH set up correctly
- npm available for installing additional tools

### Automatic .dockerignore Generation

The gem automatically creates a `.dockerignore` file (if one doesn't exist) that excludes:
- Environment files: `.env`, `.env.*`
- Credentials: `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.crt`
- SSH keys: `id_rsa*`, `.ssh/id_*`
- Secrets: `*.secret`, `secrets.yml`, `credentials.yml`
- Build artifacts: `node_modules/`, `vendor/`, `*.log`
- Git directory: `.git/`

**Note:** The `.dockerignore` file is used when building Docker images from your workspace (with `docker build`). It does not affect which files are accessible in the running container when using `safer-agent`, as the tool uses volume mounts which include all files in the mounted directory. The `.dockerignore` helps ensure that if you later build Docker images from this workspace, sensitive files won't be included in the image layers.

### Named Volume for Agent Settings

Agent configuration directories are preserved in a named Docker volume (`safer-agent-settings`) mounted at `/root/.agent-settings` in the container:
- `.claude`
- `.cursor`
- `.copilot`
- `.aider`
- `.continue`

This ensures your agent settings persist across container runs and aren't lost when containers are removed. The volume is automatically created on first use and reused for subsequent runs.

## Requirements

- Ruby >= 2.7.0
- Docker installed and running

## License

MIT
