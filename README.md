# tal_devops_assignment_react
## Application 1: Task Management System (React.js + Node.js)

### Overview
A full-stack task management application built with React.js frontend and Node.js backend, featuring task creation, management, and status tracking.

### Technical Stack
- Frontend: React.js with Material-UI
- Backend: Node.js with Express
- Database: PostgreSQL
- Authentication: JWT

### Minimum Tasks (Infra Creation)
- Provision infrastructure either on self managed K8s / EKS using terraform 
- Set up a simple GitHub Actions or Jenkins pipeline to run Terraform commands (terraform fmt, validate, and plan).
- Automate Terraform execution with a pipeline trigger on push to a specific branch.
- Create Dockerfiles 
- Set up multi-stage builds
- Configure environment variables
- Set up health check endpoints
- Configure basic logging

### Target Tasks (Deployment)
- Refactor the Terraform code to use modules for reusability.
- Store Terraform state in an S3 bucket with DynamoDB for state locking.
- Write Deployment.yaml and service.yaml files for deployment on k8s.
- Use helm for deplyment using gitops
- Handle environment variables using k8s secrets

### Stretch 
- Setup Argo CD for automatic deplyoment 
- Setup Promethues and grafana 
- setup basic alerts
