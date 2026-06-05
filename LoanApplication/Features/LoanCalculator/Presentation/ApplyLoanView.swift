import SwiftUI

struct ApplyLoanView: View {
    let selectedLoanTitle: String
    let onBack: () -> Void
    let onClose: () -> Void
    let onLoanConfirmed: (LoanApplicationSummary) -> Void

    @StateObject private var viewModel: ApplyLoanViewModel
    @State private var showConfirmation = false

    init(
        selectedLoanTitle: String,
        onBack: @escaping () -> Void,
        onClose: @escaping () -> Void,
        onLoanConfirmed: @escaping (LoanApplicationSummary) -> Void
    ) {
        self.selectedLoanTitle = selectedLoanTitle
        self.onBack = onBack
        self.onClose = onClose
        self.onLoanConfirmed = onLoanConfirmed

        _viewModel = StateObject(
            wrappedValue: ApplyLoanViewModel(selectedLoanTitle: selectedLoanTitle)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            ApplyLoanHeaderView(
                title: "Apply Loan",
                onBack: onBack,
                onClose: onClose
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    loanTypeSection
                    loanAmountSection
                    loanPeriodSection
                    disbursementAccountSection
                    repaymentSummarySection
                    repaymentScheduleSection

                    if let generalErrorMessage = viewModel.generalErrorMessage {
                        Text(generalErrorMessage)
                            .font(AppFonts.gilroyRegular(13))
                            .foregroundStyle(.red)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 36)
                .padding(.top, 34)
                .padding(.bottom, 120)
            }

            applyButton
        }
        .background(AppColors.screenBackground)
        .ignoresSafeArea(edges: .top)
        .onChange(of: viewModel.state) { _, newState in
            if newState == .success {
                showConfirmation = true
            }
        }
        .fullScreenCover(isPresented: $showConfirmation) {
            if let summary = viewModel.confirmationSummary {
                LoanApplicationConfirmationView(
                    summary: summary,
                    onBack: {
                        showConfirmation = false
                    },
                    onClose: onClose,
                    onConfirm: { confirmedSummary in
                        showConfirmation = false
                        onLoanConfirmed(confirmedSummary)
                        onClose()
                    }
                )
            }
        }
    }

    private var loanTypeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormFieldLabel(title: "Loan Type")

            Menu {
                ForEach(viewModel.loanOptions) { loan in
                    Button(loan.title) {
                        viewModel.selectLoan(loan)
                    }
                }
            } label: {
                FormInputContainer {
                    HStack {
                        Text(viewModel.selectedLoan?.title ?? selectedLoanTitle)
                            .font(AppFonts.gilroyMedium(16))
                            .foregroundStyle(AppColors.primaryText)

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                    }
                }
            }

            FormHelperText(label: "Interest:", value: viewModel.interestRateText)
        }
    }

    private var loanAmountSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormFieldLabel(title: "Loan Amount")

            FormInputContainer(
                borderColor: viewModel.amountErrorMessage == nil
                ? Color.black.opacity(0.18)
                : .red
            ) {
                HStack(spacing: 14) {
                    Text("KES")
                        .font(AppFonts.gilroyMedium(16))
                        .foregroundStyle(AppColors.primaryText)

                    Rectangle()
                        .fill(Color.black.opacity(0.25))
                        .frame(width: 1, height: 28)

                    TextField(
                        "Amount",
                        text: Binding(
                            get: { viewModel.loanAmount },
                            set: { viewModel.updateLoanAmount($0) }
                        )
                    )
                    .keyboardType(.decimalPad)
                    .font(AppFonts.gilroyMedium(16))
                    .foregroundStyle(AppColors.primaryText)
                }
            }

            InlineValidationMessage(message: viewModel.amountErrorMessage)

            FormHelperText(
                label: "Available Loan Limit:",
                value: viewModel.loanLimitText
            )
        }
    }

    private var loanPeriodSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormFieldLabel(title: "Loan Period (months)")

            FormInputContainer(
                borderColor: viewModel.periodErrorMessage == nil
                ? Color.black.opacity(0.18)
                : .red
            ) {
                HStack {
                    TextField(
                        "Period",
                        text: Binding(
                            get: { viewModel.loanPeriod },
                            set: { viewModel.updateLoanPeriod($0) }
                        )
                    )
                    .keyboardType(.numberPad)
                    .font(AppFonts.gilroyMedium(16))
                    .foregroundStyle(AppColors.primaryText)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundStyle(.gray)
                }
            }

            InlineValidationMessage(message: viewModel.periodErrorMessage)

            FormHelperText(
                label: "Total Amount Payable:",
                value: viewModel.totalPayableText
            )
        }
    }

    private var disbursementAccountSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormFieldLabel(title: "Disbursement Account")

            Menu {
                ForEach(viewModel.accounts) { account in
                    Button {
                        viewModel.selectAccount(account)
                    } label: {
                        Text("\(account.accountNumber) - \(account.accountName)")
                    }
                    .disabled(!account.isActive)
                }
            } label: {
                FormInputContainer(
                    borderColor: viewModel.accountErrorMessage == nil
                    ? Color.black.opacity(0.18)
                    : .red
                ) {
                    HStack {
                        Text(viewModel.selectedAccount?.accountNumber ?? "Select Account")
                            .font(AppFonts.gilroyMedium(16))
                            .foregroundStyle(AppColors.primaryText)

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                    }
                }
            }

            InlineValidationMessage(message: viewModel.accountErrorMessage)

            FormHelperText(
                label: "Available Loan Limit:",
                value: viewModel.loanLimitText
            )
        }
    }

    private var repaymentSummarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            FormHelperText(
                label: "Monthly Instalment:",
                value: viewModel.monthlyInstallmentText
            )

            FormHelperText(
                label: "Total Payable:",
                value: viewModel.totalPayableText
            )
        }
        .padding(.top, 4)
    }

    private var repaymentScheduleSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Repayment Schedule")
                .font(AppFonts.gilroyMedium(22))
                .foregroundStyle(AppColors.primaryText)
                .padding(.top, 8)

            ForEach(viewModel.repaymentSchedule) { installment in
                RepaymentScheduleRowView(
                    title: installment.title,
                    amount: viewModel.formatMoney(installment.amount)
                )
            }
        }
    }

    private var applyButton: some View {
        Button {
            viewModel.applyLoan()
        } label: {
            Group {
                if viewModel.state == .submitting {
                    ProgressView()
                        .tint(AppColors.white)
                } else {
                    Text("Apply Loan")
                        .font(AppFonts.nunitoSemiBold(16))
                        .foregroundStyle(AppColors.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                viewModel.isApplyButtonEnabled
                ? Color(hex: "#78C143")
                : Color.gray.opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .disabled(!viewModel.isApplyButtonEnabled)
        .padding(.horizontal, 36)
        .padding(.bottom, 34)
        .background(AppColors.screenBackground)
    }
}

#Preview {
    ApplyLoanView(
        selectedLoanTitle: "Salary E-Loan",
        onBack: {},
        onClose: {},
        onLoanConfirmed: { _ in }
    )
}
