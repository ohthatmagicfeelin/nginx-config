# Nginx Configuration Manager

Nginx Configuration Manager: A system for managing Nginx configurations across multiple applications with environment-variable templating and secure deployment.

## Overview

This repository contains a complete Nginx configuration management solution that:
- Uses templates and environment variables for flexible deployment
- Manages multiple application configurations independently
- Provides safe configuration testing and rollback capabilities
- Simplifies SSL and proxy configuration management

## Structure

```
nginx-config/
├── .env.example              # Example environment configuration
├── generate-config.sh        # Generates Nginx configs from templates
├── sync.sh                   # Syncs and deploys configurations to server
└── sites-available/
    ├── coreyb.dev.conf.template    # Main server configuration
    └── includes/
        ├── common/                 # Common configuration snippets
        │   ├── proxy_settings.conf
        │   └── health_check.conf
        └── apps/                   # Application-specific configurations
            ├── weather.conf.template
            ├── spotifyseasons.conf.template
            ├── properties.conf.template
            └── chatbot.conf.template
```

## Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/nginx-config.git
cd nginx-config
```

2. Create your environment file:
```bash
cp .env.example .env
```

3. Edit `.env` with your specific configuration:
```bash
# Domain configuration
DOMAIN=example.com
WEBSITE_ROOT=/var/www/portfolio/dist

# SSL Configuration
SSL_CERT=/path/to/cert
SSL_KEY=/path/to/key
...
```

4. Make scripts executable:
```bash
chmod +x generate-config.sh sync.sh
```

## Usage

### Generating Configurations

Generate Nginx configurations from templates:
```bash
./generate-config.sh
```

### Deploying Configurations

Deploy to your server:
```bash
./sync.sh
```

The sync script will:
1. Generate fresh configurations
2. Create a backup of existing configurations
3. Deploy new configurations
4. Test the new configuration
5. Automatically rollback if tests fail

### Adding New Applications

1. Create a new template in `sites-available/includes/apps/`:
```nginx
location /your_app {
    alias ${YOUR_APP_ROOT};
    try_files $uri $uri/ /your_app/index.html;

    location ~ ^/your_app/api {
        proxy_pass http://localhost:${YOUR_APP_PORT};
        include /etc/nginx/sites-available/includes/common/proxy_settings.conf;
    }
}
```

2. Add variables to `.env`:
```bash
YOUR_APP_ROOT=/var/www/your_app/client/build
YOUR_APP_PORT=5010
```

3. Update `generate-config.sh` with the new template:
```bash
# Your App
envsubst '${YOUR_APP_ROOT} ${YOUR_APP_PORT}' \
    < sites-available/includes/apps/your_app.conf.template \
    > sites-available/includes/apps/your_app.conf
```

## Security

- Sensitive information is stored in environment variables
- SSL configuration is templated for easy updates
- Configuration testing prevents broken deployments
- Automatic rollback on deployment failures

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - see LICENSE file for details
```

Repository Description (for GitHub):
```
A comprehensive Nginx configuration management system featuring environment-based templating, secure deployment workflows, and modular application configurations. Includes automatic testing, rollback capabilities, and SSL management.
```

This README provides:
- Clear project overview
- Setup instructions
- Usage examples
- Directory structure
- Security considerations
- Contributing guidelines

You might want to also add:
- A LICENSE file
- A .gitignore file
- GitHub Actions for automated testing
- More detailed documentation for specific use cases
- Examples of common configurations

Let me know if you'd like me to provide any of these additional components.