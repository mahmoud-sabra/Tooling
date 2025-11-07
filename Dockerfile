FROM jenkins/inbound-agent:alpine-jdk21

USER root

# System tools + Docker CLI + Python + Node.js
RUN apk add --no-cache \
    bash curl unzip git wget python3 py3-pip build-base nodejs npm docker-cli ca-certificates gnupg

# SonarQube Scanner
ENV SONAR_SCANNER_VERSION=5.0.1.3006
ENV SONAR_SCANNER_DIR=/opt/sonar-scanner
RUN curl -sL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -o sonar-scanner.zip && \
    unzip sonar-scanner.zip -d /opt && \
    mv /opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_SCANNER_DIR} && \
    ln -s ${SONAR_SCANNER_DIR}/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm sonar-scanner.zip

# Semgrep & NodeJsScan
RUN pip install semgrep nodejsscan

# Gitleaks
RUN wget https://github.com/gitleaks/gitleaks/releases/download/v8.27.2/gitleaks_8.27.2_linux_x64.tar.gz && \
    tar xvf gitleaks_8.27.2_linux_x64.tar.gz && mv gitleaks /usr/local/bin/ && chmod +x /usr/local/bin/gitleaks

# Hadolint
RUN curl -sSL -o /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 && \
    chmod +x /usr/local/bin/hadolint

# Conftest
RUN curl -sSL -o conftest.tar.gz https://github.com/open-policy-agent/conftest/releases/download/v0.24.0/conftest_0.24.0_Linux_x86_64.tar.gz && \
    tar xvf conftest.tar.gz && mv conftest /usr/local/bin/ && chmod +x /usr/local/bin/conftest && rm conftest.tar.gz

# Grype
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

USER jenkins
WORKDIR /home/jenkins

