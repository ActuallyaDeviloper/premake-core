--
-- tests/tools/test_linksection.lua
-- Test linksectionfunction and linksectiondata APIs and their integration with the toolsets.
-- Copyright (c) 2026 Jess Perkins and the Premake project
--

	local suite = test.declare("test_linksection")
	local p = premake
	local msc = p.tools.msc
	local gcc = p.tools.gcc
	local clang = p.tools.clang


--
-- Setup
--

	local wks, prj, cfg

	function suite.setup()
		wks = test.createWorkspace()
	end

	local function prepare()
		prj = test.getproject(wks, 1)
		cfg = test.getconfig(prj, "Debug")
	end


--
-- Toolset flags
--

	function suite.on_msc()
		linksectionfunction "On"
		linksectiondata "On"
		prepare()
		test.contains("/Gy", msc.getcflags(cfg))
		test.contains("/Gw", msc.getcflags(cfg))
	end

	function suite.off_msc()
		linksectionfunction "Off"
		linksectiondata "Off"
		prepare()
		test.contains("/Gy-", msc.getcflags(cfg))
		test.contains("/Gw-", msc.getcflags(cfg))
	end

	function suite.on_gcc()
		linksectionfunction "On"
		linksectiondata "On"
		prepare()
		test.contains("-ffunction-sections", gcc.getcflags(cfg))
		test.contains("-fdata-sections", gcc.getcflags(cfg))
	end

	function suite.off_gcc()
		linksectionfunction "Off"
		linksectiondata "Off"
		prepare()
		test.contains("-fno-function-sections", gcc.getcflags(cfg))
		test.contains("-fno-data-sections", gcc.getcflags(cfg))
	end

	function suite.on_clang()
		linksectionfunction "On"
		linksectiondata "On"
		prepare()
		test.contains("-ffunction-sections", clang.getcflags(cfg))
		test.contains("-fdata-sections", clang.getcflags(cfg))
	end
