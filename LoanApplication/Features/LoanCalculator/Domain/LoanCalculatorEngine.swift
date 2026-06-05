import Foundation

enum LoanCalculatorError: LocalizedError {
    case invalidPrincipal
    case invalidTenure
    case invalidInterestRate
    case tenureTooLong

    var errorDescription: String? {
        switch self {
        case .invalidPrincipal:
            return "Principal amount must be greater than zero."
        case .invalidTenure:
            return "Loan tenure must be greater than zero."
        case .invalidInterestRate:
            return "Interest rate cannot be negative."
        case .tenureTooLong:
            return "Loan tenure is too long."
        }
    }
}

struct LoanCalculatorEngine {
    func calculate(input: LoanInput) throws -> LoanResult {
        guard input.principal > 0 else {
            throw LoanCalculatorError.invalidPrincipal
        }

        guard input.tenureInMonths > 0 else {
            throw LoanCalculatorError.invalidTenure
        }

        guard input.annualInterestRate >= 0 else {
            throw LoanCalculatorError.invalidInterestRate
        }

        guard input.tenureInMonths <= 600 else {
            throw LoanCalculatorError.tenureTooLong
        }

        let months = input.tenureInMonths
        let monthlyRate = input.annualInterestRate / 100 / 12

        let emi: Decimal

        if input.annualInterestRate == 0 {
            emi = roundMoney(input.principal / Decimal(months))
        } else {
            let power = decimalPower(1 + monthlyRate, months)
            let numerator = input.principal * monthlyRate * power
            let denominator = power - 1

            emi = roundMoney(numerator / denominator)
        }

        let schedule = buildAmortizationSchedule(
            principal: input.principal,
            monthlyRate: monthlyRate,
            emi: emi,
            months: months
        )

        let totalPayable = roundMoney(schedule.reduce(Decimal(0)) { partial, item in
            partial + item.emi
        })

        let totalInterest = roundMoney(totalPayable - input.principal)

        return LoanResult(
            input: input,
            emi: emi,
            totalInterest: totalInterest,
            totalPayable: totalPayable,
            schedule: schedule
        )
    }

    private func buildAmortizationSchedule(
        principal: Decimal,
        monthlyRate: Decimal,
        emi: Decimal,
        months: Int
    ) -> [AmortizationScheduleItem] {
        var balance = principal
        var items: [AmortizationScheduleItem] = []

        for month in 1...months {
            let interestPortion = roundMoney(balance * monthlyRate)

            var principalPortion = roundMoney(emi - interestPortion)
            var actualEMI = emi

            if month == months {
                principalPortion = balance
                actualEMI = roundMoney(principalPortion + interestPortion)
            }

            balance = roundMoney(balance - principalPortion)

            if balance < 0 {
                balance = 0
            }

            items.append(
                AmortizationScheduleItem(
                    paymentNumber: month,
                    dueDate: dueDate(forMonthOffset: month),
                    emi: actualEMI,
                    interestPortion: interestPortion,
                    principalPortion: principalPortion,
                    remainingBalance: balance
                )
            )
        }

        return items
    }

    private func dueDate(forMonthOffset monthOffset: Int) -> Date {
        Calendar.current.date(
            byAdding: .month,
            value: monthOffset,
            to: Date()
        ) ?? Date()
    }

    private func decimalPower(_ base: Decimal, _ exponent: Int) -> Decimal {
        guard exponent > 0 else {
            return 1
        }

        var result: Decimal = 1

        for _ in 0..<exponent {
            result *= base
        }

        return result
    }

    private func roundMoney(_ value: Decimal) -> Decimal {
        var value = value
        var result = Decimal()

        NSDecimalRound(&result, &value, 2, .bankers)

        return result
    }
}
