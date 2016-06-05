# shellcheck disable=SC2148

<< 'MARKDOWN'
n is a function that extends [n](https://github.com/tj/n)

*Usage*

```
n
```

Does one thing resolves a version from .node-version or package.json and passes it to n.

Passing any arguments to n will transparently skip this version resolution.

Paths without .node-version or package.json will go directly to the n interactive picker.
MARKDOWN

n() {
   # forward straght to n
   [[ $# > 0 ]] && {
      command n "$@"
      return
   }

   # look for a local-version

   [[ -f .node-version ]] && {
      echo using .node-version
      command n $(cat .node-version) && node --version
      return
   }

   [[ -f package.json ]] && {
      echo checking package.json
      if command -v jq > /dev/null; then
         command n $(jq -r '.engines.node | match("[>= ]*(.+)") | .captures[0].string' package.json) && node --version
         return
      else
         echo "could not parse package.json, missing jq — please 'brew install jq'"
      fi
   }

   # use n's interactive picker
   command n
}
