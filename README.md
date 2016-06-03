
### mfdj's opinionated, detailed bash configuration on osx

I'd highly suggest forking and reading the source-code first, but bootstrapping is simple:

:warning: careful, this will clobber `~/.bash_profile` and `~/.bashrc` :warning:

```
git clone git@github.com:mfdj/osx-dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

To get upstream changes:

```
cd ~/dotfiles
git pull
./setup.sh
```

### Design

Like most dotfiles this is an evolving, curated collection of choices. It's both a repository of knowledge and a tool for system-lifecycle management. It's curated, highly personalized to my experience and evolving with my tastes and needs.

It's design goals are:

- Be mildly portable. This project aims to work across multiple machines using the current stable version of OSX. The project was conceived late 2015 for OSX 10.11 (El Captain).
- Be idempotent-ish. It should bootstrap a fresh machine or refresh a current install with a degree of parity and predictability.
- Be low overhead. Setup and updates should be dead simple. Initializing a new shell should be imperceptibly fast: definitely less than a second. The impetus for `setup.sh` file was to eliminate heavy, worthless dynamic behavior in my previous efforts.
- Be iterable. Similar to being idempotent, it should be easy to publish and consume changes. Or in other words: use git and github :angel:.

### Features

ToDo: write about the nice things!

### Contributing

Best to fork your own! Although I'm happy to hear entertain constructive issues or pull-requests.
