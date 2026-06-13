# Tally

一款面向个人用户的 iOS 记账 App，覆盖**日常支出、投资理财、人情借贷**三大场景，
目标是在一个 App 内看清个人净资产全貌。数据本地优先（SwiftData），iCloud 同步可选。

- 技术栈：**SwiftUI + SwiftData（iOS 17+）**
- 设计文档见 [`docs/`](./docs/)（PRD、产品形态、数据模型、行情接入、对比评审）

## 工程结构

```
Tally/
├── TallyApp.swift              # @main 入口，注册 ModelContainer
├── RootView.swift              # 底部 4 Tab + 全局 FAB
├── AppSchema.swift             # SwiftData Schema 与预览容器
├── Models/                     # SwiftData @Model 实体 + 枚举
├── Features/                   # 各功能模块视图（按模块分目录）
│   ├── Overview/               # 总览（净资产）
│   ├── Ledger/                 # 日常账本
│   ├── Investment/             # 投资理财
│   ├── Credit/                 # 信用账本
│   └── Settings/               # 设置 / 账户·分类·平台管理
└── Shared/                     # 通用组件、主题、服务
    ├── Theme/                  # 语义配色
    ├── Components/             # 可复用 UI（卡片、空状态、时间段选择器）
    └── Services/               # PriceProvider 行情接入抽象
```

> 当前为**框架骨架 + 功能模块占位**：实体与导航结构已就绪，各页面以占位内容
> 标注后续实现点（`// TODO:`）。

## 构建

项目使用 [XcodeGen](https://github.com/yonsei/XcodeGen) 由 `project.yml` 生成
`.xcodeproj`（不纳入版本库）：

```bash
brew install xcodegen   # 若未安装
xcodegen generate       # 生成 Tally.xcodeproj
open Tally.xcodeproj     # 用 Xcode 打开，选择 iOS 17+ 模拟器运行
```
