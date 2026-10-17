--
-- tests/tools/test_deadcodestripping.lua
-- Test deadcodestripping API and its integration with the toolsets.
-- Copyright (c) 2026 Jess Perkins and the Premake project
--

	local suite = test.declare("test_deadcodestripping")
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
		deadcodestripping "On"
		prepare()
		test.contains("/OPT:REF", msc.getldflags(cfg))
	end

	function suite.off_msc()
		deadcodestripping "Off"
		prepare()
		test.contains("/OPT:NOREF", msc.getldflags(cfg))
	end

	function suite.on_gcc()
		system "Linux"
		deadcodestripping "On"
		prepare()
		test.contains("-Wl,--gc-sections", gcc.getldflags(cfg))
	end

	function suite.off_gcc()
		system "Linux"
		deadcodestripping "Off"
		prepare()
		test.contains("-Wl,--no-gc-sections", gcc.getldflags(cfg))
	end

	function suite.on_clang_windows()
		system "Windows"
		deadcodestripping "On"
		prepare()
		test.contains("-Xlinker /OPT:REF", clang.getldflags(cfg))
		test.excludes("-Wl,--gc-sections", clang.getldflags(cfg))
	end

	function suite.off_clang_windows()
		system "Windows"
		deadcodestripping "Off"
		prepare()
		test.contains("-Xlinker /OPT:NOREF", clang.getldflags(cfg))
	end


--
-- Apple's ld64 uses -dead_strip and does not strip by default.
--

	function suite.on_clang_macosx()
		system "MacOSX"
		deadcodestripping "On"
		prepare()
		test.contains("-Wl,-dead_strip", clang.getldflags(cfg))
	end

	function suite.off_clang_macosx_noFlag()
		system "MacOSX"
		deadcodestripping "Off"
		prepare()
		test.excludes("-Wl,--no-gc-sections", clang.getldflags(cfg))
	end


--
-- Stripping prevents incremental linking.
--

	function suite.canLinkIncremental_on()
		deadcodestripping "On"
		prepare()
		test.isfalse(p.config.canLinkIncremental(cfg))
	end
