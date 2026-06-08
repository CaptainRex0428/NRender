# 新增子项目

## 描述
基于 CommonCPPTemplate 的 premake 模板，为工程新增一个子项目（EXE/Lib/Dll/Dll_SRT）。

## 触发条件
用户要求新增一个项目/模块/库，且需要集成到当前 workspace。

## 前置条件
- 用户已明确项目类型（EXE / Lib / Dll / Dll_SRT）
- 用户已明确项目名称

## 执行步骤

### Step 1: 选择模板
根据项目类型从 `template/lua/` 复制：
- `EXE.lua` → ConsoleApp
- `Lib.lua` → StaticLib
- `Dll.lua` → SharedLib（动态 CRT）
- `Dll_SRT.lua` → SharedLib（静态 CRT）

### Step 2: 创建项目 lua 文件
将模板复制到项目根目录，重命名为 `<项目名>.lua`。

### Step 3: 配置项目 lua 文件
修改以下字段：
- `project "<项目名>"` — 改为实际项目名
- `files {}` — 填入源码文件模式
- `includedirs {}` — 填入头文件目录
- `links {}` — 填入依赖库名
- `defines {}` — 填入预处理宏

### Step 4: 注册到 Build.lua
在 `Build.lua` 的 `group ""` 块中添加：
```lua
include "<项目名>.lua"
```

### Step 5: 创建目录结构
- `<项目名>/src/` — 源文件
- `<项目名>/include/` — 公共头文件（如需要）

### Step 6: 生成解决方案
运行：`Scripts/premake/premake5.exe --file=Build.lua vs2022`

### Step 7: 更新 Dependencies（如需要）
如果其他项目需要链接此新项目，在 `Dependencies.lua` 中添加：
```lua
ProjIncludeDir["<项目名>"] = "%{wks.location}/<项目名>/include"
Library["<项目名>"] = "<项目名>"
```

## 注意事项
- 不要修改 `Directory.lua` 中的路径变量
- 不要修改模板文件本身（template/lua/ 下的文件）
- Dll/Dll_SRT 会自动通过 postbuild 将 dll 拷贝到 EXE 同级目录
- 新增 Lib 后，需要链接它的项目在 links 中加入项目名
