Specifies whether the linker removes unreferenced functions and data.

```lua
deadcodestripping ("value")
```

### Parameters ###

`value` is one of:

| Value   | Description |
|---------|-------------|
| Default | Uses the toolset default.                |
| On      | Removes unreferenced functions and data. |
| Off     | Keeps unreferenced functions and data.   |

Except for Mach-O, linkers can only remove functions and data placed in separate sections. To benefit, enable [linksectionfunction](linksectionfunction.md) and [linksectiondata](linksectiondata.md).

Note that on Windows, turning this on also enables full [identicalcodefolding](identicalcodefolding.md) `All`, unless `identicalcodefolding` is explicitly configured.

### Applies To ###

Project configurations.

### Availability ###

Premake 5.0.1 or later.

### Examples ###

```lua
filter "configurations:Release"
   deadcodestripping "On"
   linksectionfunction "On"
   linksectiondata "On"
```

### See Also ###

* [identicalcodefolding](identicalcodefolding.md)
* [linksectiondata](linksectiondata.md)
* [linksectionfunction](linksectionfunction.md)
