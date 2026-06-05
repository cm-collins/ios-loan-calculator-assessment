import SwiftUI

struct AmortizationScheduleRowView: View {
    let item: AmortizationScheduleItem
    let formatMoney: (Decimal) -> String
    let formatDate: (Date) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Payment \(item.paymentNumber)")
                        .font(AppFonts.nunitoSemiBold(15))
                        .foregroundStyle(AppColors.primaryText)

                    Text(formatDate(item.dueDate))
                        .font(AppFonts.gilroyRegular(12))
                        .foregroundStyle(.gray)
                }

                Spacer()

                Text(formatMoney(item.emi))
                    .font(AppFonts.nunitoSemiBold(15))
                    .foregroundStyle(Color(hex: "#006B4F"))
            }

            Divider()

            VStack(spacing: 8) {
                detailRow(
                    title: "Interest Portion",
                    value: formatMoney(item.interestPortion)
                )

                detailRow(
                    title: "Principal Portion",
                    value: formatMoney(item.principalPortion)
                )

                detailRow(
                    title: "Remaining Balance",
                    value: formatMoney(item.remainingBalance)
                )
            }
        }
        .padding(14)
        .background(AppColors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.black.opacity(0.10), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppFonts.gilroyRegular(13))
                .foregroundStyle(.gray)

            Spacer()

            Text(value)
                .font(AppFonts.nunitoSemiBold(13))
                .foregroundStyle(Color(hex: "#575A66"))
        }
    }
}
