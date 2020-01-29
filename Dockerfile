FROM debian:stable-slim AS builder
RUN apt-get update && apt-get install -y \
    unzip \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /root/

ENV NOTARY_VERSION=0.6.1

ADD https://github.com/theupdateframework/notary/archive/v$NOTARY_VERSION.zip notary.zip
RUN mkdir /root/notary /root/notary/migrations/
RUN unzip notary.zip "notary-$NOTARY_VERSION/migrations/server/postgresql/*" \
    && unzip notary.zip "notary-$NOTARY_VERSION/migrations/signer/postgresql/*" \
    && mv notary-$NOTARY_VERSION/migrations/ /root/notary/migrations/

############################################################################

FROM migrate/migrate

COPY --from=builder /root/notary/migrations/* /migrations/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]