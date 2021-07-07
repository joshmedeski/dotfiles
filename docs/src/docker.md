---
sidebar: auto
---

# Docker

## Networking

### Access native services on Docker for linux

To access a native service on a linux computer from inside a Docker container (ex: `localhost:3000`) you have to add the following to the `docker-compose.yaml`:

```yaml
  graphql-engine:
    image: hasura/graphql-engine:v1.3.3
    environment:
      EVENT_TRIGGER_URL:'http://host.docker.internal:3000/api/event-triggers'
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

**Note:** In the environmental variable, `localhost` is replaced with `host.docker.internal` and the `extra_hosts` connects the internal network to the host's gateway.

- [Docker container to connect localhost of host](https://djangocas.dev/blog/docker-container-to-connect-localhost-of-host/#google_vignette)
- [Access native services on Docker host via host.docker.internal](https://megamorf.gitlab.io/2020/09/19/access-native-services-on-docker-host-via-host-docker-internal/)

## Resources

- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [How to Fix Docker Permission Denied Error on Ubuntu](https://linuxhandbook.com/docker-permission-denied/)
