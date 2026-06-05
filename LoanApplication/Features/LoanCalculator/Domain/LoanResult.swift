import Foundation

struct LoanResult: Codable, Equatable {
    let input: LoanInput
    let emi: Decimal
    let totalInterest: Decimal
    let totalPayable: Decimal
    let schedule: [AmortizationScheduleItem]
}
