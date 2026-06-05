
import SwiftUI

struct FormHelperText: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 3) {
            Text(label)
                .font(AppFonts.gilroyRegular(13))
                .foregroundStyle(.gray)

            Text(value)
                .font(AppFonts.nunitoSemiBold(13))
                .foregroundStyle(Color(hex: "#78C143"))
        }
    }
}
