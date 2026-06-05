import Foundation
import Combine

struct ApplyLoanOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let annualInterestRate: Decimal
    let minimumAmount: Decimal
    let maximumAmount: Decimal
    let minimumMonths: Int
    let maximumMonths: Int
}

struct DisbursementAccount: Identifiable, Equatable {
    let id = UUID()
    let accountNumber: String
    let accountName: String
    let availableBalance: Decimal
    let isActive: Bool
}

struct RepaymentInstallment: Identifiable {
    let id = UUID()
    let title: String
    let amount: Decimal
}

enum ApplyLoanState: Equatable {
    case idle
    case submitting
    case success
    case failed(String)
}

@MainActor
final class ApplyLoanViewModel: ObservableObject {
    @Published private(set) var loanOptions: [ApplyLoanOption] = []
    @Published private(set) var accounts: [DisbursementAccount] = []

    @Published var selectedLoan: ApplyLoanOption?
    @Published var selectedAccount: DisbursementAccount?

    @Published private(set) var loanAmount: String = "10000.00"
    @Published private(set) var loanPeriod: String = "2"

    @Published private(set) var totalPayable: Decimal = 0
    @Published private(set) var interestAmount: Decimal = 0
    @Published private(set) var monthlyInstallment: Decimal = 0

    // Simple repayment rows used by older UI sections if still present.
    @Published private(set) var repaymentSchedule: [RepaymentInstallment] = []

    // Full amortization schedule required by the assessment.
    @Published private(set) var amortizationSchedule: [AmortizationScheduleItem] = []

    @Published private(set) var amountErrorMessage: String?
    @Published private(set) var periodErrorMessage: String?
    @Published private(set) var accountErrorMessage: String?
    @Published private(set) var generalErrorMessage: String?

    @Published private(set) var confirmationSummary: LoanApplicationSummary?
    @Published var state: ApplyLoanState = .idle

    private let calculatorEngine = LoanCalculatorEngine()

    init(selectedLoanTitle: String) {
        loadMockData(selectedLoanTitle: selectedLoanTitle)
        validateAndRecalculate()
    }

    func selectLoan(_ loan: ApplyLoanOption) {
        selectedLoan = loan
        clearGeneralError()
        validateAndRecalculate()
    }

    func selectAccount(_ account: DisbursementAccount) {
        selectedAccount = account
        clearGeneralError()
        validateAndRecalculate()
    }

    func updateLoanAmount(_ value: String) {
        loanAmount = sanitizeAmount(value)
        clearGeneralError()
        validateAndRecalculate()
    }

    func updateLoanPeriod(_ value: String) {
        loanPeriod = value.filter { $0.isNumber }
        clearGeneralError()
        validateAndRecalculate()
    }

    func applyLoan() {
        clearGeneralError()

        guard validateFormForSubmission() else {
            state = .failed(generalErrorMessage ?? "Please correct the highlighted fields.")
            return
        }

        guard let selectedLoan else {
            generalErrorMessage = "Please select a loan type."
            state = .failed(generalErrorMessage ?? "")
            return
        }

        guard let selectedAccount else {
            generalErrorMessage = "Please select a disbursement account."
            state = .failed(generalErrorMessage ?? "")
            return
        }

        guard let amount = Decimal(string: loanAmount) else {
            generalErrorMessage = "Invalid loan amount."
            state = .failed(generalErrorMessage ?? "")
            return
        }

        guard let months = Int(loanPeriod) else {
            generalErrorMessage = "Invalid loan period."
            state = .failed(generalErrorMessage ?? "")
            return
        }

        state = .submitting

        let input = LoanInput(
            principal: amount,
            annualInterestRate: selectedLoan.annualInterestRate,
            tenureValue: months,
            tenureUnit: .months
        )

        do {
            let result = try calculatorEngine.calculate(input: input)

            confirmationSummary = buildSummary(
                loanTitle: selectedLoan.title,
                accountNumber: selectedAccount.accountNumber,
                result: result
            )

            state = .success
        } catch {
            generalErrorMessage = error.localizedDescription
            state = .failed(error.localizedDescription)
        }
    }

