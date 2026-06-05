import SwiftUI

struct ActiveLoanCardView: View {
    let summary: LoanApplicationSummary

    var body: some View {
        VStack(spacing: AppSpacing.responsive(20)) {
            VStack(spacing: AppSpacing.responsive(4)) {
                Text("Salary E-Loan Balance")
                    .font(AppFonts.nunitoSemiBold(AppSpacing.responsive(20)))
                    .foregroundStyle(Color(hex: "#006B4F"))

                Text(formatMoney(summary.repaymentAmount))
                    .font(AppFonts.nunitoSemiBold(AppSpacing.responsive(34)))
                    .foregroundStyle(Color(hex: "#006B4F"))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }

            HStack(spacing: 0) {
                VStack(spacing: AppSpacing.responsive(8)) {
                    Text("Next Payment")
                        .font(AppFonts.gilroyRegular(AppSpacing.responsive(15)))
                        .foregroundStyle(.gray)

                    Text(formatMoney(nextPaymentAmount))
                        .font(AppFonts.nunitoSemiBold(AppSpacing.responsive(17)))
                        .foregroundStyle(Color(hex: "#575A66"))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color.black.opacity(0.32))
                    .frame(width: 1, height: AppSpacing.responsive(52))

                VStack(spacing: AppSpacing.responsive(8)) {
                    Text("Instalment")
                        .font(AppFonts.gilroyRegular(AppSpacing.responsive(15)))
                        .foregroundStyle(.gray)

                    Text(summary.nextRepaymentDate)
                        .font(AppFonts.nunitoSemiBold(AppSpacing.responsive(17)))
                        .foregroundStyle(Color(hex: "#575A66"))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, AppSpacing.responsive(26))
        .padding(.horizontal, AppSpacing.responsive(18))
        .frame(maxWidth: .infinity)
        .background(AppColors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.black.opacity(0.10), lineWidth: 1)
        )
        .shadow(
            color: Color(hex: "#006B4F").opacity(0.16),
            radius: 10,
            x: 6,
            y: 8
        )
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var nextPaymentAmount: Decimal {
        guard summary.installments > 0 else {
            return 0
        }

        return roundedMoney(summary.repaymentAmount / Decimal(summary.installments))
    }

    private func formatMoney(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let number = NSDecimalNumber(decimal: value)
        let formatted = formatter.string(from: number) ?? "0.00"

        return "\(formatted) KES"
    }

    private func roundedMoney(_ value: Decimal) -> Decimal {
        var value = value
        var result = Decimal()

        NSDecimalRound(&result, &value, 2, .bankers)

        return result
    }
}
