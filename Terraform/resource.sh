#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

# =========================
# System Update
# =========================
apt-get update -y
apt-get upgrade -y

# =========================
# Install prerequisites
# =========================
apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    fontconfig

# =========================
# Install Java 21
# =========================
apt-get install -y openjdk-21-jre || apt-get install -y openjdk-17-jre

java -version

# =========================
# Install Jenkins
# =========================
rm -f /etc/apt/sources.list.d/jenkins.list
rm -f /usr/share/keyrings/jenkins-keyring.asc

wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins
sleep 25
systemctl is-active jenkins

# =========================
# Install Docker
# =========================
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

if id ubuntu >/dev/null 2>&1; then
    usermod -aG docker ubuntu
fi

# =========================
# Install SonarQube
# =========================
docker pull sonarqube:lts-community
docker rm -f sonar 2>/dev/null || true

docker run -d \
    --name sonar \
    --restart unless-stopped \
    -p 9000:9000 \
    sonarqube:lts-community

# =========================
# Install Trivy
# =========================
wget -qO- https://aquasecurity.github.io/trivy-repo/deb/public.key \
    | gpg --dearmor \
    | tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
    | tee /etc/apt/sources.list.d/trivy.list

apt-get update -y
apt-get install -y trivy

# =========================
# Verification
# =========================
echo "===== JAVA ====="
java -version

echo "===== JENKINS ====="
systemctl is-active jenkins

echo "===== DOCKER ====="
docker --version

echo "===== SONARQUBE ====="
docker ps

echo "===== TRIVY ====="
trivy --version

echo "===== SETUP COMPLETE ====="