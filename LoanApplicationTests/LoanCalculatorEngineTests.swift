import XCTest
@testable import LoanApplication

final class LoanCalculatorEngineTests: XCTestCase {
    private var engine: LoanCalculatorEngine!

    override func setUp() {
        super.setUp()
        engine = LoanCalculatorEngine()
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    func testCalculateWithZeroPercentInterestSplitsPrincipalAcrossTenure() throws {
        let input = LoanInput(
            principal: 12000,
            annualInterestRate: 0,
            tenureValue: 12,
            tenureUnit: .months
        )

        let result = try engine.calculate(input: input)

        XCTAssertEqual(result.emi, Decimal(1000))
        XCTAssertEqual(result.totalInterest, Decimal(0))
        XCTAssertEqual(result.totalPayable, Decimal(12000))
        XCTAssertEqual(result.schedule.count, 12)
        XCTAssertEqual(result.schedule.last?.remainingBalance, Decimal(0))
    }

    func testCalculateWithPositiveInterestReturnsValidResult() throws {
        let input = LoanInput(
            principal: 10000,
            annualInterestRate: 15,
            tenureValue: 2,
            tenureUnit: .months
        )

        let result = try engine.calculate(input: input)

        XCTAssertGreaterThan(result.emi, Decimal(0))
        XCTAssertGreaterThan(result.totalInterest, Decimal(0))
        XCTAssertGreaterThan(result.totalPayable, input.principal)
        XCTAssertEqual(result.schedule.count, 2)
        XCTAssertEqual(result.schedule.first?.paymentNumber, 1)
        XCTAssertEqual(result.schedule.last?.paymentNumber, 2)
        XCTAssertEqual(result.schedule.last?.remainingBalance, Decimal(0))
    }

    func testScheduleInterestPrincipalAndBalanceAreCalculated() throws {
        let input = LoanInput(
            principal: 10000,
            annualInterestRate: 15,
            tenureValue: 2,
            tenureUnit: .months
        )

        let result = try engine.calculate(input: input)

        let firstPayment = try XCTUnwrap(result.schedule.first)

        XCTAssertGreaterThan(firstPayment.emi, Decimal(0))
        XCTAssertGreaterThan(firstPayment.interestPortion, Decimal(0))
        XCTAssertGreaterThan(firstPayment.principalPortion, Decimal(0))
        XCTAssertLessThan(firstPayment.remainingBalance, input.principal)
    }

    func testTotalPayableEqualsSumOfSchedulePayments() throws {
        let input = LoanInput(
            principal: 50000,
            annualInterestRate: 18,
            tenureValue: 12,
            tenureUnit: .months
        )

        let result = try engine.calculate(input: input)

        let scheduleTotal = result.schedule.reduce(Decimal(0)) { partial, item in
            partial + item.emi
        }

        XCTAssertEqual(result.totalPayable, scheduleTotal)
    }

    func testCalculateThrowsForInvalidPrincipal() {
        let input = LoanInput(
            principal: 0,
            annualInterestRate: 15,
            tenureValue: 12,
            tenureUnit: .months
        )

        XCTAssertThrowsError(try engine.calculate(input: input)) { error in
            XCTAssertEqual(error as? LoanCalculatorError, .invalidPrincipal)
        }
    }

    func testCalculateThrowsForInvalidTenure() {
        let input = LoanInput(
            principal: 10000,
            annualInterestRate: 15,
            tenureValue: 0,
            tenureUnit: .months
        )

        XCTAssertThrowsError(try engine.calculate(input: input)) { error in
            XCTAssertEqual(error as? LoanCalculatorError, .invalidTenure)
        }
    }

    func testCalculateThrowsForNegativeInterestRate() {
        let input = LoanInput(
            principal: 10000,
            annualInterestRate: -1,
            tenureValue: 12,
            tenureUnit: .months
        )

        XCTAssertThrowsError(try engine.calculate(input: input)) { error in
            XCTAssertEqual(error as? LoanCalculatorError, .invalidInterestRate)
        }
    }

    func testCalculateThrowsForVeryLongTenure() {
        let input = LoanInput(
            principal: 10000,
            annualInterestRate: 15,
            tenureValue: 601,
            tenureUnit: .months
        )

        XCTAssertThrowsError(try engine.calculate(input: input)) { error in
            XCTAssertEqual(error as? LoanCalculatorError, .tenureTooLong)
        }
    }
}
