# VK-Paints CI/CD Workflows

## Description
Centralized repository for GitHub Actions reusable workflows and custom actions.

## Pipeline Flow
1. **Validation**: Quality gates (SonarQube) and security scans (Snyk/Trivy).
2. **Build**: Docker image creation.
3. **Publish**: Pushing to GHCR (Release-based).
4. **Deploy**: Automated Helm chart tag updates.
