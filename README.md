# tal_devops_assignment_react
## Application 1: Task Management System (React.js + Node.js)

### Overview
A full-stack task management application built with React.js frontend and Node.js backend, featuring task creation, management, and status tracking.

### Technical Stack
- Frontend: React.js with Material-UI
- Backend: Node.js with Express
- Database: PostgreSQL
- Authentication: JWT

## Project Structure
```
.
├── frontend/         # React.js frontend application
├── backend/         # Node.js backend application
└── k8s/            # Kubernetes configuration files
```

## Prerequisites
- Node.js 18.x or later
- Docker
- kubectl
- AWS CLI
- eksctl

## Local Development
1. Frontend:
   ```bash
   cd frontend
   npm install
   npm start
   ```

2. Backend:
   ```bash
   cd backend
   npm install
   npm start
   ```

## Deployment
The application is configured to be deployed on Amazon EKS. Refer to the deployment documentation in the k8s directory for detailed instructions.

## Database
The application uses Amazon RDS (PostgreSQL) as the database. Connection details should be configured through environment variables.

### Minimum Tasks (Infra Creation)
- Provision infrastructure either on self managed K8s / EKS using terraform 
- Set up a simple GitHub Actions or Jenkins pipeline to run Terraform commands (terraform fmt, validate, and plan).
- Automate Terraform execution with a pipeline trigger on push to a specific branch.
- Create Dockerfiles 
- Set up multi-stage builds
- push docker file to docker repository
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
