import Foundation

struct LoanApplicationSummary: Identifiable, Codable, Equatable {
    let id: UUID

    let loanTitle: String
    let loanAmount: Decimal
    let interestAmount: Decimal
    let totalCharges: Decimal
    let periodMonths: Int

    let accountNumber: String
    let disbursementAmount: Decimal

    let repaymentAmount: Decimal
    let installments: Int
    let nextRepaymentDate: String

    // Keeps the real calculated domain result so it can be saved cleanly.
    let result: LoanResult?

    init(
        id: UUID = UUID(),
        loanTitle: String,
        loanAmount: Decimal,
        interestAmount: Decimal,
        totalCharges: Decimal,
        periodMonths: Int,
        accountNumber: String,
        disbursementAmount: Decimal,
        repaymentAmount: Decimal,
        installments: Int,
        nextRepaymentDate: String,
        result: LoanResult? = nil
    ) {
        self.id = id
        self.loanTitle = loanTitle
        self.loanAmount = loanAmount
        self.interestAmount = interestAmount
        self.totalCharges = totalCharges
        self.periodMonths = periodMonths
        self.accountNumber = accountNumber
        self.disbursementAmount = disbursementAmount
        self.repaymentAmount = repaymentAmount
        self.installments = installments
        self.nextRepaymentDate = nextRepaymentDate
        self.result = result
    }
}

extension LoanApplicationSummary {
    init(entity: SavedLoanEntity) {
        self.init(
            id: entity.id,
            loanTitle: entity.loanTitle,
            loanAmount: entity.result.input.principal,
            interestAmount: entity.result.totalInterest,
            totalCharges: entity.result.totalPayable,
            periodMonths: entity.result.input.tenureInMonths,
            accountNumber: entity.accountNumber,
            disbursementAmount: entity.result.input.principal,
            repaymentAmount: entity.result.totalPayable,
            installments: entity.result.input.tenureInMonths,
            nextRepaymentDate: entity.result.schedule.first?.dueDate.formattedLoanDate() ?? "N/A",
            result: entity.result
        )
    }
}

private extension Date {
    func formattedLoanDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self)
    }
}
