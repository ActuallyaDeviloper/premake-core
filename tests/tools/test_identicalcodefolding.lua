--
-- tests/tools/test_identicalcodefolding.lua
-- Test identicalcodefolding API and its integration with the toolsets.
-- Copyright (c) 2026 Jess Perkins and the Premake project
--

	local suite = test.declare("test_identicalcodefolding")
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
-- msc has no safe mode.
--

	function suite.off_msc()
		identicalcodefolding "Off"
		prepare()
		test.contains("/OPT:NOICF", msc.getldflags(cfg))
	end

	function suite.all_msc()
		identicalcodefolding "All"
		prepare()
		test.contains("/OPT:ICF", msc.getldflags(cfg))
	end

	function suite.safe_msc_doesNotFold()
		identicalcodefolding "Safe"
		prepare()
		test.contains("/OPT:NOICF", msc.getldflags(cfg))
	end


--
-- gcc folds at compile time, and at link time only with LLD.
--

	function suite.safe_gcc_compiler()
		identicalcodefolding "Safe"
		prepare()
		test.contains("-fipa-icf", gcc.getcflags(cfg))
	end

	function suite.all_gcc_defaultLinker()
		system "Linux"
		identicalcodefolding "All"
		prepare()
		test.excludes("-Wl,--icf=all", gcc.getldflags(cfg))
	end

	function suite.all_gcc_lld()
		system "Linux"
		linker "LLD"
		identicalcodefolding "All"
		prepare()
		test.contains("-fipa-icf", gcc.getcflags(cfg))
		test.contains("-Wl,--icf=all", gcc.getldflags(cfg))
	end

	function suite.off_gcc_lld()
		system "Linux"
		linker "LLD"
		identicalcodefolding "Off"
		prepare()
		test.contains("-fno-ipa-icf", gcc.getcflags(cfg))
		test.contains("-Wl,--icf=none", gcc.getldflags(cfg))
	end


--
-- clang has no compile time folding, but needs the address-significance table for safe folding with LLD.
--

	function suite.all_clang_noCompilerFlag()
		identicalcodefolding "All"
		prepare()
		test.excludes("-fipa-icf", clang.getcflags(cfg))
	end

	function suite.safe_clang_lld_addrsig()
		system "MacOSX"
		linker "LLD"
		identicalcodefolding "Safe"
		prepare()
		test.contains("-faddrsig", clang.getcflags(cfg))
		test.contains("-Wl,--icf=safe", clang.getldflags(cfg))
	end


--
-- Apple's ld64 always folds safely.
--

	function suite.off_clang_macosx()
		system "MacOSX"
		identicalcodefolding "Off"
		prepare()
		test.contains("-Wl,-no_deduplicate", clang.getldflags(cfg))
	end

	function suite.safe_clang_macosx_folds()
		system "MacOSX"
		identicalcodefolding "Safe"
		prepare()
		test.excludes("-Wl,-no_deduplicate", clang.getldflags(cfg))
		test.excludes("-faddrsig", clang.getcflags(cfg))
	end


--
-- clang on Windows uses MSVC style options.
--

	function suite.off_clang_windows()
		system "Windows"
		identicalcodefolding "Off"
		prepare()
		test.contains("-Xlinker /OPT:NOICF", clang.getldflags(cfg))
	end

	function suite.all_clang_windows()
		system "Windows"
		identicalcodefolding "All"
		prepare()
		test.contains("-Xlinker /OPT:ICF", clang.getldflags(cfg))
	end

	function suite.safe_clang_windows_lld()
		system "Windows"
		linker "LLD"
		identicalcodefolding "Safe"
		prepare()
		test.contains("-Xlinker /OPT:SAFEICF", clang.getldflags(cfg))
		test.excludes("-Wl,--icf=safe", clang.getldflags(cfg))
	end

	function suite.safe_clang_windows_defaultLinker_doesNotFold()
		system "Windows"
		identicalcodefolding "Safe"
		prepare()
		test.contains("-Xlinker /OPT:NOICF", clang.getldflags(cfg))
	end


--
-- Folding prevents incremental linking.
--

	function suite.canLinkIncremental_all()
		identicalcodefolding "All"
		prepare()
		test.isfalse(p.config.canLinkIncremental(cfg))
	end
