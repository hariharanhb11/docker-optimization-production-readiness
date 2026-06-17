# Docker Optimization & Production Readiness Project

## Project Overview

This project demonstrates how a development Dockerized Node.js application can be optimized and hardened for production deployment.

The original containerized application suffered from multiple issues including:

* Large Docker image size
* Slow build and rebuild times
* Inefficient Docker layer caching
* Security vulnerabilities
* Containers running as root
* Missing health checks
* Poor environment configuration management
* Non-production container design

The goal of this project was to optimize the application following Docker and production container best practices.

---

# Objectives

* Optimize Docker build performance
* Reduce image size
* Improve Docker layer caching
* Implement multi-stage builds
* Harden container security
* Run containers as non-root users
* Add health checks
* Externalize configuration
* Follow production logging practices
* Prepare the application for Kubernetes deployment

---

# Technology Stack

### Application

* Node.js
* Express.js

### Containerization

* Docker
* Docker Compose

### Security

* Trivy

---

# Project Structure

```text
docker-production-readiness-project/

├── app/
│   ├── src/
│   │   └── server.js
│   ├── package.json
│   └── package-lock.json
│
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── .env
│
├── reports/
│   ├── before.md
│   ├── after.md
│   └── trivy-report.txt
│
└── README.md
```

---

# Architecture

```text
Developer
    │
    ▼
Docker Build
    │
    ▼
Multi-Stage Dockerfile
    │
    ▼
Optimized Runtime Image
    │
    ├── Non-Root User
    ├── Health Check
    ├── Layer Caching
    ├── Security Hardening
    └── Production Ready
```

---

# Problems in Original Dockerfile

### Original Dockerfile

```dockerfile
FROM node:20

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 3000

CMD ["npm","start"]
```

### Issues

* Large image size
* No multi-stage build
* Runs as root
* No health check
* Poor layer caching
* Slow rebuild time
* Larger attack surface

---

# Optimized Dockerfile

### Improvements Implemented

* Multi-stage build
* Alpine Linux base image
* Layer caching optimization
* Non-root container execution
* Health checks
* Reduced attack surface

### Optimized Dockerfile

```dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

COPY app/package*.json ./

RUN npm ci

COPY app/ .

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s \
  --timeout=5s \
  --start-period=10s \
  --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node","src/server.js"]
```

---

# Docker Layer Caching Optimization

### Before

```dockerfile
COPY . .
RUN npm install
```

Every source code change forces dependency reinstallation.

### After

```dockerfile
COPY app/package*.json ./
RUN npm ci

COPY app/ .
```

Dependencies are installed only when package files change.

Benefits:

* Faster builds
* Faster rebuilds
* Better cache utilization

---

# Security Improvements

### Before

* Running as root
* Larger attack surface
* No vulnerability scanning

### After

* Non-root user
* Alpine Linux
* Smaller attack surface
* Trivy vulnerability scanning

---

# Health Checks

Application health endpoint:

```http
GET /health
```

Response:

```json
{
  "status": "UP"
}
```

Docker health check continuously verifies application health.

---

# Environment Configuration

Environment variables are externalized using:

```text
.env
```

Example:

```env
PORT=3000
NODE_ENV=production
```

---

# Logging Strategy

Application logs are written to:

```text
stdout
stderr
```

Benefits:

* Docker compatible
* Kubernetes compatible
* Centralized logging support

---

# Graceful Shutdown

The application handles:

```text
SIGTERM
```

Benefits:

* Safe container termination
* Kubernetes compatibility
* Prevents request interruption

---

# Docker Compose Deployment

Build and start:

```bash
docker compose up --build
```

Stop:

```bash
docker compose down
```

---

# Verification

Application:

```text
http://localhost:3000
```

Health Check:

```text
http://localhost:3000/health
```

---

# Security Scan

Run Trivy:

```bash
trivy image app-after
```

Example:

```bash
trivy image docker-production-project-app
```

---

# Results

## Build Optimization

* Multi-stage build implemented
* Layer caching optimized

## Security Hardening

* Non-root user
* Vulnerability scanning
* Reduced attack surface

## Production Readiness

* Health checks
* Environment variables
* Graceful shutdown
* Logging best practices

---

# Acceptance Criteria Mapping

| Requirement           | Status    |
| --------------------- | --------- |
| Multi-stage build     | Completed |
| Build optimization    | Completed |
| Layer caching         | Completed |
| Image size reduction  | Completed |
| Non-root user         | Completed |
| Security improvements | Completed |
| Health checks         | Completed |
| Environment variables | Completed |
| Logging standards     | Completed |
| Production readiness  | Completed |

---

# Kubernetes Readiness

This application is prepared for deployment on Kubernetes because it includes:

* Health checks
* Graceful shutdown
* Stateless design
* Externalized configuration
* Container security best practices

---

# Author

Hariharan B

DevOps | Docker | Kubernetes | Cloud | CI/CD
