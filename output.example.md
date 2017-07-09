## Example of the output.

#### Systems are not vulnerable, good job.

```
$ ./dont_cry.sh
[+] Running Petya/WannaCry Vuln scan against Windows Fleet ...
[+] Nmap done: 746 IP addresses (245 hosts up) scanned in 10.08 seconds
[+] No systems vulnerable
```

#### Systems are vulnerable, better start patching. 

```
$ ./dont_cry.sh
[+] Running Petya/WannaCry Vuln scan against Windows Fleet...
[+] Nmap done: 256 IP addresses (17 hosts up) scanned in 5.28 seconds
[+] Systems Vulnerable: 4 IP Address: 192.168.1.33 192.168.1.23 192.168.1.18 192.168.1.249
```
