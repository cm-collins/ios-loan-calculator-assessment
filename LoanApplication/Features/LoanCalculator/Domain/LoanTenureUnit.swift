import Foundation

enum LoanTenureUnit: String, Codable, CaseIterable {
    case months
    case years

    func toMonths(_ value: Int) -> Int {
        switch self {
        case .months:
            return value
        case .years:
            return value * 12
        }
    }
}
