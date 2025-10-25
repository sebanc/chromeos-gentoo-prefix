# Gentoo prefix for ChromeOS / Brunch

## Overview

This project consists in providing a Gentoo prefix that can be installed in ChromeOS (with developer mode enabled) or Brunch.  

## Install instructions

The gentoo prefix will be installed in /usr/local (which is actually on the data partition) and takes about 2GB of space.  

1. Switch to a tty2 (CTRL+ALT+F2), login as "chronos" and run the below commant to ensure that /usr/local is owned by chronos user:  
```
sudo chown -R 1000:1000 /usr/local
```

2. Switch back to ChromeOS (CTRL+ALT+F1) and Download the ChromeOS gentoo prefix release.  

3. Open crosh shell (CTRL+ALT+T) and extract the ChromeOS gentoo prefix release in /usr/local:  
```
tar zxf <chromeos_gentoo_prefix_tarball> -C /usr/local
```

4. Run `startprefix` to enter the gentoo prefix and emerge the packages you need (refer to gentoo documentation).  

5. To exit the gentoo prefix, type `exit`.  
