
### macos-dotfiles

A loose toolset along with a bunch of useful configuration which I like. This could be forked and adapted, but bootstrapping is simple:

:warning: careful, this will clobber `~/.bash_profile` and `~/.bashrc` :warning:

```sh
git clone git@github.com:mfdj/macos-dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

To get upstream changes:

```sh
cd ~/dotfiles
git pull
./setup.sh
```

### Design

Like most dotfiles this is an evolving, curated collection of choices. It's both a repository of knowledge and a tool for system-lifecycle management. It's curated, highly personalized to my experience and evolving with my tastes and needs.

It's design goals are:

- Be mildly portable. This project aims to work across multiple machines using the current stable version of macOS. The project was conceived late 2015 for OSX 10.11 (El Captain) and it's worked well across multiple major version upgrades.
- Be idempotent-ish. It should bootstrap a fresh machine or refresh a current install with a degree of parity and predictability.
- Be low overhead. Setup and updates should be dead simple. Initializing a new shell should be imperceptibly fast: definitely less than a second. The impetus for `setup.sh` file was to eliminate heavy, worthless dynamic behavior in my previous efforts.
- Be iterable. Similar to being idempotent, it should be easy to publish and consume changes. Or in other words: use git and github :angel:.

### Contributing

Best to fork your own! Although I'm happy to entertain constructive issues or pull-requests.
