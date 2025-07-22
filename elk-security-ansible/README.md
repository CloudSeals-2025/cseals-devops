# ELK Security Ansible Project for AI Training

This Ansible project sets up an ELK Stack specifically configured for security monitoring and AI agent training in SecOps scenarios.

## Project Structure

```
elk-security-ansible/
├── site.yml                 # Main playbook
├── vars/
│   └── security_config.yml  # Security configuration variables
├── inventory/
│   └── hosts               # Inventory file
├── tasks/
│   ├── setup_security_dashboards.yml
│   └── setup_ai_data_exports.yml
└── roles/
    ├── elasticsearch_security/
    ├── logstash_security/
    ├── kibana_security/
    └── filebeat_security/
```

## Features

- **Security-focused ELK Stack deployment**
- **AI training data collection and labeling**
- **Multiple security use cases**:
  - Brute force attack detection
  - Insider threat monitoring
  - Malware lateral movement detection
  - Automated threat hunting
  - Alert deduplication

## Usage

1. Update inventory file with your server details
2. Modify variables in `vars/security_config.yml`
3. Run the playbook:

```bash
ansible-playbook -i inventory/hosts site.yml
```

## Security Use Cases

| Use Case | Data Source | AI Training Focus |
|----------|-------------|------------------|
| Brute Force Detection | SSH auth logs | Pattern recognition for excessive failed attempts |
| Insider Threat | Sudo command logs | Behavioral analysis for unusual admin commands |
| Lateral Movement | Network/process logs | Anomaly detection for unusual connections |
| Threat Hunting | System telemetry | ML models for rare/unseen behaviors |

## Configuration

Key variables in `vars/security_config.yml`:
- `elasticsearch_host`: Elasticsearch server IP
- `brute_force_threshold`: Failed login attempt threshold
- `ai_training_data_retention`: Data retention period
- `security_modules`: Filebeat modules to enable

## Requirements

- Ansible 2.9+
- Ubuntu/Debian target systems
- Python 3.x
- Minimum 4GB RAM for Elasticsearch

## License

MIT License
