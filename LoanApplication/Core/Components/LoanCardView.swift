import SwiftUI

struct LoanCardView: View {
    let product: LoanProduct
    let onApply: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    product.startColor,
                    product.endColor
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: AppSpacing.responsive(10)) {
                    Text(product.title)
                        .font(AppFonts.gilroyRegular(AppSpacing.responsive(20)))
                        .foregroundStyle(AppColors.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Text(product.subtitle.replacingOccurrences(of: "\n", with: " "))
                        .font(AppFonts.gilroyRegular(AppSpacing.responsive(16)))
                        .foregroundStyle(AppColors.white.opacity(0.9))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: AppSpacing.responsive(8))

                    Button(action: onApply) {
                        HStack(spacing: AppSpacing.responsive(12)) {
                            Text("Apply Now")
                                .font(AppFonts.gilroyRegular(AppSpacing.responsive(15)))

                            Image(systemName: "chevron.right")
                                .font(.system(size: AppSpacing.responsive(13), weight: .semibold))
                        }
                        .foregroundStyle(AppColors.cardButtonText)
                        .padding(.leading, AppSpacing.responsive(16))
                        .padding(.trailing, AppSpacing.responsive(14))
                        .padding(.vertical, AppSpacing.responsive(9))
                        .background(AppColors.cardButtonBackground.opacity(0.9))
                        .clipShape(Capsule())
                    }
                }
                .padding(.leading, AppSpacing.responsive(18))
                .padding(.vertical, AppSpacing.responsive(18))
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: AppSpacing.loanCardImageWidth,
                        height: AppSpacing.loanCardImageHeight
                    )
                    .padding(.trailing, AppSpacing.responsive(8))
                    .padding(.bottom, AppSpacing.responsive(4))
            }
        }
        .frame(height: AppSpacing.loanCardHeight)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppSpacing.loanCardCornerRadius,
                style: .continuous
            )
        )
    }
}
