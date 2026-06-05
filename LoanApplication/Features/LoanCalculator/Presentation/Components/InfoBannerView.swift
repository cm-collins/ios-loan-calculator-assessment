import SwiftUI

struct InfoBannerView: View {
    let message: String

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color(hex: "#78C143"))

            VStack(alignment: .leading, spacing: 6) {
                Text("Info")
                    .font(AppFonts.nunitoSemiBold(20))
                    .foregroundStyle(Color(hex: "#006B4F"))

                Text(message)
                    .font(AppFonts.gilroyRegular(15))
                    .foregroundStyle(Color(hex: "#575A66"))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(Color(hex: "#F8FFF4"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(.horizontal, 12)
        .shadow(color: Color.black.opacity(0.10), radius: 8, x: 0, y: 4)
    }
}
