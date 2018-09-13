# cgroups example

Demonstrates how different can be latency with same CPU-time percentage.

## running
On debian-like hosts do:
```
sudo apt-get install cgroup-tools
sudo ./test.sh
```

For non-Debian you propably know better what to install :-)

## what this output tells us?
You can easily catch this up seeing `test.sh` and `latency_warn.go`
