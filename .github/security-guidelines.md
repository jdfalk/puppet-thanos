<!-- file: .github/security-guidelines.md -->
<!-- version: 1.0.0 -->
<!-- guid: 1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d -->

# Security Guidelines for Reusable Workflows

This document provides security guidelines that GitHub Copilot should follow
when recommending or implementing the reusable workflows in this repository.

## General Security Principles

### 1. Least Privilege Access

**Always recommend**:

- Minimal required permissions for workflows
- Environment-specific access controls
- Time-limited tokens when possible

**Implementation**:

```yaml
permissions:
  contents: read
  packages: write
  id-token: write # For OIDC authentication
  attestations: write # For build attestations
```

### 2. Secret Management

**Best Practices**:

- Never hardcode secrets in workflow files
- Use GitHub secrets for sensitive data
- Prefer OIDC over long-lived credentials
- Rotate secrets regularly

**Recommended Secrets**:

```yaml
# Container registries
DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}

# Package registries
NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
PYPI_TOKEN: ${{ secrets.PYPI_TOKEN }}

# Notifications
SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### 3. Input Validation

**Always validate**:

- User inputs in reusable workflows
- Environment variables
- File paths and patterns
- External URLs and references

**Example Validation**:

```yaml
inputs:
  image-name:
    description: 'Container image name'
    required: true
    type: string
    # Validate format
  platforms:
    description: 'Target platforms'
    required: false
    default: 'linux/amd64,linux/arm64'
    type: string
    # Validate platform list
```

## Supply Chain Security

### 1. Dependency Pinning

**Always pin**:

- Action versions to specific commits or tags
- Base container images to specific digests
- Tool versions in installation scripts

**Example**:

```yaml
- name: Checkout code
  uses: actions/checkout@v4 # Pinned to major version

- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '20' # Specific version
```

### 2. Software Bill of Materials (SBOM)

**Always generate SBOMs for**:

- Container images
- Application packages
- Binary releases

**Tools to use**:

- Syft for SBOM generation
- Grype for vulnerability scanning
- Cosign for signing and attestation

### 3. Container Security

**Best Practices**:

- Use minimal base images (Alpine, distroless)
- Run as non-root user
- Scan for vulnerabilities
- Sign images and generate attestations
- Use multi-stage builds

**Example Dockerfile**:

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=nextjs:nodejs . .
USER nextjs
```

## Workflow Security

### 1. Event Triggers

**Secure trigger patterns**:

```yaml
on:
  push:
    branches: [main] # Limit to specific branches
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened]
  workflow_dispatch: # Manual trigger with approval
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        type: choice
        options: ['staging', 'production']
```

**Avoid**:

- `pull_request_target` without careful review
- Unrestricted `workflow_dispatch`
- Triggers on all branches/tags

### 2. Environment Protection

**Always use environments for**:

- Production deployments
- Package publishing
- External integrations

**Configuration**:

```yaml
environment: production
# Requires manual approval and/or specific reviewers
```

### 3. Token Scoping

**Use specific permissions**:

```yaml
permissions:
  contents: read # Repository content
  packages: write # Container registry
  id-token: write # OIDC authentication
  actions: read # Action metadata
  attestations: write # Build attestations
  security-events: write # Security alerts
```

## Code Security

### 1. Static Analysis

**Always include**:

- SAST (Static Application Security Testing)
- Dependency vulnerability scanning
- Secret scanning
- Code quality checks

**Recommended Actions**:

- CodeQL for code analysis
- Trivy for vulnerability scanning
- GitLeaks for secret detection

### 2. Dynamic Analysis

**For container workflows**:

- Runtime vulnerability scanning
- Image composition analysis
- Behavioral analysis

### 3. Compliance Scanning

**Industry Standards**:

- CIS benchmarks for containers
- NIST guidelines
- GDPR compliance for data handling
- SOC 2 requirements

## Incident Response

### 1. Security Monitoring

**Monitor for**:

- Failed authentication attempts
- Unusual access patterns
- Privilege escalation attempts
- Unauthorized secret access

### 2. Alerting

**Set up alerts for**:

- Security scan failures
- High/critical vulnerabilities
- Authentication failures
- Unusual workflow executions

### 3. Response Procedures

**When security issues are detected**:

1. Immediate containment
2. Impact assessment
3. Stakeholder notification
4. Remediation planning
5. Post-incident review

## Architecture Security

### 1. Network Security

**Best Practices**:

- Use HTTPS for all communications
- Validate TLS certificates
- Restrict egress traffic where possible
- Use private networks for sensitive operations

### 2. Data Protection

**Data handling**:

- Encrypt data in transit and at rest
- Minimize data collection
- Implement data retention policies
- Ensure GDPR compliance

### 3. Infrastructure Security

**Cloud Security**:

- Use managed services when possible
- Implement proper IAM roles
- Enable audit logging
- Regular security assessments

## Compliance Requirements

### 1. Regulatory Compliance

**Consider requirements for**:

- GDPR (data protection)
- SOX (financial reporting)
- HIPAA (healthcare data)
- PCI DSS (payment processing)

### 2. Industry Standards

**Follow standards**:

- NIST Cybersecurity Framework
- ISO 27001/27002
- CIS Controls
- OWASP Top 10

### 3. Documentation

**Maintain documentation for**:

- Security controls
- Risk assessments
- Incident response procedures
- Compliance evidence

## Security Testing

### 1. Automated Testing

**Include in workflows**:

- Vulnerability scanning
- Dependency checks
- Configuration validation
- Compliance verification

### 2. Manual Testing

**Regular activities**:

- Penetration testing
- Security code reviews
- Architecture reviews
- Threat modeling

### 3. Third-Party Assessment

**Consider**:

- External security audits
- Bug bounty programs
- Red team exercises
- Compliance audits

## Recommendations for Different Project Types

### Open Source Projects

**Additional Considerations**:

- Public vulnerability disclosure
- Community security review
- Transparent security practices
- Regular security updates

### Enterprise Projects

**Enhanced Security**:

- Private vulnerability scanning
- Enhanced monitoring
- Stricter access controls
- Compliance documentation

### Cloud-Native Applications

**Specific Concerns**:

- Service mesh security
- Secrets management
- Network policies
- Runtime protection

## Security Checklist

### Pre-Implementation

- [ ] Security requirements identified
- [ ] Threat model created
- [ ] Security controls designed
- [ ] Compliance requirements mapped

### Implementation

- [ ] Secure coding practices followed
- [ ] Security tools integrated
- [ ] Access controls implemented
- [ ] Monitoring configured

### Post-Implementation

- [ ] Security testing completed
- [ ] Vulnerability scanning performed
- [ ] Documentation updated
- [ ] Team training provided

### Ongoing

- [ ] Regular security reviews
- [ ] Dependency updates
- [ ] Security metrics tracked
- [ ] Incident response tested

## Emergency Procedures

### Security Incident Response

1. **Detection**: Automated alerts, manual discovery
2. **Analysis**: Scope and impact assessment
3. **Containment**: Stop the threat, preserve evidence
4. **Eradication**: Remove the threat, fix vulnerabilities
5. **Recovery**: Restore normal operations
6. **Lessons Learned**: Improve processes and controls

### Communication Plan

- Internal stakeholders
- External partners
- Regulatory bodies
- Public disclosure (if required)

### Recovery Procedures

- System restoration
- Data recovery
- Service continuity
- Performance monitoring
