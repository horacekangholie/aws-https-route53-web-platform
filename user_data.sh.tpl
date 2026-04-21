#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

dnf install -y nginx

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

LOCAL_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

HOSTNAME=$(hostname)

cat > /usr/share/nginx/html/index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Project 03 - Production Web Platform</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 900px;
      margin: 40px auto;
      padding: 20px;
      line-height: 1.6;
      color: #1f2937;
    }
    .card {
      border: 1px solid #d1d5db;
      border-radius: 10px;
      padding: 24px;
      background: #f9fafb;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Project 03 - Production Web Platform</h1>
    <p>Served through HTTPS using Route53 + ACM + ALB.</p>
    <ul>
      <li><strong>Hostname:</strong> $HOSTNAME</li>
      <li><strong>Instance ID:</strong> $INSTANCE_ID</li>
      <li><strong>Availability Zone:</strong> $AZ</li>
      <li><strong>Private IP:</strong> $LOCAL_IP</li>
    </ul>
  </div>
</body>
</html>
HTML

systemctl enable nginx
systemctl restart nginx