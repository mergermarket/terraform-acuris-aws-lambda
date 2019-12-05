FROM python:3-alpine
COPY requirements.txt .

ENV TERRAFORM_VERSION=0.12.17
ENV TERRAFORM_ZIP=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ENV TERRAFORM_SUM=8124c7dfe5036377de0637378ad32cf530477403c29ab1ccefbaa50a05d059c2

RUN apk add -U ca-certificates curl && \
    cd /tmp && \
    curl -fsSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP} && \
    echo "${TERRAFORM_SUM}  /tmp/${TERRAFORM_ZIP}" | sha256sum -c - && \
    unzip /tmp/${TERRAFORM_ZIP} -d /usr/bin && \
    rm -rf /tmp/* /var/cache/apk/* /var/tmp/*

RUN pip install --no-cache-dir -r requirements.txt
ADD infra /infra

