import SwiftUI

struct SummaryRowView: View {
    let title: String
    let value: String
    var isHighlighted: Bool = false

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AppFonts.gilroyRegular(16))
                .foregroundStyle(.gray)

            Spacer()

            Text(value)
                .font(isHighlighted ? AppFonts.nunitoSemiBold(22) : AppFonts.nunitoSemiBold(16))
                .foregroundStyle(isHighlighted ? Color(hex: "#2E7D68") : Color(hex: "#575A66"))
                .multilineTextAlignment(.trailing)
        }
    }
}
