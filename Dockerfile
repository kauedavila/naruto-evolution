FROM douglasparker/byond:514.1584
LABEL org.opencontainers.image.source https://github.com/douglasparker/naruto-evolution
WORKDIR /opt/naruto-evolution
COPY naruto-evolution.dmb naruto-evolution.rsc VERSION CHANGELOG.md  ./