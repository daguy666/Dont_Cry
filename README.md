# Dont_Cry
This is a wrapper shell script using the nmap scripting engine to scan for systems vulnerable to petya and wannacry a cron might be needed to run this frequently

#### Requirements 
- Nmap 
  - Obtain it here https://nmap.org/
  - or `brew install nmap`
- I used version `7.50` of nmap. 
  - Specifically this nmap script `vuln-ms17-010.nse`
- $DIR exists. (Create it where ever you want.)
- If nmaps path is different than `/usr/local/bin/nmap` you will have to change the path.

---

#### Recommendations 
- I would recommend putting this on a cron. 
- Writing a quick script to clean up the mess from the day and put that on a 24 hour cron.

--- 
#### TODOs 
- Clean up the code a bit.
- Have a file check that the path of nmap and $DIR exist.
- Have this log out to a file on runtime.

---
#### Other info
https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
http://thekillingtime.com/?p=438
