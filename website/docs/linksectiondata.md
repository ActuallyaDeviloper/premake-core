Specifies whether the compiler places each global variable in its own section, so the linker can remove or fold data individually.

```lua
linksectiondata ("value")
```

### Parameters ###

`value` is one of:

| Value | Description |
|-------|-------------|
| On    | Emit individual data items in separate sections. |
| Off   | Do not enable forced separate sections for data items. |

Not needed for Mach-O objects, which the linker can split at symbol boundaries anyway. `/Gw` requires Visual Studio 2013 Update 2 or later.

### Applies To ###

Project configurations.

### Availability ###

Premake 5.0.0-beta4 or later for Visual Studio Android projects. Premake 5.0.1 or later for all other toolsets.

### Examples ###

```lua
filter "configurations:Release"
   linksectiondata "On"
   deadcodestripping "On"
```

### See Also ###

* [linksectionfunction](linksectionfunction.md)
* [deadcodestripping](deadcodestripping.md)
* [identicalcodefolding](identicalcodefolding.md)
