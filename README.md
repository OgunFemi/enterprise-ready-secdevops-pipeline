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

## Compliance & Risk Alignment

This blueprint is designed to satisfy critical controls for **SOC 2 Type II** and **ISO 27001** audits. The table below maps technical implementation to business compliance requirements.

| Module / Tool | Technical Action | SOC 2 Control (CC) | ISO 27001 Control (Annex A) | Business Value (The "Why") |
| :--- | :--- | :--- | :--- | :--- |
| **Module 1 (Terraform)** | Infrastructure as Code (IaC) | **CC8.1** (Change Management) | **A.12.1.2** (Change Management) | Eliminates "manual configuration drift." All infra changes are reviewed via Pull Requests, creating a permanent audit trail. |
| **Module 1 (AWS IAM)** | Least Privilege Policies | **CC6.1** (Logical Access) | **A.9.2.3** (Access Rights Management) | Ensures that automation tools (and humans) only have the exact permissions needed to perform their role, reducing blast radius. |
| **Module 2 (Docker)** | Non-root User Containers | **CC6.6** (Boundary Protection) | **A.14.2.1** (Secure Development Policy) | Prevents container breakouts. If an attacker compromises the app, they cannot gain control of the underlying host node. |
| **Module 4 (Trivy)** | Automated SCA Scanning | **CC7.1** (System Operations - Vulnerabilities) | **A.12.6.1** (Technical Vulnerability Mgmt) | Automatically blocks the deployment of software with known CVEs (High/Critical), preventing supply chain attacks. |
| **Module 3 (GitHub Actions)** | Automated Pipeline | **CC8.1** (Prevent Unauthorized Changes) | **A.14.2.2** (Change Control Procedures) | Removes human error and malice from the deployment process. No developer has direct access to production; only the pipeline does. |

## Architecture
### High-Level Architecture Flow

 ```mermaid
 graph LR
    %% Definição dos Nós (Atores e Sistemas)
    Dev([👷 Developer])
    GitHub[🐙 GitHub Repo]
    
    %% O Pipeline de CI/CD (A Caixa Principal)
    subgraph CI_CD_Pipeline ["⚙️ GitHub Actions Pipeline"]
        direction LR
        TF[Terraform Init/Plan]
        Build[Docker Build]
        SecGate{🛡️ Security Gate<br/>Trivy & SonarQube}
    end
    
    %% Os Destinos (AWS)
    ECR[("📦 AWS ECR<br/>(Registry)")]
    EKS[("⬡ AWS EKS<br/>(Cluster)")]

    %% O Fluxo (As Setas)
    Dev -- "git push" --> GitHub
    GitHub -- "Trigger" --> TF
    TF --> Build
    Build --> SecGate
    
    %% Decisão de Segurança
    SecGate -- "❌ Fail (Vulnerabilities)" --> Stop((🚫 Block Deploy))
    SecGate -- "✅ Pass (Clean)" --> ECR
    
    %% Deploy Final
    ECR -- "Deploy Image" --> EKS

    %% Estilização (Para ficar bonito/Enterprise)
    style SecGate fill:#ffcc00,stroke:#333,stroke-width:2px
    style ECR fill:#ff9900,stroke:#333,color:white
    style EKS fill:#ff9900,stroke:#333,color:white
    style CI_CD_Pipeline fill:#f9f9f9,stroke:#333,stroke-dasharray: 5 5
    style Stop fill:#ffcccc,stroke:#cc0000


## 🛡️ Security Architecture & CISSP Alignment

This project implements core cybersecurity principles derived from the **CISSP Common Body of Knowledge (CBK)** to ensure a secure-by-design infrastructure.

### 1. Defense in Depth (Layered Security)
* **Network Layer:** Resources are isolated within a VPC. EKS Nodes reside in **Private Subnets** (no direct internet access), protected by NAT Gateways.
* **Perimeter Layer:** **Security Groups** act as stateful firewalls, strictly whitelisting ingress/egress traffic (e.g., allowing HTTPS only).
* **Identity Layer:** Access is governed by AWS IAM, requiring explicit authentication and authorization via short-lived tokens (STS).

### 2. Principle of Least Privilege (PoLP)
* **IAM Roles:** We do not use Access Keys for compute resources. Instead, EKS Nodes assume specific IAM Roles with minimal permissions required to pull images from ECR, following the concept of "Need-to-Know."
* **Non-Root Containers:** (Planned) Docker images are built to run as non-root users to mitigate potential container breakout attacks.

### 3. Infrastructure as Code (Configuration Management)
* **Immutable Infrastructure:** By using **Terraform**, we treat infrastructure as volatile. We avoid manual changes ("ClickOps"), ensuring that the deployed state always matches the code repository. This satisfies strict **Change Management** controls (SOC 2 CC8.1).

### 4. Confidentiality, Integrity, Availability (CIA Triad)
* **Confidentiality:** All sensitive data (Secrets) are encrypted at rest using AWS KMS (Key Management Service).
* **Integrity:** The CI/CD pipeline ensures that the code deployed is exactly the code committed, verified by checksums and version control.
* **Availability:** The EKS cluster utilizes Auto Scaling Groups across multiple Availability Zones (AZs) to ensure resilience against data center failures.