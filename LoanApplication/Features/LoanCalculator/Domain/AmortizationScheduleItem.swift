import Foundation

struct AmortizationScheduleItem: Identifiable, Codable, Equatable {
    let id: UUID
    let paymentNumber: Int
    let dueDate: Date
    let emi: Decimal
    let interestPortion: Decimal
    let principalPortion: Decimal
    let remainingBalance: Decimal

    init(
        id: UUID = UUID(),
        paymentNumber: Int,
        dueDate: Date,
        emi: Decimal,
        interestPortion: Decimal,
        principalPortion: Decimal,
        remainingBalance: Decimal
    ) {
        self.id = id
        self.paymentNumber = paymentNumber
        self.dueDate = dueDate
        self.emi = emi
        self.interestPortion = interestPortion
        self.principalPortion = principalPortion
        self.remainingBalance = remainingBalance
    }
}
