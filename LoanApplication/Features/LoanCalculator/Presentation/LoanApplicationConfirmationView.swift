import SwiftUI

struct LoanApplicationConfirmationView: View {
    let summary: LoanApplicationSummary
    let onBack: () -> Void
    let onClose: () -> Void
    let onConfirm: (LoanApplicationSummary) -> Void

    @State private var isSubmitting = false
    @State private var showSuccess = false

    var body: some View {
        VStack(spacing: 0) {
            ApplyLoanHeaderView(
                title: "Apply Loan",
                onBack: onBack,
                onClose: onClose
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    loanDetailsSection
                    disbursementDetailsSection
                    repaymentDetailsSection
                }
                .padding(.horizontal, 36)
                .padding(.top, 42)
                .padding(.bottom, 120)
            }

            confirmButton
        }
        .background(AppColors.screenBackground)
        .ignoresSafeArea(edges: .top)
        .fullScreenCover(isPresented: $showSuccess) {
            LoanApplicationSuccessView {
                showSuccess = false
                onConfirm(summary)
            }
        }
    }

    private var loanDetailsSection: some View {
        SummarySectionView(title: "Loan Details") {
            SummaryRowView(
                title: "Loan Amount:",
                value: formatMoney(summary.loanAmount),
                isHighlighted: true
            )

            SummaryRowView(
                title: "Interest:",
                value: formatMoney(summary.interestAmount)
            )

            SummaryRowView(
                title: "Total Charges:",
                value: formatMoney(summary.totalCharges)
            )

            SummaryRowView(
                title: "Period:",
                value: "\(summary.periodMonths) Months"
            )
        }
    }

    private var disbursementDetailsSection: some View {
        SummarySectionView(title: "Disbursement Details") {
            SummaryRowView(
                title: "Account:",
                value: summary.accountNumber
            )

            SummaryRowView(
                title: "Amount:",
                value: formatMoney(summary.disbursementAmount)
            )
        }
    }

    private var repaymentDetailsSection: some View {
        SummarySectionView(title: "Repayment Details", showDivider: false) {
            SummaryRowView(
                title: "Amount:",
                value: formatMoney(summary.repaymentAmount)
            )

            SummaryRowView(
                title: "Installments:",
                value: "\(summary.installments)"
            )

            SummaryRowView(
                title: "Next Repayment Date:",
                value: summary.nextRepaymentDate
            )
        }
    }

    private var confirmButton: some View {
        Button {
            submitConfirmation()
        } label: {
            Group {
                if isSubmitting {
                    ProgressView()
                        .tint(AppColors.white)
                } else {
                    Text("Confirm")
                        .font(AppFonts.nunitoSemiBold(16))
                        .foregroundStyle(AppColors.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(hex: "#78C143"))
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .disabled(isSubmitting)
        .padding(.horizontal, 36)
        .padding(.bottom, 34)
        .background(AppColors.screenBackground)
    }

    private func submitConfirmation() {
        guard !isSubmitting else {
            return
        }

        isSubmitting = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isSubmitting = false
            showSuccess = true
        }
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
}


