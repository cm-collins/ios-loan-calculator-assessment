import XCTest
@testable import LoanApplication

@MainActor
final class ApplyLoanViewModelTests: XCTestCase {
    func testInitialStateLoadsMockLoanAndAccount() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        XCTAssertEqual(viewModel.selectedLoan?.title, "Salary E-Loan")
        XCTAssertNotNil(viewModel.selectedAccount)
        XCTAssertFalse(viewModel.loanOptions.isEmpty)
        XCTAssertFalse(viewModel.accounts.isEmpty)
    }

    func testAmountBelowMinimumShowsErrorAndDisablesApply() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        viewModel.updateLoanAmount("100")

        XCTAssertEqual(
            viewModel.amountErrorMessage,
            "Minimum amount allowed is 500.00 KES."
        )
        XCTAssertFalse(viewModel.isApplyButtonEnabled)
    }

    func testAmountAboveMaximumShowsErrorAndDisablesApply() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        viewModel.updateLoanAmount("13000")

        XCTAssertEqual(
            viewModel.amountErrorMessage,
            "Maximum amount allowed is 12,000.00 KES."
        )
        XCTAssertFalse(viewModel.isApplyButtonEnabled)
    }

    func testInvalidPeriodShowsErrorAndDisablesApply() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        viewModel.updateLoanPeriod("0")

        XCTAssertEqual(
            viewModel.periodErrorMessage,
            "Enter a valid loan period."
        )
        XCTAssertFalse(viewModel.isApplyButtonEnabled)
    }

    func testPeriodAboveMaximumShowsErrorAndDisablesApply() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        viewModel.updateLoanPeriod("13")

        XCTAssertEqual(
            viewModel.periodErrorMessage,
            "Maximum period is 12 month(s)."
        )
        XCTAssertFalse(viewModel.isApplyButtonEnabled)
    }

    func testValidInputCalculatesPayableAndSchedule() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        viewModel.updateLoanAmount("10000")
        viewModel.updateLoanPeriod("2")

        XCTAssertNil(viewModel.amountErrorMessage)
        XCTAssertNil(viewModel.periodErrorMessage)
        XCTAssertGreaterThan(viewModel.totalPayable, Decimal(0))
        XCTAssertGreaterThan(viewModel.monthlyInstallment, Decimal(0))
        XCTAssertEqual(viewModel.amortizationSchedule.count, 2)
        XCTAssertTrue(viewModel.isApplyButtonEnabled)
    }

    func testApplyLoanCreatesConfirmationSummary() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        viewModel.updateLoanAmount("10000")
        viewModel.updateLoanPeriod("2")
        viewModel.applyLoan()

        XCTAssertEqual(viewModel.state, .success)
        XCTAssertNotNil(viewModel.confirmationSummary)
        XCTAssertEqual(viewModel.confirmationSummary?.loanTitle, "Salary E-Loan")
        XCTAssertEqual(viewModel.confirmationSummary?.loanAmount, Decimal(10000))
        XCTAssertEqual(viewModel.confirmationSummary?.periodMonths, 2)
    }

    func testSanitizesAmountInputToNumbersAndTwoDecimalPlaces() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        viewModel.updateLoanAmount("KES 1234.5678abc")

        XCTAssertEqual(viewModel.loanAmount, "1234.56")
    }

    func testChangingLoanUpdatesLimitsAndValidation() {
        let viewModel = ApplyLoanViewModel(selectedLoanTitle: "Salary E-Loan")

        let stockLoan = ApplyLoanOption(
            title: "Stock Loan",
            annualInterestRate: 20,
            minimumAmount: 500,
            maximumAmount: 100000,
            minimumMonths: 1,
            maximumMonths: 36
        )

        viewModel.selectLoan(stockLoan)
        viewModel.updateLoanAmount("50000")
        viewModel.updateLoanPeriod("24")

        XCTAssertEqual(viewModel.selectedLoan?.title, "Stock Loan")
        XCTAssertNil(viewModel.amountErrorMessage)
        XCTAssertNil(viewModel.periodErrorMessage)
        XCTAssertTrue(viewModel.isApplyButtonEnabled)
    }
}
