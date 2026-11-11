
# Azure Cloud Monitoring and Infrastructure Automation

## Project Overview

This project demonstrates automated Azure infrastructure provisioning using Terraform, deployment of a Python Flask application to Azure App Service, and application monitoring using Azure Application Insights and Log Analytics.

## Architecture

- Terraform provisions Azure infrastructure.
- Azure Resource Group organizes project resources.
- Azure Storage Account stores Terraform remote state.
- Azure App Service hosts the Python Flask application.
- Azure Application Insights collects application telemetry.
- Log Analytics Workspace stores and queries monitoring data.

## Technologies Used

- Microsoft Azure
- Terraform
- Azure App Service
- Azure Application Insights
- Azure Monitor
- Log Analytics
- Python
- Flask
- Gunicorn
- Git and GitHub
- Kusto Query Language (KQL)

## Implementation

1. Provisioned Azure infrastructure using reusable Terraform modules.
2. Configured remote Terraform state in Azure Storage.
3. Deployed a Linux-based Azure App Service.
4. Developed a Python Flask application with health-check and test-error endpoints.
5. Integrated Application Insights using Azure Monitor OpenTelemetry.
6. Configured Log Analytics for telemetry analysis.
7. Verified request, trace and exception telemetry using KQL.
8. Configured deployment to install Python dependencies and start the application using Gunicorn.

## Monitoring Queries

### HTTP Requests

```kusto
requests
| where timestamp > ago(1h)
| project timestamp, name, resultCode, duration
| order by timestamp desc
```

### Application Exceptions

```kusto
exceptions
| where timestamp > ago(1h)
| project timestamp, type, outerMessage
| order by timestamp desc
```

### Request Status Summary

```kusto
requests
| where timestamp > ago(1h)
| summarize TotalRequests = count() by resultCode
```

## Application Endpoints

- `/` - Application status
- `/health` - Health check
- `/error` - Intentional exception for monitoring validation

## Security and Cost Considerations

- Terraform state is stored remotely in Azure Storage.
- Sensitive state and local configuration files are excluded through `.gitignore`.
- HTTPS is enforced on the Web App.
- Azure monitoring ingestion is subject to applicable usage charges.
- The project uses a free-tier App Service plan.

## Learning Outcomes

- Infrastructure as Code using Terraform
- Azure resource provisioning and configuration
- Python application deployment
- Application monitoring and troubleshooting
- Log analysis using KQL
- Git version control
