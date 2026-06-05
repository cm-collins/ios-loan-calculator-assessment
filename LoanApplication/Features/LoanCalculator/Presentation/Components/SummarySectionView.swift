import SwiftUI

struct SummarySectionView<Content: View>: View {
    let title: String
    let showDivider: Bool
    let content: Content

    init(
        title: String,
        showDivider: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showDivider = showDivider
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.gilroyMedium(18))
                .foregroundStyle(AppColors.primaryText)

            VStack(spacing: 14) {
                content
            }

            if showDivider {
                Rectangle()
                    .fill(Color.black.opacity(0.22))
                    .frame(height: 1)
                    .padding(.horizontal, 24)
                    .padding(.top, 18)
            }
        }
    }
}
