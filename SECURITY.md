# Security Policy

## Supported code

Security fixes target the current `main` branch until stable releases are published.

## Reporting a vulnerability

Do not open a public issue for vulnerabilities that may expose credentials, private endpoints, customer data, or exploitable details.

Use GitHub's private vulnerability reporting for this repository when available. If private reporting is unavailable, contact the maintainer privately through the contact method listed on the maintainer's GitHub profile.

## Sensitive data

Never commit:

- AWS / S3 credentials
- access keys, tokens, or private endpoints
- captured production payloads containing personal or confidential data
- raw traces that include credentials
- Kubernetes secrets

Load tests must only target systems you own or are explicitly authorized to test.
