
import SwiftUI

struct RepaymentScheduleRowView: View {
    let title: String
    let amount: String

    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.gilroyRegular(14))
                .foregroundStyle(AppColors.primaryText)

            Spacer()

            Text(amount)
                .font(AppFonts.nunitoSemiBold(16))
                .foregroundStyle(AppColors.primaryText)
        }
    }
}
