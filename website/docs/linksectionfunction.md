Specifies whether the compiler places each function in its own section, so the linker can remove or fold functions individually.

```lua
linksectionfunction ("value")
```

### Parameters ###

`value` is one of:

| Value | Description |
|-------|-------------|
| On    | Emit individual function items in separate sections. |
| Off   | Do not enable forced separate sections for function items. |

Not needed for Mach-O objects, which the linker already splits at symbol boundaries. In Visual Studio projects, [functionlevellinking](functionlevellinking.md) controls the same setting and takes precedence if both are set.

### Applies To ###

Project configurations.

### Availability ###

Premake 5.0.0-beta4 or later for Visual Studio Android projects. Premake 5.0.1 or later for all other toolsets.

### Examples ###

```lua
filter "configurations:Release"
   linksectionfunction "On"
   deadcodestripping "On"
```

### See Also ###

* [linksectiondata](linksectiondata.md)
* [deadcodestripping](deadcodestripping.md)
* [identicalcodefolding](identicalcodefolding.md)
