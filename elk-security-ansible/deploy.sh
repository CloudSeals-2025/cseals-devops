#!/bin/bash
# ELK Security Deployment Script

set -e

echo "Starting ELK Security Stack deployment for AI Training..."

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Ansible is not installed. Please install Ansible first."
    exit 1
fi

# Check if inventory file exists
if [[ ! -f "inventory/hosts" ]]; then
    echo "Inventory file not found. Please configure inventory/hosts first."
    exit 1
fi

# Run syntax check
echo "Running syntax check..."
ansible-playbook -i inventory/hosts site.yml --syntax-check

# Run dry-run
echo "Running dry-run..."
ansible-playbook -i inventory/hosts site.yml --check

# Ask for confirmation
read -p "Do you want to proceed with the deployment? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Run actual deployment
    echo "Starting deployment..."
    ansible-playbook -i inventory/hosts site.yml -v

    echo "Deployment completed successfully!"
    echo "Access Kibana at: http://[your-elk-server]:5601"
else
    echo "Deployment cancelled."
fi
