import SwiftUI

struct FormInputContainer<Content: View>: View {
    let borderColor: Color
    let content: Content

    init(
        borderColor: Color = Color.black.opacity(0.18),
        @ViewBuilder content: () -> Content
    ) {
        self.borderColor = borderColor
        self.content = content()
    }

    var body: some View {
        content
            .frame(height: 48)
            .padding(.horizontal, 18)
            .background(AppColors.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
