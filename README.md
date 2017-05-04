## Docker Webvirtmgr

### Usage

```
$ docker run -d \
  -p 8080:8080 -p 6080:6080 \
  -e USER=admin -e EMAIL=admin@localhost -e PASSWORD=123456abcd \
  -v /data:/data
  robtimmer/webvirtmgr
```

### Environment variables

_USER: the username (used to login)_

_EMAIL: the email address_

_PASSWORD: the password (used to login)_

### libvirtd configuration on the host

```
$ cat /etc/default/libvirt-bin
start_libvirtd="yes"
libvirtd_opts="-d -l"
```

```
$ cat /etc/libvirt/libvirtd.conf
listen_tls = 0
listen_tcp = 1
listen_addr = "172.17.42.1"  ## Address of docker0 veth on the host
unix_sock_group = "libvirtd"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
auth_tcp = "none"
auth_tls = "none"
```

```
$ cat /etc/libvirt/qemu.conf
# This is obsolete. Listen addr specified in VM xml.
# vnc_listen = "0.0.0.0"
vnc_tls = 0
# vnc_password = ""
```