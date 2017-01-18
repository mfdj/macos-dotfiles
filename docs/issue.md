
### trying to declare a function that is already alias

Example:

```
-bash: /Users/markfox/dotfiles/functions/uhistory.sh: line 2: syntax error near unexpected token `('
-bash: /Users/markfox/dotfiles/functions/uhistory.sh: line 2: `uhistory() {'
```

Or 

```
→ uhistory() { :; }
-bash: syntax error near unexpected token `('
```

Diagnose if alias exists:

```
uhistory is aliased to `history | grep -v history | cut -d " " -f 4- | uniq | tail -n'
```

Solution:

```
unalias uhistory
```

