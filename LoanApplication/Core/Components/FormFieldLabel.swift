
import SwiftUI

struct FormFieldLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppFonts.gilroyRegular(14))
            .foregroundStyle(.gray)
    }
}
