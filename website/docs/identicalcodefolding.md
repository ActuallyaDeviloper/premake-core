Specifies whether the linker folds identical functions and read-only data (identical code folding).

```lua
identicalcodefolding ("value")
```

### Parameters ###

`value` is one of:

| Value   | Description |
|---------|-------------|
| Default | Uses the toolset default.                                                                                                |
| Off     | Disables folding.                                                                                                        |
| All     | Folds all identical functions. Breaks the C++ standard contract, as distinct values/functions may then share an address. |
| Safe    | Folds only where function addresses stay distinct.                                                                       |

If identical code folding is not supported, the setting is ignored.

Notes on toolchain support:
 - Generally all linkers except the classic GNU ld (the BFD linker from binutils) support identical code folding, including lld, gold, mold, link.exe and Apple's "ld64". For this reason however, if no [linker](linker.md) is specified, the setting does not take effect except for Apple and Windows.
 - Additionally GCC can safely fold at compile time within one translation unit.
 - Apple's "ld64" linker support is a bit limited. In particular it only folds weak definitions (such as template instances).
 - Except for Mach-O, linkers can only fold functions and data placed in separate sections. To benefit, enable [linksectionfunction](linksectionfunction.md) and [linksectiondata](linksectiondata.md).
 - "link.exe" has no safe mode, so `Safe` disables folding there.

### Applies To ###

Project configurations.

### Availability ###

Premake 5.0.1 or later.

### Examples ###

```lua
filter "configurations:Release"
   identicalcodefolding "All"
   linksectionfunction "On"
```

### See Also ###

* [deadcodestripping](deadcodestripping.md)
* [linker](linker.md)
* [linksectiondata](linksectiondata.md)
* [linksectionfunction](linksectionfunction.md)
