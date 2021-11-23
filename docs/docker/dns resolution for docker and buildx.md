# Dns resolution for Docker containers and Buildx (BuildKit)
The issue is that in order to push the images, the buildx buildkit container needs to have access to
the ip address of the registry. In order to resolve it, docker must use the dns of the host.
This cannot be done by referring 127.0.0.53 as ip address for dns, or 127.0.1.1.
We need to make resolved to bind to docker0 interface.

On `systemd` based systems with `systemd-resolved` installed, `resolved` needs to listen on the `docker0` interface.
This can be enabled by adding an extra interface inside the file `/etc/systemd/resolved.conf`.
```properties
DNSStubListenerExtra=172.17.0.1
```
Now restart the service:
```shell
$ systemctl restart systemd-resolved.service
```

Next step is to tell docker daemon to use the new DNS.
This can be done by adding the dns in the list of dns that docker uses in the file `/etc/docker/daemon.json`
```json
{
  "dns": ["172.17.0.1"]
}
```

Now restart the docker daemon:
```shell
$ systemctl restart docker.service
```

Now everything is set to be built.

This solution was described in the bellow issues:
- https://github.com/cohoe/workstation/issues/105#issuecomment-880844140
- (including more details not necessarily with systemd-resolved): https://github.com/moby/moby/issues/541#issuecomment-215987916 
