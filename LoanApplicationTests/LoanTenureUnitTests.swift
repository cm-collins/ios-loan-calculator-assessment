import XCTest
@testable import LoanApplication

final class LoanTenureUnitTests: XCTestCase {
    func testMonthsRemainAsMonths() {
        let months = LoanTenureUnit.months.toMonths(6)

        XCTAssertEqual(months, 6)
    }

    func testYearsConvertToMonths() {
        let months = LoanTenureUnit.years.toMonths(2)

        XCTAssertEqual(months, 24)
    }

    func testLoanInputReturnsTenureInMonthsForMonths() {
        let input = LoanInput(
            principal: 10000,
            annualInterestRate: 15,
            tenureValue: 6,
            tenureUnit: .months
        )

        XCTAssertEqual(input.tenureInMonths, 6)
    }

    func testLoanInputReturnsTenureInMonthsForYears() {
        let input = LoanInput(
            principal: 10000,
            annualInterestRate: 15,
            tenureValue: 1,
            tenureUnit: .years
        )

        XCTAssertEqual(input.tenureInMonths, 12)
    }
}
