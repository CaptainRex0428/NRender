# 调整编译配置

## 描述
修改项目的编译选项、预处理宏、链接选项、警告设置等编译相关配置。

## 触发条件
用户需要调整某个项目或全局的编译行为，例如：
- 添加/删除预处理宏（defines）
- 修改警告级别
- 调整优化选项
- 添加编译选项（buildoptions）
- 修改语言标准

## 可调整的层级

### 1. Workspace 级别（影响所有项目）
在 `Build.lua` 中修改，当前配置：
```lua
workspace "CommonCPPTemplate"
    architecture "x64"
    configurations { "Debug", "Release", "Dist" }
    filter "system:windows"
    buildoptions { "/EHsc", "/Zc:preprocessor", "/Zc:__cplusplus", "/utf-8" }
```

### 2. 项目级别（只影响单个项目）
在具体项目的 `.lua` 文件中修改。

### 3. 配置级别（Debug/Release/Dist）
在项目 `.lua` 的 `filter "configurations:xxx"` 块中修改。

## 执行步骤

### 添加预处理宏

**全局添加**（所有项目生效）：
在 `Build.lua` 的 workspace filter 中添加 defines。

**单项目添加**：
在项目 `.lua` 的 `defines {}` 中添加：
```lua
defines
{
    "MY_MACRO",
    "KEY=VALUE",
}
```

**特定配置添加**：
在项目 `.lua` 的对应 filter 块中添加：
```lua
filter "configurations:Debug"
    defines { "ENABLE_LOGGING" }
```

### 修改编译选项（buildoptions）

在项目 `.lua` 中修改 `buildoptions`：
```lua
buildoptions { "/EHsc", "/Zc:preprocessor", "/Zc:__cplusplus", "/utf-8", "/W4" }
```

常用 MSVC 选项：
- `/W4` — 详细警告
- `/WX` — 警告当错误
- `/bigobj` — 增加对象文件节上限
- `/MP` — 多进程编译
- `/std:c++20` — 指定 C++ 标准（通常用 cppdialect 代替）

### 修改警告设置

```lua
warnings "off"   -- 关闭所有警告
warnings "on"    -- 开启警告
-- 或在 buildoptions 中细粒度控制：
buildoptions { "/w14062" }  -- 开启特定警告
buildoptions { "/wd4100" }  -- 关闭特定警告
```

### 修改语言标准

```lua
cppdialect "C++20"   -- 当前默认
-- 可选值：C++14, C++17, C++20, C++23
```

### 修改优化选项

在配置 filter 中：
```lua
filter "configurations:Release"
    optimize "Full"        -- /Ox 全优化
    -- 可选值：Off, On, Speed, Full
```

### 修改运行时库（CRT）

```lua
filter "system:windows"
    staticruntime "On"    -- /MT（静态链接 CRT）
    staticruntime "Off"   -- /MD（动态链接 CRT，默认）
```

### 添加链接选项（linkoptions）

```lua
linkoptions { "/FORCE:MULTIPLE" }
```

### 添加链接库

```lua
links
{
    "kernel32",
    "user32",
    "MyLib",           -- 内部子项目
    Library["zlib"],   -- 外部依赖
}
```

## 完整的项目 lua 文件结构参考

```lua
project "MyProject"
    kind "ConsoleApp"          -- 或 StaticLib / SharedLib
    language "C++"
    cppdialect "C++20"

    files { "src/**.cpp", "include/**.h" }
    includedirs { "include" }
    links { }
    defines { }

    buildoptions { "/EHsc", "/Zc:preprocessor", "/Zc:__cplusplus", "/utf-8" }
    warnings "off"             -- Lib/Dll 模板默认 off，EXE 可选

    location (LocationDir)
    targetdir (EXEDir)         -- EXE 用 EXEDir，Lib/Dll 用 TargetDir
    objdir (ObjectDir)

    filter "system:windows"
        systemversion "latest"
        defines { "_WINDOWS" }

    filter "configurations:Debug"
        runtime "Debug"
        symbols "On"
        defines { "_DEBUG" }

    filter "configurations:Release"
        runtime "Release"
        optimize "On"
        symbols "On"
        defines { "_RELEASE", "NDEBUG" }

    filter "configurations:Dist"
        runtime "Release"
        optimize "On"
        symbols "Off"
        defines { "_DIST", "NDEBUG" }
```

## 注意事项
- 修改 Build.lua 需要重新运行 premake 才能生效
- 修改 workspace 级别选项会影响所有项目，谨慎操作
- `filter` 块是累积的，注意作用域
- premake 的 `filter` 会应用到后续所有设置，直到下一个 filter 出现
- 修改后记得在 VS2022 中重新加载解决方案
