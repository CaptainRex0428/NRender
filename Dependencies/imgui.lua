project "ImGui"
	kind "StaticLib"
	language "C++"

	location (LocationDir)
	targetdir (TargetDir)
	objdir (ObjectDir)

	files
	{
		"imgui/imconfig.h",
		"imgui/imgui.h",
		"imgui/imgui.cpp",
		"imgui/imgui_draw.cpp",
		"imgui/imgui_internal.h",
		"imgui/imgui_widgets.cpp",
		"imgui/imstb_rectpack.h",
		"imgui/imstb_textedit.h",
		"imgui/imstb_truetype.h",
		"imgui/imgui_demo.cpp",
		"imgui/imgui_tables.cpp"
	}

	filter "system:windows"
		systemversion "latest"
		cppdialect "C++20"
		staticruntime "On"
		defines {"_WINDOWS"}

	filter "system:linux"
		pic "On"
		systemversion "latest"
		cppdialect "C++20"
		staticruntime "On"
		defines {"_LINUX"}

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"
		defines{"_DEBUG"}

	filter "configurations:Release"
		runtime "Release"
		optimize "Speed"
		defines{"_RELEASE","NDEBUG"}


	filter "configurations:Dist"
		runtime "Release"
		optimize "on"
		defines{"_DIST","NDEBUG"}
