FROM docker.io/busybox:latest
ARG GIT_COMMIT=unkown
LABEL GIT_COMMIT=$GIT_COMMIT
ADD ./hello.sh ./
EXPOSE 8080 8443
CMD ["./hello.sh"]
