include "Directory.lua"
include "Dependencies.lua"
include "Config.lua"

workspace "CommonCPPTemplate"
	architecture "x64"
	startproject "EntryProject"
	configurations
	{
		"Debug",
		"Release",
        "Dist"
	}

    filter "system:windows"
    buildoptions { "/EHsc", "/Zc:preprocessor", "/Zc:__cplusplus","/utf-8" }

	add_rider_refreshconfig()
	add_fork_custom_commands()

group ""
	include "EntryProject.lua"