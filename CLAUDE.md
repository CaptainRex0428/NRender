# CLAUDE.md

## 项目概述
CommonCPPTemplate — 基于 Premake5 的 C++20 Windows x64 标准模板工程。

## 核心规则
- 不修改 `Directory.lua` 中的路径变量
- 不修改 `template/lua/` 下的模板文件
- 不修改 `Config.lua` 中的 IDE 集成逻辑
- 编译选项（MSVC flags）保持不变

## 项目类型
| 模板 | 类型 | 输出位置 | 后处理 |
|---|---|---|---|
| EXE | ConsoleApp | `EXEDir` (bin 同级) | 无 |
| Lib | StaticLib | `TargetDir` (子目录) | 无 |
| Dll | SharedLib | `TargetDir` + postbuild COPY | DLL → `DynamicDir` |
| Dll_SRT | SharedLib | `TargetDir` + postbuild COPY | DLL → `DynamicDir` |

## 关键路径
- `Build.lua` — workspace 入口，include 所有子项目
- `Directory.lua` — 所有输出路径变量
- `Dependencies.lua` — 依赖声明
- `template/lua/` — 项目模板（只读）
- `src/` — 源码（.cpp）
- `include/` — 公共头文件（.h）

## 工作流程
1. 新增子项目：复制 template → 编辑 → include 到 Build.lua → premake 生成
2. 配置依赖：编辑 Dependencies.lua + 项目 lua 文件
3. 编译：运行 premake5 生成 vs2022 解决方案，VS2022 打开编译

## Memory 自动同步规则（A+B 策略）

### B: Claude 自动提醒
当本次开发涉及以下变更时，**必须主动提醒用户**是否需要更新 memory：
- 新增/删除/重命名子项目
- 修改了 `Build.lua`、`Directory.lua`、`Dependencies.lua`
- 新增或移除了外部依赖
- 修改了核心编译策略（workspace 级别）
- 目录结构发生显著变化

提醒话术示例：
> "本次开发涉及了项目结构变更，建议运行 `/update-project-memory` 同步 memory。"

纯源码修改（.cpp/.h 逻辑变更）不需要提醒。

### A: 手动触发 Skill
用户开发完成后可手动执行 `/update-project-memory`，Claude 会：
1. 审查 git diff，判断变更类型
2. 更新 `.claude/memory/project-structure.md` 中对应部分
3. 检查 skill 是否需要新增或修订
4. 同步 `CLAUDE.md` 的项目信息
5. 输出变更摘要

## Skills
参考 `.claude/skills/` 下的技能文件执行标准化操作：

| Skill | 文件 | 用途 |
|---|---|---|
| 新增子项目 | `new-subproject.md` | 基于模板新增 EXE/Lib/Dll/Dll_SRT |
| 配置内部依赖 | `configure-dependencies.md` | 配置项目间链接关系 |
| 新增外部依赖 | `add-external-dependency.md` | 引入第三方库到 Dependencies |
| 调整编译配置 | `modify-build-config.md` | 修改编译选项/宏/警告/优化/CRT |
| 更新项目记忆 | `update-project-memory.md` | 开发后同步 memory/skills/CLAUDE.md |

## Memory
参考 `.claude/memory/project-structure.md` 获取完整的项目结构与约定。
