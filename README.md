# Garden Linux package linux-6.1


## Release a new version

1. Create a orig tarball an upload it to pritine-lfs branch
```
# replace X with latest full version of 6.1
./prepare-orig 6.1.X

git push origin pristine-lfs
```


2. Create a git tag with respective 6.1 version uploaded in first step. Required tag format listed below

```
# linux version: e.g. 6.1.X, where X is the latest patchlevel for 6.1
# gardenlinux-patchlevel: start with 1, increase by 1 if new version with same kernel version must be released
gardenlinux/<linux-version>-0gardenlinux<gardenlinux-patchlevel>
```


Please find a general Garden Linux package versioning guide [here](https://gitlab.com/gardenlinux/gardenlinux-package-build/-/blob/main/README.md#versioning)
