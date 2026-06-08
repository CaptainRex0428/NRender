# 更新项目记忆

## 描述
在开发完成后，审查本次变更是否涉及项目结构、依赖关系、编译策略、新增子项目等内容，自动更新 `.claude/` 下的 memory 和 skills 文件，保持与项目实际状态一致。

## 触发条件
- 用户完成一轮开发后，手动执行 `/update-project-memory`
- 用户说"更新 memory"、"同步 memory"、"更新记录"等

## 执行步骤

### Step 1: 审查本次变更
读取当前 git 状态，分析本次开发涉及的变更：
```
git diff --name-only
git status
```

识别以下类型的变更：
- 新增/删除/重命名了子项目
- 修改了 `Build.lua`、`Directory.lua`、`Dependencies.lua`
- 修改了某个项目的 `.lua` 配置
- 新增了外部依赖
- 修改了目录结构（新增 src/include 子目录等）
- 修改了编译配置（宏/选项/CRT/警告等）

### Step 2: 判断是否需要更新

仅当变更涉及以下方面时才需要更新 memory：
- **需要更新 memory**：新增/删除子项目、修改了路径策略、新增了外部依赖、修改了核心编译配置、目录结构变化
- **不需要更新 memory**：纯源码修改（.cpp/.h）、只改了某个项目的 files 列表、bug fix

### Step 3: 更新 memory 文件

读取当前 `.claude/memory/project-structure.md`，对比实际项目状态，更新以下部分：

#### 如果新增/删除了子项目：
- 更新 `project-structure.md` 中的项目列表
- 确认 Build.lua 的 group 结构是否正确记录

#### 如果新增了外部依赖：
- 更新 `project-structure.md` 中的依赖管理部分
- 更新 Dependencies.lua 的实际内容摘要

#### 如果修改了编译配置：
- 更新 `project-structure.md` 中对应的配置说明

#### 如果修改了 Directory.lua 的路径策略：
- 更新 `project-structure.md` 中的输出路径说明
- 同步到 `CLAUDE.md` 中的项目类型表

### Step 4: 检查是否需要新增/更新 skill

评估本次变更是否引入了新的可复用流程：
- 如果出现了新的操作模式 → 建议创建新 skill
- 如果已有 skill 的流程不再适用 → 更新对应 skill
- 如果所有 skill 仍然适用 → 不修改

### Step 5: 更新 CLAUDE.md

检查 `CLAUDE.md` 中的核心规则、项目类型表、关键路径是否与实际一致，如有变化则同步更新。

### Step 6: 输出变更摘要

向用户报告：
```
本次更新了以下文件：
- [updated] .claude/memory/project-structure.md: 新增了 XxxLib 项目记录
- [no change] .claude/skills/*: 现有 skill 仍然适用
- [no change] CLAUDE.md: 无需更新
```

或：
```
本次无需更新 memory，所有内容与实际状态一致。
```

## 注意事项
- 只更新因本次开发而变化的部分，不要大面积重写
- 保持 memory 的原有风格和格式
- 如果不确定是否需要更新，向用户确认
- 不要删除用户手动添加的自定义内容
- 更新前先读取当前文件内容，确保基于最新状态修改
