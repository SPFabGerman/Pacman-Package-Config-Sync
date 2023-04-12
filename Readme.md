# Pacman Package Config Sync

A script that can manage your installed pacman packages using a config file.

## Summary

The purpose of this script is to keep track of your installed packages and help you maintain a consistent environment.
It does this by keeping track of your (explicitly) installed packages in a config file and mirrors all changes to that config file to your system.
In practice that means: Add a package name to the config file and it is installed to your system; remove a package name and it is uninstalled.
Therefor this config file servers as a reliable representation of all your installed packages.

This has many advantages:
- **Reproduceable system**: setting up a new computer with all the necessary packages is as easy as copying the config file and executing the script
- **Keep different computers consistent**: if you use more than one computer, you can easily keep the installed packages between them consistent, in the same way you keep all your other config files consistent (e.g. via git)
- **Comments and Documentation**: you can add comments to your config file explaining why and for what reason (or what projects) you installed certain packages; you can also group packages logically together
- **Keep system clean**: the config file gives you a good overview of all your installed packages, which makes it easy to find packages that you no longer use and can be uninstalled

## Usage

### Generate new config file

After installing the script on your path you have to generate the config file with:
```
pacman-package-config-sync --generate-config
```
This generates a new configuration file in `~/.config/system-package-config/pacman-packages`, representing your current system.

### Use old config file

If you already have a config file that you want to use, just copy it to `~/.config/system-package-config/pacman-packages`.
After that you can install all listed packages with:
```
pacman-package-config-sync --commit
```

### Editing the config file

After you generated (or copied) a config file you can edit is as you like.
You can rearrange the packages as you like.
Comments are started with `#` and can be placed on a whole line or at the end of a line.
Additionally empty lines are ignored.

You can review which changes would be made with:
```
pacman-package-config-sync --dry-run
```
(Using `--dry-run` is the default, if no other option is specified.)

If everything looks okay you can install and remove the packages accordingly with:
```
pacman-package-config-sync --commit
```

## Notes on safety

While the goals of this project are to make package management easier, it is also an explicit goal to make it safe to use in all (or most) situations.
The script is design with safety in mind and contains some optional safety measures to prevent you from accidentally messing something up catastrophically.
All of these safety measures are enabled by default, but can be temporarily disabled using flags or be completely disabled using the config.
Keep in mind, that this script is supposed to be an assistant and helper, not an automation tool.

Some notable safety measure are:
- No actions without explicit confirmation: By default the script only displays changes that would be made. To actually make these changes you have to pass the `--commit` flag. It also means we don't pass `--noconfirm` to pacman and all installation and removals have to be confirmed manually.
- No management of dependencies: This script is not supposed to manage the dependency hell. That is the job of pacman. We only manage the packages that are explicitly installed.
- No removal of necessary packages: If you delete a package from the config that is a dependency for another package, we don't uninstall it, but only mark it as not explicitly installed anymore (so as a dependency for another package).
- No accidentall deletion of configured packages: If the config file lists a package that is already installed, we ensure it is marked as explicitly installed, so it is not removed by any future cleanups. We assume that all packages in the config file are listed there for a reason and not just as a necessary dependence.
- No continuation on failure: If pacman fails for whatever reason, we assume something went wrong and stop immediatly.
- No more packages than necessary, Keep a clean system: Uninstalling a package also uninstalls all dependencies that are no longer needed. We don't keep useless packages around. An additional cleanup is performed after all other operations, removing all true orphans. (Packages that were installed as a dependency, but are no longer depended on.)
- No outdated packages: Before any operation, an update of the entire system is performed, to ensure we are not working with outdated dependencies or packages.

## Additional Notes

At the moment we only manage packages installed through pacman. There is no support for other package managers or packages installed from the AUR.
But support for other package managers and distributions is planned to come eventually.
My main focus right now is to get full support for one package manager (pacman) right and feature-complete.

Also im kinda in Proof-of-concepts phase right now.
While the script is working as intended, I plan to eventually rewrite it in a real programming language to get rid of all the bash ballast.