    var isApplyButtonEnabled: Bool {
        amountErrorMessage == nil &&
        periodErrorMessage == nil &&
        accountErrorMessage == nil &&
        selectedLoan != nil &&
        selectedAccount?.isActive == true &&
        Decimal(string: loanAmount) != nil &&
        Int(loanPeriod) != nil &&
        state != .submitting
    }

    var loanLimitText: String {
        guard let selectedLoan else {
            return "0.00 KES"
        }

        return formatMoney(selectedLoan.maximumAmount)
    }

    var interestRateText: String {
        guard let selectedLoan else {
            return "0% p.a"
        }

        return "\(selectedLoan.annualInterestRate)% p.a"
    }

    var totalPayableText: String {
        formatMoney(totalPayable)
    }

    var monthlyInstallmentText: String {
        formatMoney(monthlyInstallment)
    }

    var nextRepaymentDateText: String {
        amortizationSchedule.first?.dueDate.formattedLoanDate() ?? "N/A"
    }

    func formatMoney(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let number = NSDecimalNumber(decimal: value)
        let formatted = formatter.string(from: number) ?? "0.00"

        return "\(formatted) KES"
    }

    func formatDate(_ date: Date) -> String {
        date.formattedLoanDate()
    }

    private func buildSummary(
        loanTitle: String,
        accountNumber: String,
        result: LoanResult
    ) -> LoanApplicationSummary {
        LoanApplicationSummary(
            loanTitle: loanTitle,
            loanAmount: result.input.principal,
            interestAmount: result.totalInterest,
            totalCharges: result.totalPayable,
            periodMonths: result.input.tenureInMonths,
            accountNumber: accountNumber,
            disbursementAmount: result.input.principal,
            repaymentAmount: result.totalPayable,
            installments: result.input.tenureInMonths,
            nextRepaymentDate: result.schedule.first?.dueDate.formattedLoanDate() ?? "N/A",
            result: result
        )
    }

    private func loadMockData(selectedLoanTitle: String) {
        loanOptions = [
            ApplyLoanOption(
                title: "Salary E-Loan",
                annualInterestRate: 15,
                minimumAmount: 500,
                maximumAmount: 12_000,
                minimumMonths: 1,
                maximumMonths: 12
            ),
            ApplyLoanOption(
                title: "Buy Now Pay Later",
                annualInterestRate: 18,
                minimumAmount: 500,
                maximumAmount: 50_000,
                minimumMonths: 1,
                maximumMonths: 24
            ),
            ApplyLoanOption(
                title: "Stock Loan",
                annualInterestRate: 20,
                minimumAmount: 500,
                maximumAmount: 100_000,
                minimumMonths: 1,
                maximumMonths: 36
            )
        ]

        accounts = [
            DisbursementAccount(
                accountNumber: "011090145246100",
                accountName: "Main Account",
                availableBalance: 28_500,
                isActive: true
            ),
            DisbursementAccount(
                accountNumber: "011090145246200",
                accountName: "Business Account",
                availableBalance: 76_000,
                isActive: true
            ),
            DisbursementAccount(
                accountNumber: "011090145246300",
                accountName: "Dormant Account",
                availableBalance: 0,
                isActive: false
            )
        ]

        selectedLoan = loanOptions.first { $0.title == selectedLoanTitle } ?? loanOptions.first
        selectedAccount = accounts.first { $0.isActive }
    }

    private func validateAndRecalculate() {
        validateAmount()
        validatePeriod()
        validateAccount()
        recalculate()
    }

