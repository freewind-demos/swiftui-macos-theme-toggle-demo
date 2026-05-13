import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var forcedScheme: ColorScheme = .light
    @State private var draftText = """
    Theme preview notes

    这里是小号 TextEditor。
    主要看浅色 / 深色下：
    - 文本对比
    - 插入点
    - 选区高亮
    """

    private var isDarkMode: Binding<Bool> {
        Binding(
            get: { forcedScheme == .dark },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.35)) {
                    forcedScheme = newValue ? .dark : .light
                }
            }
        )
    }

    private var themeName: String {
        colorScheme == .dark ? "Dark" : "Light"
    }

    private var accent: Color {
        colorScheme == .dark ? .cyan : .orange
    }

    private var heroBackground: LinearGradient {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(red: 0.10, green: 0.12, blue: 0.20), Color(red: 0.02, green: 0.38, blue: 0.46)]
                : [Color(red: 1.00, green: 0.95, blue: 0.82), Color(red: 1.00, green: 0.67, blue: 0.44)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            hero
            swatches
            editorCard
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background)
        .ignoresSafeArea(edges: .top)
        .preferredColorScheme(forcedScheme)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: colorScheme == .dark ? "moon.stars.fill" : "sun.max.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(.white)

                        Text("\(themeName) Theme")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }

                    Text("小开关放右上。下面保留语义色卡，再补一个小号 TextEditor 看编辑态。")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 16)

                VStack(alignment: .trailing, spacing: 6) {
                    Toggle("", isOn: isDarkMode)
                        .labelsHidden()
                        .toggleStyle(.switch)
                        .scaleEffect(0.84)

                    Text(themeName)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.92))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(.white.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            Text("切换后，背景、文案、卡片阴影、编辑区会一起变化。")
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.82))
        }
        .padding(24)
        .background(heroBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: accent.opacity(colorScheme == .dark ? 0.28 : 0.18), radius: 24, y: 14)
    }

    private var swatches: some View {
        HStack(spacing: 18) {
            swatchCard(
                title: "Background",
                detail: colorScheme == .dark ? "深色底 + 柔和高光" : "浅色底 + 暖色反射",
                fill: Color(nsColor: .windowBackgroundColor),
                foreground: .primary
            )

            swatchCard(
                title: "Accent",
                detail: colorScheme == .dark ? "cyan action" : "orange action",
                fill: accent,
                foreground: .white
            )

            swatchCard(
                title: "Primary Text",
                detail: colorScheme == .dark ? "高对比亮字" : "高对比深字",
                fill: .primary,
                foreground: colorScheme == .dark ? .black : .white
            )
        }
        .frame(maxWidth: .infinity)
    }

    private var editorCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TextEditor Preview")
                .font(.headline)

            TextEditor(text: $draftText)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .scrollContentBackground(.hidden)
                .padding(12)
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .background(editorBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.primary.opacity(colorScheme == .dark ? 0.14 : 0.08), lineWidth: 1)
                )
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var editorBackground: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(colorScheme == .dark
                ? Color(red: 0.11, green: 0.13, blue: 0.17)
                : Color(red: 0.99, green: 0.96, blue: 0.88))
    }

    private var background: some View {
        ZStack {
            Color(nsColor: .controlBackgroundColor)

            Circle()
                .fill(accent.opacity(colorScheme == .dark ? 0.18 : 0.14))
                .frame(width: 300, height: 300)
                .blur(radius: 30)
                .offset(x: -220, y: -150)

            Circle()
                .fill(.primary.opacity(colorScheme == .dark ? 0.10 : 0.05))
                .frame(width: 260, height: 260)
                .blur(radius: 36)
                .offset(x: 240, y: 160)
        }
        .ignoresSafeArea()
    }

    private func swatchCard(
        title: String,
        detail: String,
        fill: Color,
        foreground: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(fill)
                .frame(height: 160)
                .overlay(
                    Image(systemName: "circle.lefthalf.filled")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(foreground.opacity(0.92))
                )

            Text(title)
                .font(.title3.weight(.semibold))

            Text(detail)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.primary.opacity(0.08), lineWidth: 1)
        )
    }
}
