import Foundation

struct LoanInput: Codable, Equatable {
    let principal: Decimal
    let annualInterestRate: Decimal
    let tenureValue: Int
    let tenureUnit: LoanTenureUnit

    var tenureInMonths: Int {
        tenureUnit.toMonths(tenureValue)
    }
}
