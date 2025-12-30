# Development Guide

## Building the Gem

```bash
gem build safer-agent.gemspec
```

This creates `safer-agent-0.1.0.gem` in the current directory.

## Installing Locally

```bash
gem install ./safer-agent-0.1.0.gem
```

Or use the rake task:

```bash
rake install
```

## Testing

Run the executable:

```bash
./bin/safer-agent --help
```

Or if installed:

```bash
safer-agent --help
```

## Development Workflow

1. Make changes to files in `lib/`
2. Test locally:
   ```bash
   ruby bin/safer-agent --help
   ```
3. Build and install:
   ```bash
   rake clean
   rake install
   ```

## Publishing to RubyGems

When ready to publish:

```bash
gem push safer-agent-0.1.0.gem
```

Note: You'll need a RubyGems.org account and proper credentials.

## Requirements

- Ruby >= 2.7.0
- Docker installed and running
- Bundler (for development)

## Project Structure

```
safer-agent/
├── bin/
│   └── safer-agent          # Executable script
├── lib/
│   ├── safer_agent.rb       # Main module
│   └── safer_agent/
│       ├── version.rb       # Version constant
│       ├── docker_manager.rb # Docker operations
│       └── cli.rb           # Command-line interface
├── safer-agent.gemspec      # Gem specification
├── Gemfile                  # Bundler dependencies
├── Rakefile                 # Rake tasks
├── README.md                # User documentation
├── EXAMPLES.md              # Usage examples
└── LICENSE                  # MIT license
```
