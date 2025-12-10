### global gitconfig

Much of this is good, some of this depends on certain software (Kaleidoscope, sourcetree)

```
[core]
	editor = nano
	excludesfile = /Users/mfox/.gitignore_global
	pager = delta
[user]
	name = Mark Fox
	email = mfox@zendesk.com

[interactive]
    diffFilter = delta --color-only

[difftool "Kaleidoscope"]
	cmd = ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"

[mergetool "Kaleidoscope"]
	cmd = ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot
	trustExitCode = true

[diff]
	tool = Kaleidoscope

[difftool]
	prompt = false
	trustExitCode = true

[merge]
	tool = Kaleidoscope
	conflictstyle = diff3

[mergetool]
	prompt = false

[delta]
    navigate = true
[difftool "sourcetree"]
	cmd = opendiff \"$LOCAL\" \"$REMOTE\"
	path = 
[mergetool "sourcetree"]
	cmd = /Applications/Sourcetree.app/Contents/Resources/opendiff-w.sh \"$LOCAL\" \"$REMOTE\" -ancestor \"$BASE\" -merge \"$MERGED\"
	trustExitCode = true
[commit]
	template = /Users/mfox/.stCommitMsg
[branch]
	sort = -committerdate
```
