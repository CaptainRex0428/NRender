# 新增外部依赖

## 描述
为项目引入新的第三方库（外部依赖），包括头文件、链接库、DLL 的配置。

## 触发条件
用户需要引入一个新的第三方库（如 zlib、imgui、spdlog 等）。

## 前置条件
- 用户已明确库名称
- 用户已提供库文件（或告知获取方式）

## 依赖存放位置
所有外部依赖统一存放在：
```
Extension/MultiExtend/Dependencies/<库名>/
```

典型结构：
```
Extension/MultiExtend/Dependencies/<库名>/
├── include/          ← 头文件
│   └── xxx.h
├── lib/              ← 静态库/导入库
│   ├── x64/
│   │   ├── Debug/
│   │   └── Release/
│   └── ...
└── bin/              ← DLL（如需要）
    └── xxx.dll
```

## 执行步骤

### Step 1: 放置库文件
将库文件按上述结构放入 `Extension/MultiExtend/Dependencies/<库名>/`。

### Step 2: 声明依赖变量
在 `Dependencies.lua` 中添加：

```lua
-- 头文件路径
DepIncludeDir["<库名>"] = "%{wks.location}/Extension/MultiExtend/Dependencies/<库名>/include"

-- 库文件路径（如果需要链接 .lib）
LibDirectories["<库名>"] = "%{wks.location}/Extension/MultiExtend/Dependencies/<库名>/lib/x64"

-- 库名（链接时使用）
Library["<库名>"] = "<库名>"
```

> 注意：`DepIncludeDir`、`LibDirectories`、`Library` 三个表已在 Dependencies.lua 中预定义，直接赋值即可。

### Step 3: 在使用方项目中引用
在需要使用该依赖的项目 `.lua` 文件中：

```lua
includedirs
{
    DepIncludeDir["<库名>"],
}

links
{
    Library["<库名>"],
}

libdirs
{
    LibDirectories["<库名>"],
}
```

### Step 4: 处理 DLL（如为动态库依赖）
- 如果库的 DLL 需要运行时能找到，将其放入对应配置的 `bin/<平台>/<配置>/` 目录
- 或在 postbuildcommands 中添加拷贝逻辑

### Step 5: 重新生成解决方案
运行 premake 生成新的 VS2022 工程文件。

## 注意事项
- 外部依赖根目录固定为 `Extension/MultiExtend/Dependencies/`
- 依赖版本建议在库目录下放 `VERSION` 文件或文件夹名带版本号
- 不要将第三方库的二进制文件提交到 git（应在 .gitignore 中排除）
- 如果多个项目共用同一外部依赖，每个项目各自在 lua 中声明引用
