FROM golang:1.12 as build
ARG user="SUSE CFCIBot"
ARG email=ci-ci-bot@suse.de
ADD . /eirini-logging
WORKDIR /eirini-logging
RUN git config --global user.name ${user}
RUN git config --global user.email ${email}
RUN GO111MODULE=on go mod vendor
RUN bin/build

FROM bitnami/kubectl as kubectl

FROM opensuse/leap
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /bin/kubectl
COPY --from=build /eirini-logging/binaries/eirini-logging /bin/eirini-logging
ENTRYPOINT ["/bin/eirini-logging"]
