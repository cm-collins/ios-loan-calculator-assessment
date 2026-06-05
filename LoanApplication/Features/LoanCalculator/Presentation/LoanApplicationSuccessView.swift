import SwiftUI

struct LoanApplicationSuccessView: View {
    let onGoHome: () -> Void

    var body: some View {
        ZStack {
            Color(hex: "#272935")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                successCard
            }
            .padding(.horizontal, 26)
        }
    }

    private var successCard: some View {
        VStack(spacing: 0) {
            Text("Request Sent Successfully")
                .font(AppFonts.nunitoSemiBold(22))
                .foregroundStyle(Color(hex: "#78C143"))
                .multilineTextAlignment(.center)
                .padding(.top, 30)

            successIcon
                .padding(.top, 28)

            Text("Your loan request has been\nsubmitted successfully.")
                .font(AppFonts.gilroyRegular(20))
                .foregroundStyle(Color(hex: "#575A66"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, 30)
                .padding(.horizontal, 24)

            goHomeButton
                .padding(.horizontal, 46)
                .padding(.top, 34)
                .padding(.bottom, 34)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var successIcon: some View {
        Image("loan_success_icon")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .accessibilityLabel("Loan request submitted successfully")
    }

    private var goHomeButton: some View {
        Button {
            onGoHome()
        } label: {
            Text("Go Home")
                .font(AppFonts.nunitoSemiBold(20))
                .foregroundStyle(AppColors.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(Color(hex: "#78C143"))
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
    }
}

#Preview {
    LoanApplicationSuccessView(onGoHome: {})
}
