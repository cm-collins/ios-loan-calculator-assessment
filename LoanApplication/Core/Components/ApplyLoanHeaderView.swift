
import SwiftUI

struct ApplyLoanHeaderView: View {
    let title: String
    let onBack: () -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack {
            AppColors.headerDarkGreen

            // Decorative right shape
            HStack {
                Spacer()

                Rectangle()
                    .fill(Color.black.opacity(0.12))
                    .frame(width: 120, height: 130)
                    .rotationEffect(.degrees(-35))
                    .offset(x: 34, y: -8)
            }

            // Decorative left shape
            HStack {
                Rectangle()
                    .fill(Color.black.opacity(0.12))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-38))
                    .offset(x: -52, y: 30)

                Spacer()
            }

            HStack {
                Button(action: onBack) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(AppColors.white)
                }

                Spacer()

                Text(title)
                    .font(AppFonts.gilroyMedium(16))
                    .foregroundStyle(AppColors.white)

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(AppColors.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 42)
        }
        .frame(height: 102)
    }
}
