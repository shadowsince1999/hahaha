# CI/CD Pipeline with Jenkins, Docker, Terraform, AWS, and Datadog Monitoring

## Objective

Create a fully automated CI/CD pipeline that deploys a containerized application on AWS using Jenkins, Docker, and Terraform. The pipeline includes log monitoring and performance metrics using Datadog.

## Prerequisites

- **AWS Account**: Ensure you have an AWS account.
- **Docker**: Installed and configured on your local machine.
- **Terraform**: Installed on your local machine.
- **Jenkins**: Installed and running.
- **Datadog Account**: For monitoring (not covered in detail here but assumed to be configured).

## Sample Node.js Application

### `index.js`

const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('KYA HAL HAI'));

app.listen(3000, () => console.log('Example app listening on port http://localhost:3000'));

### `package.json`
`{
  "name": "nodejs-sampleapp",
  "version": "1.0.0",
  "description": "sample node app ",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/techoclouds/Nodejs-SampleApp.git"
  },
  "author": "TechoClouds",
  "license": "ISC",
  "dependencies": {
    "express": "^4.18.2"
  },
  "bugs": {
    "url": "https://github.com/techoclouds/Nodejs-SampleApp/issues"
  },
  "homepage": "https://github.com/techoclouds/Nodejs-SampleApp#readme"
}`

###`Dockerfile`
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "index.js"]

##Docker Image Testing
### Test the Docker image locally:
`docker build -t nodejs-sampleapp .`
`docker run -p 3000:3000 nodejs-sampleapp`

##Terraform Configuration
https://github.com/shadowsince1999/hahaha/blob/main/main.tf

Jenkins Freestyle Project
Build Script
#!/bin/bash

# Define variables
IMAGE_NAME="shadow"
ECR_REPO="public.ecr.aws/q4r9a4c1/hahaha"
AWS_REGION="us-east-1"
TAG="latest"

# Log in to ECR
aws ecr-public get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}

# Build Docker image
docker build -t ${IMAGE_NAME} .

# Tag Docker image
docker tag ${IMAGE_NAME}:${TAG} ${ECR_REPO}:${TAG}

# Push Docker image to ECR
docker push ${ECR_REPO}:${TAG}

# Initialize Terraform
terraform init

# Apply Terraform configuration
terraform apply -auto-approve

Steps to Set Up Jenkins

    Create a New Freestyle Project:
        Open Jenkins and create a new Freestyle project.

    Configure Source Code Management:
        Connect to your GitHub repository where your Dockerfile and Terraform code reside.

    Add Build Step:
        Add a build step to execute the above script.

    Add Post-build Actions (Optional):
        You can add post-build actions for notifications or additional steps as needed.

    Save and Build:
        Save the configuration and trigger a build to test the pipeline.

Conclusion

You have successfully set up a CI/CD pipeline using Jenkins, Docker, Terraform, and AWS. The pipeline automates the deployment of a Node.js application, builds and pushes Docker images, and creates infrastructure on AWS. Datadog monitoring ensures that you can keep track of performance and logs.
