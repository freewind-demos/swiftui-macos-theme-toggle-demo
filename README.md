# SwiftUI macOS Theme Toggle Demo

最小 SwiftUI macOS demo。展示 `light` / `dark` theme，右上角 `switch` 一点即切，窗口内容立即按 `preferredColorScheme` 变换。

## run

```bash
./dev-swift
```

命令行构建：

```bash
./scripts/build.sh
```

仅构建不拉起：

```bash
./dev-swift --no-open
```

## main points

- `@State private var forcedScheme`：唯一主题状态
- `Toggle`：唯一修改入口
- `.preferredColorScheme(forcedScheme)`：把浅/深色强制压到窗口子树
- `ColorScheme` + 系统语义色：让背景、文案、强调色同步变化
