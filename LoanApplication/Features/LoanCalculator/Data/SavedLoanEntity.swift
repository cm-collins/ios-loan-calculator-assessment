import Foundation

struct SavedLoanEntity: Identifiable, Codable, Equatable {
    let id: UUID
    let loanTitle: String
    let accountNumber: String
    let savedAt: Date
    let result: LoanResult

    init(
        id: UUID = UUID(),
        loanTitle: String,
        accountNumber: String,
        savedAt: Date = Date(),
        result: LoanResult
    ) {
        self.id = id
        self.loanTitle = loanTitle
        self.accountNumber = accountNumber
        self.savedAt = savedAt
        self.result = result
    }
}
