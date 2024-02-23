FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y \
        awscli \
        ca-certificates \
        curl

# Install kubectl
ARG KUBECTL_VERSION=1.28.4
RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl

COPY refresh_credentials.sh /usr/local/bin/refresh_credentials.sh

CMD ["/usr/local/bin/refresh_credentials.sh"]
