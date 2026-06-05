import SwiftUI

struct InlineValidationMessage: View {
    let message: String?

    var body: some View {
        if let message, !message.isEmpty {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 12))

                Text(message)
                    .font(AppFonts.gilroyRegular(12))
            }
            .foregroundStyle(.red)
            .padding(.top, 2)
        }
    }
}
