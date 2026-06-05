import XCTest
@testable import LoanApplication

final class SavedLoanRepositoryTests: XCTestCase {
    private var repository: SavedLoanRepository!
    private var engine: LoanCalculatorEngine!

    override func setUpWithError() throws {
        try super.setUpWithError()

        repository = SavedLoanRepository()
        engine = LoanCalculatorEngine()

        try repository.deleteAll()
    }

    override func tearDownWithError() throws {
        try repository.deleteAll()

        repository = nil
        engine = nil

        try super.tearDownWithError()
    }

    func testSaveAndFetchLatestLoan() throws {
        let entity = try makeSavedLoanEntity(
            loanTitle: "Salary E-Loan",
            principal: 10000,
            interestRate: 15,
            months: 2
        )

        try repository.save(entity)

        let fetched = try repository.fetchLatest()

        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.loanTitle, "Salary E-Loan")
        XCTAssertEqual(fetched?.accountNumber, "011090145246100")
        XCTAssertEqual(fetched?.result.input.principal, Decimal(10000))
    }

    func testFetchAllReturnsSavedLoans() throws {
        let first = try makeSavedLoanEntity(
            loanTitle: "Salary E-Loan",
            principal: 10000,
            interestRate: 15,
            months: 2
        )

        let second = try makeSavedLoanEntity(
            loanTitle: "Stock Loan",
            principal: 50000,
            interestRate: 20,
            months: 12
        )

        try repository.save(first)
        try repository.save(second)

        let savedLoans = try repository.fetchAll()

        XCTAssertEqual(savedLoans.count, 2)
        XCTAssertEqual(savedLoans.first?.loanTitle, "Stock Loan")
        XCTAssertEqual(savedLoans.last?.loanTitle, "Salary E-Loan")
    }

    func testDeleteAllRemovesSavedLoans() throws {
        let entity = try makeSavedLoanEntity(
            loanTitle: "Salary E-Loan",
            principal: 10000,
            interestRate: 15,
            months: 2
        )

        try repository.save(entity)
        try repository.deleteAll()

        let savedLoans = try repository.fetchAll()

        XCTAssertTrue(savedLoans.isEmpty)
    }

    private func makeSavedLoanEntity(
        loanTitle: String,
        principal: Decimal,
        interestRate: Decimal,
        months: Int
    ) throws -> SavedLoanEntity {
        let input = LoanInput(
            principal: principal,
            annualInterestRate: interestRate,
            tenureValue: months,
            tenureUnit: .months
        )

        let result = try engine.calculate(input: input)

        return SavedLoanEntity(
            loanTitle: loanTitle,
            accountNumber: "011090145246100",
            result: result
        )
    }
}
