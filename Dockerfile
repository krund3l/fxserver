FROM alpine AS dwnld
RUN apk update --no-cache && apk add --no-cache ca-certificates curl
RUN curl https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/8102-1879d0ca8628ddc80b54ae058f6916a108c3dae2/server.7z | tar xJ -C /srv/.

FROM scratch
COPY --from=dwnld /srv/alpine/. /.
RUN apk update --no-cache && apk upgrade --no-cache
RUN addgroup -g 1000 -S cfx && adduser -u 1000 -S cfx -G cfx
RUN mkdir /txData && chown cfx:cfx /txData
USER cfx
WORKDIR /opt/cfx-server
EXPOSE 30120/tcp 30121/tcp 30120/udp 30121/udp 40120/tcp 40121/tcp 6001/tcp 6002/tcp
ENTRYPOINT ["/opt/cfx-server/ld-musl-x86_64.so.1", "FXServer"]
