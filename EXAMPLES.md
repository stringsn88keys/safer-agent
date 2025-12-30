# safer-agent Examples

## Basic Usage

### Run an interactive shell
```bash
safer-agent
```

This will:
1. Create a `.dockerignore` file if one doesn't exist
2. Create a named volume for agent settings if needed
3. Mount your current directory to `/workspace` in the container
4. Mount the persistent volume to `/root/.agent-settings`
5. Start an interactive bash shell in an Ubuntu container

### Use a specific Docker image
```bash
safer-agent --image ruby:3.2
safer-agent --image node:18
safer-agent --image python:3.11
```

### Run a specific command
```bash
safer-agent --command "ls -la"
safer-agent --command "bundle install && rake test"
safer-agent --command "npm install && npm test"
```

### Non-interactive mode
```bash
safer-agent --non-interactive --command "echo 'Hello World'"
```

## Advanced Usage

### Working with a different directory
```bash
safer-agent --dir /path/to/project
```

### Just create .dockerignore
```bash
safer-agent --create-dockerignore
```

## Use Cases

### Running tests in isolation
```bash
safer-agent --image ruby:3.2 --command "bundle install && rspec"
```

### Building and testing a Node.js project
```bash
safer-agent --image node:18 --command "npm ci && npm test"
```

### Interactive debugging
```bash
safer-agent --image python:3.11
# Inside container:
# cd /workspace
# python -m pdb your_script.py
```

## Understanding the Volumes

The gem creates two types of mounts:

1. **Workspace mount**: Your current directory → `/workspace` (read-write)
   - Contains all your project files
   - Changes persist on your host machine

2. **Agent settings mount**: Named volume → `/root/.agent-settings` (persistent)
   - Stores agent configuration that persists across container runs
   - Created when any of these directories exist locally: `.claude`, `.cursor`, `.copilot`, `.aider`, `.continue`

## Tips

- The container is automatically removed when you exit (uses `--rm` flag)
- Agent settings persist in the named volume `safer-agent-settings`
- Sensitive files are listed in `.dockerignore` for when you build images
- Use `docker volume ls` to see the persistent volume
- Use `docker volume rm safer-agent-settings` to remove the persistent volume if needed
