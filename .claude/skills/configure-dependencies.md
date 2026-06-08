# 配置项目依赖

## 描述
为子项目配置内部项目间依赖或外部依赖，修改 Dependencies.lua。

## 触发条件
用户需要让一个项目链接另一个项目，或引入外部库。

## 执行步骤

### 内部项目依赖

1. 确认被依赖项目已注册在 `Build.lua` 中
2. 在 `Dependencies.lua` 中添加：
```lua
ProjIncludeDir["被依赖项目名"] = "%{wks.location}/被依赖项目名/include"
```
3. 在依赖方的 `.lua` 文件中：
   - `includedirs` 加入 `%{DepIncludeDir["被依赖项目名"]}` 或直接用 ProjIncludeDir
   - `links` 加入 `"被依赖项目名"`

### 外部依赖

1. 将外部依赖放入 `Extension/MultiExtend/Dependencies/<库名>/`
2. 在 `Dependencies.lua` 中添加：
```lua
DepIncludeDir["库名"] = "%{wks.location}/Extension/MultiExtend/Dependencies/库名"
```
3. 在使用方的 `.lua` 文件中加入对应的 `includedirs` 和 `links`

## 注意事项
- 外部依赖根目录固定为 `Extension/MultiExtend/Dependencies/`
- Dependencies.lua 只声明变量，实际引用在各项目的 `.lua` 中完成