    private func validateFormForSubmission() -> Bool {
        validateAmount()
        validatePeriod()
        validateAccount()

        guard selectedLoan != nil else {
            generalErrorMessage = "Please select a loan type."
            return false
        }

        if amountErrorMessage != nil ||
            periodErrorMessage != nil ||
            accountErrorMessage != nil {
            generalErrorMessage = "Please correct the highlighted fields."
            return false
        }

        return true
    }

    private func validateAmount() {
        amountErrorMessage = nil

        guard let selectedLoan else {
            return
        }

        guard let amount = Decimal(string: loanAmount), amount > 0 else {
            amountErrorMessage = "Enter a valid amount."
            return
        }

        if amount < selectedLoan.minimumAmount {
            amountErrorMessage = "Minimum amount allowed is \(formatMoney(selectedLoan.minimumAmount))."
            return
        }

        if amount > selectedLoan.maximumAmount {
            amountErrorMessage = "Maximum amount allowed is \(formatMoney(selectedLoan.maximumAmount))."
            return
        }
    }

    private func validatePeriod() {
        periodErrorMessage = nil

        guard let selectedLoan else {
            return
        }

        guard let months = Int(loanPeriod), months > 0 else {
            periodErrorMessage = "Enter a valid loan period."
            return
        }

        if months < selectedLoan.minimumMonths {
            periodErrorMessage = "Minimum period is \(selectedLoan.minimumMonths) month(s)."
            return
        }

        if months > selectedLoan.maximumMonths {
            periodErrorMessage = "Maximum period is \(selectedLoan.maximumMonths) month(s)."
            return
        }
    }

    private func validateAccount() {
        accountErrorMessage = nil

        guard let selectedAccount else {
            accountErrorMessage = "Please select a disbursement account."
            return
        }

        if !selectedAccount.isActive {
            accountErrorMessage = "Selected account is not active."
            return
        }
    }

    private func recalculate() {
        guard amountErrorMessage == nil,
              periodErrorMessage == nil,
              let selectedLoan,
              let amount = Decimal(string: loanAmount),
              let months = Int(loanPeriod),
              amount > 0,
              months > 0
        else {
            resetCalculation()
            return
        }

        let input = LoanInput(
            principal: amount,
            annualInterestRate: selectedLoan.annualInterestRate,
            tenureValue: months,
            tenureUnit: .months
        )

        do {
            let result = try calculatorEngine.calculate(input: input)

            totalPayable = result.totalPayable
            interestAmount = result.totalInterest
            monthlyInstallment = result.emi
            amortizationSchedule = result.schedule

            repaymentSchedule = result.schedule.map { item in
                RepaymentInstallment(
                    title: "\(ordinal(item.paymentNumber)) instalment - \(item.dueDate.formattedLoanDate())",
                    amount: item.emi
                )
            }
        } catch {
            resetCalculation()
            generalErrorMessage = error.localizedDescription
        }
    }

    private func resetCalculation() {
        totalPayable = 0
        interestAmount = 0
        monthlyInstallment = 0
        repaymentSchedule = []
        amortizationSchedule = []
    }

    private func sanitizeAmount(_ value: String) -> String {
        let allowedCharacters = value.filter { character in
            character.isNumber || character == "."
        }

        let parts = allowedCharacters.split(separator: ".", omittingEmptySubsequences: false)

        if parts.count <= 1 {
            return String(allowedCharacters)
        }

        let whole = parts[0]
        let decimal = parts.dropFirst().joined()

        return "\(whole).\(decimal.prefix(2))"
    }

    private func ordinal(_ number: Int) -> String {
        switch number {
        case 11, 12, 13:
            return "\(number)th"
        default:
            switch number % 10 {
            case 1:
                return "\(number)st"
            case 2:
                return "\(number)nd"
            case 3:
                return "\(number)rd"
            default:
                return "\(number)th"
            }
        }
    }

    private func clearGeneralError() {
        generalErrorMessage = nil

        if state != .submitting {
            state = .idle
        }
    }
}

private extension Date {
    func formattedLoanDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self)
    }
}
