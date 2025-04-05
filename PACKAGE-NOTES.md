# Package Notes

SanDisk does not provide a versioned download URL. This means the installer binary's checksum will periodically change, and a newly released software version will break this package version. Consequently, FOSS users should generally consider older package versions to be obsolete and unsupported. Obsolete package versions may be unlisted if the Chocolatey CDN has not cached the download before obsoletion.

Consider [internalizing this package](https://docs.chocolatey.org/en-us/guides/create/recompile-packages) if you require a stable binary, or the ability to install this specific version after a new version is released.

---

Two installer packages are published for SanDisk Dashboard: an online bootstrapper and offline (standalone) installer. This package consumes the offline installer to ensure the binary behaves consistently (i.e. always installs a given version), and to avoid an external dependency on connectivity to SanDisk's servers. Publishing of the offline installer package is occasionally delayed or skipped, so the packaged version may therefore lag behind what is offered via the software's update functionality (i.e. via the online bootstrapper).

---

When SanDisk Dashboard is being silently uninstalled (during either a package upgrade or uninstall operation), you may see the following message printed to `stderr`:

```shell
ERROR: The process "Dashboard.exe" not found.
```

Note that this only refers to an uninstall step that involves terminating the process if it is currently running. If Dashboard is not currently running, it is not indicative of an error condition, and can be safely ignored.

Because this is a non-critical error, it's recommended to ensure the `failOnStandardError` feature is disabled when upgrading/uninstalling this package.

---

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:

```shell
choco feature enable --name="'useRememberedArgumentsForUpgrades'"
```
