[About Apple Property Lists](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html)

`defaults` can read/write keys in plist files.

To read every active plist in a concatenated dictionary:

```
defaults read > defaults-before
```

Make some changes in system-preferences and then

```
defaults read > defaults-after
```

Then

```
ksdiff defaults-{before,after}
```

Locate the file of a particular difference

```
find /Library/Preference* ~/Library/Preference* -name '*com.apple.spaces*'
```

Then read that files-keys

```
defaults read ~/Library/Preferences/com.apple.spaces SpacesDisplayConfiguration
```

But that key is a complex-hash, enter PlistBuddy:

http://superuser.com/questions/486630/reading-values-from-plist-nested-dictionaries-in-shell-script

```
find / -name '*PlistBuddy*' 2> /dev/null
/usr/libexec/PlistBuddy -h
```

Then

```
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.spaces.plist -c 'print :SpacesDisplayConfiguration:Space\ Properties:0:windows'
```
