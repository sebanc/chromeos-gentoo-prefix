# Building the ChromeOS Gentoo prefix

### Requirements

- root access.  
- `coreutils` and `curl` packages.  

## Getting the source

Clone the main branch and enter the source directory:  

```
git clone -b main https://github.com/sebanc/chromeos-gentoo-prefix.git
cd chromeos-gentoo-prefix
```

## Building

To build the ChromeOS Gentoo prefix, you need to have root access and 3 GB of free disk space available.  

1. Launch the build (as root):  
```
sudo ./build.sh
```
3. Make yourself a coffee (the build will take around 1 hour, it mostly depends on your cpu and hdd speed).  

4. That's it. You should have a ChromeOS Gentoo prefix archive in your current directory.  

