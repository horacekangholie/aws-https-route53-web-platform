# Project 03 — Production-Ready Web Platform with HTTPS, DNS, and Modular Terraform

---

## 1. Business Requirement

A startup’s web application has evolved into a **public-facing production system** that must meet real-world standards:

- Serve traffic securely over **HTTPS**
- Be accessible via a **custom domain**
- Maintain **high availability across multiple Availability Zones**
- Automatically recover from instance failures
- Follow **infrastructure-as-code (Terraform)** best practices
- Be structured for **scalability and maintainability**

### Key Constraints

- Must follow production-grade architecture patterns
- Must be fully automated via Terraform
- Must avoid direct exposure of backend instances
- Must support future extensibility (CDN, WAF, CI/CD)

### Traffic Profile

- Low baseline traffic
- Burst traffic during campaigns
- Stateless web application

---

## 2. Architecture Design

---

### Core Design

This project implements a **standard production web architecture on AWS**:
```text
User → Route53 → HTTPS (443) → ALB → Target Group → Auto Scaling Group → EC2 (Private Subnets)
```


### Key Principles

- **Separation of concerns**
  - DNS (Route53)
  - Security (ACM, HTTPS)
  - Traffic routing (ALB)
  - Compute (ASG + EC2)
- **Private application tier**
  - EC2 instances are not publicly accessible
- **Immutable infrastructure**
  - Launch Template defines instance configuration
- **High availability**
  - Multi-AZ deployment

---

### Limitations

This architecture is production-ready but not fully production-complete:

- No Web Application Firewall (WAF)
- No CDN (CloudFront)
- NAT Gateway is a **single point of failure**
- No centralized logging system (e.g., ELK/OpenSearch)
- No CI/CD pipeline
- No database tier
- No blue/green deployment strategy

### Failure Considerations

- Incorrect DNS delegation → system unavailable
- ACM validation failure → HTTPS cannot be enabled
- Health check misconfiguration → all targets become unhealthy
- NAT Gateway failure → outbound connectivity lost

---

### AWS Services Used

| Service | Purpose |
|--------|--------|
| **Amazon VPC** | Isolated network |
| **Public Subnets** | Host ALB and NAT Gateway |
| **Private Subnets** | Host EC2 instances |
| **Internet Gateway** | Public internet access |
| **NAT Gateway** | Outbound internet for private instances |
| **Application Load Balancer (ALB)** | Entry point and traffic routing |
| **Target Group** | Health-based routing |
| **EC2** | Application servers |
| **Launch Template** | Immutable instance configuration |
| **Auto Scaling Group (ASG)** | Instance fleet management |
| **Route53** | DNS resolution |
| **ACM (AWS Certificate Manager)** | SSL/TLS certificates |
| **CloudWatch** | Monitoring and alarms |
| **IAM** | Secure access control |
| **SSM Session Manager** | Secure instance access (no SSH) |

---

### Network Design

#### VPC
```text
CIDR: 10.30.0.0/16
```


#### Subnets

| Type | CIDR | AZ |
|------|------|----|
| Public-1 | 10.30.1.0/24 | AZ-1 |
| Public-2 | 10.30.2.0/24 | AZ-2 |
| Private-App-1 | 10.30.11.0/24 | AZ-1 |
| Private-App-2 | 10.30.12.0/24 | AZ-2 |

#### Routing

**Public Subnets**

#### Subnets

| Type | CIDR | AZ |
|------|------|----|
| Public-1 | 10.30.1.0/24 | AZ-1 |
| Public-2 | 10.30.2.0/24 | AZ-2 |
| Private-App-1 | 10.30.11.0/24 | AZ-1 |
| Private-App-2 | 10.30.12.0/24 | AZ-2 |

#### Routing

**Public Subnets**
```text
0.0.0.0/0 → Internet Gateway
```

**Private Subnets**
```text
0.0.0.0/0 → NAT Gateway
```


#### Security Groups

**ALB Security Group**
- Inbound: HTTP (80), HTTPS (443) from Internet
- Outbound: All traffic

**Application Security Group**
- Inbound: HTTP (80) from ALB only
- Outbound: All traffic

---

### Data Flow

#### External Flow

1. User sends HTTPS request to `app.yourdomain.com`
2. Route53 resolves domain → ALB
3. ALB terminates TLS using ACM certificate
4. ALB forwards request to Target Group
5. Target Group selects a healthy EC2 instance
6. EC2 (Nginx) processes request
7. Response returns via ALB to user

#### Internal Flow

- EC2 instances access internet via NAT Gateway
- Instance management via SSM (no SSH)
- Health checks continuously monitored by ALB
- Metrics collected by CloudWatch

---

## Architecture Diagram

```text
                         Route53 (DNS)
                                |
                                v
                       +------------------+
                       |   ALB (HTTPS)    |
                       +--------+---------+
                                |
                 +--------------+--------------+
                 |                             |
          +------v------+               +------v------+
          | EC2 Instance |             | EC2 Instance |
          | Private AZ-1 |             | Private AZ-2 |
          +-------------+             +-------------+

               Private Subnets (ASG across AZs)
                        |
                        v
                 +-------------+
                 | NAT Gateway |
                 +------+------+ 
                        |
                        v
                 +-------------+
                 | Internet GW |
                 +-------------+

VPC (10.30.0.0/16)
- Public Subnets (ALB + NAT)
- Private Subnets (EC2 ASG)

