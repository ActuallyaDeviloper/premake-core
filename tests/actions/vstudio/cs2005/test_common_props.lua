--
-- tests/actions/vstudio/cs2005/test_common_props.lua
-- Check Visual Studio 2012 extensions to the project properties block.
-- Copyright (c) 2013 Jason Perkins and the Premake project
--

	local suite = test.declare("vs2012_csproj_common_props")
	local cs2005 = premake.vstudio.cs2005


--
-- Setup
--

	local wks, prj

	function suite.setup()
		_ACTION = "vs2012"
		wks = test.createWorkspace()
		language "C#"
	end

	local function prepare()
		prj = premake.solution.getproject(wks, 1)
		cs2005.commonProperties(prj)
	end


---
-- Visual Studio 2012 omits <ProductVersion> and <SchemaVersion>.
---

	function suite.onDefaultCommonProps()
		prepare()
		test.capture [[
	<Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
		]]
	end
