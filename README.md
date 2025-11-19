# Enterprise-Ready SecNetDevOps Pipeline

## The Business Problem
B2B SaaS companies operating in the scale-up phase (Series A-B) are consistently failing to close 6- and 7-figure enterprise contracts. The primary blocker is a lack of trust. Their CI/CD pipelines, while fast, lack the auditable security controls required to pass basic vendor risk assessments (like SOC 2 or ISO 27001). This creates unacceptable business risk for their enterprise prospects and ties the hands of their sales teams.

## The Solution (The Blueprint)
This repository is the reference architecture for an **Enterprise-Ready SecNetDevOps Pipeline**.

It is a blueprint designed to solve the conflict between developer velocity and enterprise compliance. This project demonstrates, with deployable code, how to build a pipeline on AWS that embeds automated security and compliance controls (SAST, SCA, IaC, Least Privilege) directly into the development lifecycle.

The result is a system that allows engineers to deploy code rapidly, while simultaneously generating the proof of security and auditable evidence needed to satisfy auditors and unlock major enterprise accounts.


## Tech Stack
* **Cloud:** AWS (VPC, EKS, ECR)
* **IaC:** Terraform
* **CI/CD:** GitHub Actions
* **Security:** Trivy, SonarQube

## Architecture
### High-Level Architecture Flow

`[Developer]` -> `(git push)` -> `[GitHub Repo]`
      |
      v
`[GitHub Actions CI Pipeline]`
  |-- 1. Checkout Code
  |-- 2. Terraform Init/Plan (IaC)
  |-- 3. Build Docker Image
  |-- 4. Security Scans (Trivy/SonarQube) <--- **SECURITY GATE**
  |-- 5. Push to AWS ECR
      |
      v
`[AWS EKS Cluster]` (Automated Deployment)



## Compliance & Risk Alignment

This blueprint is designed to satisfy critical controls for **SOC 2 Type II** and **ISO 27001** audits. The table below maps technical implementation to business compliance requirements.

| Module / Tool | Technical Action | SOC 2 Control (CC) | ISO 27001 Control (Annex A) | Business Value (The "Why") |
| :--- | :--- | :--- | :--- | :--- |
| **Module 1 (Terraform)** | Infrastructure as Code (IaC) | **CC8.1** (Change Management) | **A.12.1.2** (Change Management) | Eliminates "manual configuration drift." All infra changes are reviewed via Pull Requests, creating a permanent audit trail. |
| **Module 1 (AWS IAM)** | Least Privilege Policies | **CC6.1** (Logical Access) | **A.9.2.3** (Access Rights Management) | Ensures that automation tools (and humans) only have the exact permissions needed to perform their role, reducing blast radius. |
| **Module 2 (Docker)** | Non-root User Containers | **CC6.6** (Boundary Protection) | **A.14.2.1** (Secure Development Policy) | Prevents container breakouts. If an attacker compromises the app, they cannot gain control of the underlying host node. |
| **Module 4 (Trivy)** | Automated SCA Scanning | **CC7.1** (System Operations - Vulnerabilities) | **A.12.6.1** (Technical Vulnerability Mgmt) | Automatically blocks the deployment of software with known CVEs (High/Critical), preventing supply chain attacks. |
| **Module 3 (GitHub Actions)** | Automated Pipeline | **CC8.1** (Prevent Unauthorized Changes) | **A.14.2.2** (Change Control Procedures) | Removes human error and malice from the deployment process. No developer has direct access to production; only the pipeline does. |