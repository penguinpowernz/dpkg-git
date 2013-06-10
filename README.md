dpkg-git
========

A Debian package to allow installing from a git repository with valid Debian control files.

## How to install

```sh
wget http://penguinpowernz.github.io/dpkg-git/dpkg-git_latest.deb;
sudo dpkg -i dpkg-git_latest.deb;
```

## How to use

Build a package from a local repository:

```sh
$ dpkg-git -b my-cool-repo.git
my-cool-repo_1.0_all.deb
```

Build a package from a github repo:

```sh
$ dpkg-git -b https://github.com/penguinpowernz/dork-detector.git                                                                               4 ↵
Cloning into '/tmp/src/dork-detector'...
remote: Counting objects: 23, done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 23 (delta 1), reused 20 (delta 0)
Unpacking objects: 100% (23/23), done.
dork-detector_0.1_all.deb
```

Install a package from a local repo:

```sh
dpkg-git -i iprules 
(Reading database ... 127358 files and directories currently installed.)
Preparing to replace iprules 1.0.2 (using /tmp/iprules_1.1_all.deb) ...
Unpacking replacement iprules ...
Setting up iprules (1.1) ...
Do you want to install default rules? [y]es,[N]o,[o]verwrite: n
You can find default rules in /usr/share/iprules/rules/
```

Install a package from a github repo:

```sh
$ dpkg-git -i https://github.com/penguinpowernz/dork-detector.git
Cloning into '/tmp/src/dork-detector'...
remote: Counting objects: 23, done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 23 (delta 1), reused 20 (delta 0)
Unpacking objects: 100% (23/23), done.
Selecting previously unselected package dork-detector.
(Reading database ... 127351 files and directories currently installed.)
Unpacking dork-detector (from /tmp/dork-detector_0.1_all.deb) ...
Setting up dork-detector (0.1) ...
/usr/bin/gcc
Building dump_cdorked_config...
```

Install a package from a github repo (with failing dependencies):

```sh
$ dpkg-git -i https://github.com/penguinpowernz/observium-agent.git
Cloning into '/tmp/src/observium-agent'...
remote: Counting objects: 140, done.
remote: Compressing objects: 100% (107/107), done.
remote: Total 140 (delta 35), reused 102 (delta 16)
Receiving objects: 100% (140/140), 59.07 KiB | 74 KiB/s, done.
Resolving deltas: 100% (35/35), done.
Selecting previously unselected package observium-agent.
(Reading database ... 127311 files and directories currently installed.)
Unpacking observium-agent (from .../observium-agent_0.1.0-alpha_all.deb) ...
dpkg: dependency problems prevent configuration of observium-agent:
 observium-agent depends on xinetd; however:
  Package xinetd is not installed.
 observium-agent depends on check-mk-agent; however:
  Package check-mk-agent is not installed.

dpkg: error processing observium-agent (--install):
 dependency problems - leaving unconfigured
Errors were encountered while processing:
 observium-agent
```
