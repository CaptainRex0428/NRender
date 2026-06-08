# CommonCPPTemplate 项目结构与开发约定

## 项目概述
这是一个基于 Premake5 的 C++20 标准模板工程，用于作为后续所有 CPP 子项目的起点模板。
目标平台：Windows x64，IDE：VS2022 / Rider / Fork。

## 构建系统

### Premake5 工作流
- 入口：`Build.lua`，定义 workspace 名称、架构、配置
- 生成命令：`Scripts/premake/premake5.exe --file=Build.lua vs2022`
- 快捷方式：运行 `Scripts/GenerateWIN.bat`
- Rider/Fork 中有 RefreshConfig 运行配置可一键触发

### 文件职责

| 文件 | 职责 |
|---|---|
| `Build.lua` | workspace 定义 + include 所有子项目 |
| `Config.lua` | IDE 集成：Rider run config / Fork custom commands |
| `Directory.lua` | 所有输出路径变量定义 |
| `Dependencies.lua` | 外部依赖/include 路径/链接库声明 |
| `EntryProject.lua` | 入口 EXE 项目的 premake 配置 |
| `template/lua/*.lua` | 4 种项目类型模板（EXE/Lib/Dll/Dll_SRT） |

### 编译配置（三种）

| 配置 | Runtime | 优化 | 符号 | 宏定义 |
|---|---|---|---|---|
| Debug | Debug | Off | On | `_DEBUG` |
| Release | Release | On | On | `_RELEASE`, `NDEBUG` |
| Dist | Release | On | Off | `_DIST`, `NDEBUG` |

### MSVC 编译选项（workspace 级别）
- `/EHsc` — 启用 C++ 异常处理
- `/Zc:preprocessor` — 标准预处理器行为
- `/Zc:__cplusplus` — 正确报告 `__cplusplus` 值
- `/utf-8` — 源文件编码 UTF-8

---

## 目录约定与输出路径

### 源码目录
- `src/` — `.cpp` 源文件 + 项目内部 `.h`
- `include/` — 对外暴露的公共头文件

### 输出目录（Directory.lua 定义）

```
bin/windows-x86_64/<配置>/
├── <EXE名>.exe          ← EXE 直接输出（targetdir = EXEDir）
├── <Dll名>.dll          ← DLL 通过 postbuild COPY 出来（DynamicDir）
├── <Lib名>/             ← Lib 留在子目录（TargetDir）
│   └── xxx.lib
├── <Dll名>/             ← DLL 原始编译输出
│   ├── xxx.dll
│   └── xxx.lib
└── obj/                 ← 中间文件
    └── <项目名>/
```

### 路径变量（Directory.lua）

| 变量 | 值 | 用途 |
|---|---|---|
| `LocationDir` | `settings/` | VS 工程文件(.vcxproj) 输出位置 |
| `OutputDir` | `<系统>-<架构>/<配置>` | 如 `windows-x86_64/Debug` |
| `EXEDir` | `bin/<OutputDir>` | EXE 输出位置（直接放 bin 下） |
| `LibDir` | `bin/<OutputDir>` | 预留，当前未被模板引用 |
| `DynamicDir` | `bin/<OutputDir>` | DLL postbuild 拷贝目标（与 EXE 同级） |
| `TargetDir` | `bin/<OutputDir>/<项目名>` | Lib/Dll 编译输出（子目录） |
| `ObjectDir` | `bin/obj/<OutputDir>/<项目名>` | 中间文件 |

---

## 四种项目模板

### 1. EXE（ConsoleApp）
- `kind "ConsoleApp"`
- `targetdir (EXEDir)` → 直接输出到 `bin/<out>/`
- 无 postbuild

### 2. Lib（StaticLib）
- `kind "StaticLib"`
- `targetdir (TargetDir)` → 输出到 `bin/<out>/<项目名>/`
- `warnings "off"`
- 无 postbuild

### 3. Dll（SharedLib）
- `kind "SharedLib"`
- `targetdir (TargetDir)` → 编译到 `bin/<out>/<项目名>/`
- `staticruntime "Off"`（使用 /MD，依赖系统 CRT DLL）
- **postbuildcommands**：自动 COPY `.dll` 到 `DynamicDir`（与 EXE 同级）
- `warnings "off"`

### 4. Dll_SRT（SharedLib + 静态运行时）
- `kind "SharedLib"`
- `targetdir (TargetDir)` → 编译到 `bin/<out>/<项目名>/`
- **postbuildcommands**：同 Dll，COPY 到 `DynamicDir`
- `warnings "off"`
- 设计意图：使用静态 CRT 链接（/MT），发布时不依赖 MSVC 运行时 DLL

---

## 依赖管理（Dependencies.lua）

```lua
DepIncludeDir["xxx"] = "%{wks.location}/Dependencies/xxx"   -- 外部依赖头文件
ProjIncludeDir["yyy"] = "%{wks.location}/yyy/include"        -- 项目内子项目头文件
Library["zzz"] = "zzz"                                       -- 链接库名
```

---

## Git 约定（.gitignore）

**版本控制包含：**
- 所有源码（`src/`、`include/`）
- Premake 配置（所有 `.lua`）
- `Scripts/` 工具链

**版本控制排除：**
- `bin/` — 编译产物
- `settings/` — 生成的 .vcxproj 等
- `.idea/`、`.run/`、`.codebuddy/` — IDE 配置

---

## 新增子项目的标准流程

1. 从 `template/lua/` 复制合适类型的模板到项目根目录，重命名
2. 编辑新 `.lua`：修改 project 名、`files`、`includedirs`、`links`、`defines`
3. 在 `Build.lua` 的 `group ""` 下 `include "新项目.lua"`
4. 运行 premake 生成 VS2022 解决方案
5. 在 VS2022 中打开编译

---

## 设计决策（不修改）

- EXE 输出到 `EXEDir`（bin 同级），保证运行时能直接找到 DLL
- DLL 通过 postbuild COPY 到 `DynamicDir`（与 EXE 同级）
- Lib 保留在 `TargetDir`（子目录），因为静态库不需要运行时查找
- `LibDir` 定义但未使用 — Lib 直接用 `TargetDir`，无需单独拷贝
