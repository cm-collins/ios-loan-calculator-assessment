
# iOS Loan Calculator Assessment

A SwiftUI iOS loan calculator application built for a practical iOS engineering assessment.

The app allows a user to view available loan products, apply for a loan, review calculated repayment details, confirm the request, and reopen a saved active loan.

## Features

* Loan product listing
* Loan application form
* Input validation and inline error messages
* Decimal-based loan calculation
* EMI calculation
* Total interest calculation
* Total payable calculation
* Full amortization schedule
* Loan confirmation screen
* Success screen after confirmation
* Save and reopen active loan using Codable file storage
* MVVM-based presentation layer
* Reusable SwiftUI components
* Unit tests for core business logic

## Tech Stack

* Swift
* SwiftUI
* MVVM
* Codable file storage
* XCTest

## Architecture

The project is organized into clear layers:

```text
Core
├── Components
└── Theme

Features
└── LoanCalculator
    ├── Domain
    ├── Data
    └── Presentation
```

### Domain Layer

Contains the core business logic and models.

```text
LoanInput
LoanResult
LoanTenureUnit
AmortizationScheduleItem
LoanCalculatorEngine
```

The `LoanCalculatorEngine` is responsible for calculating:

* EMI
* Total interest
* Total payable
* Amortization schedule

This keeps financial logic outside SwiftUI views.

### Data Layer

Contains persistence logic.

```text
SavedLoanEntity
SavedLoanRepository
```

The app uses Codable-based file storage instead of UserDefaults because loan calculations are structured data.

### Presentation Layer

Contains SwiftUI screens, ViewModels, and UI-specific models.

```text
LoanListView
ApplyLoanView
ApplyLoanViewModel
LoanApplicationConfirmationView
LoanApplicationSuccessView
```

Views focus on UI rendering, while the ViewModel handles state, validation, and data flow.

## Loan Calculation

The calculator supports:

* Principal amount
* Annual interest rate
* Tenure in months or years
* 0% interest scenarios
* Long tenure validation
* Decimal-based precision
* Explicit rounding strategy

The amortization schedule shows:

* Payment number
* EMI
* Interest portion
* Principal portion
* Remaining balance

## Persistence

Confirmed loan applications are saved locally using Codable file storage.

Users can reopen the app and still see the saved active loan.

## Running the Project

1. Clone the repository.

```bash
git clone https://github.com/YOUR_USERNAME/ios-loan-calculator-assessment.git
```

2. Open the project in Xcode.

```bash
open LoanApplication.xcodeproj
```

3. Select an iPhone simulator.

4. Run the app.

```text
Command + R
```

5. Run unit tests.

```text
Command + U
```

## Assumptions

* The app uses mock loan products and mock accounts.
* A user can only have one active loan at a time.
* After a loan is confirmed, other loan applications are blocked until the current loan is repaid.
* Persistence is local only.
* Authentication and real backend APIs are outside the current scope.

## Trade-offs

* Codable file storage was used instead of Core Data to keep the solution simple, readable, and appropriate for the assessment timeline.
* The UI follows the provided design closely, but some assets are represented using local image assets or system symbols where needed.
* The app uses mock data instead of a real API because the assessment focuses on iOS architecture, calculation logic, and product delivery judgment.

## What Was Intentionally Simplified

* No real backend integration
* No authentication
* No real loan approval workflow
* No repayment tracking after disbursement
* No remote configuration
* No PDF or Excel export

## What I Would Improve With More Time

* Add Core Data or SwiftData for richer persistence
* Add a saved loan history screen
* Add PDF or Excel export
* Add dark mode support
* Add more UI tests
* Add accessibility improvements
* Add real API integration
* Add dependency injection for easier testing
* Add snapshot tests for the SwiftUI screens

## Testing

The project includes unit tests for:

* Loan calculation engine
* Zero-interest calculation
* Positive-interest calculation
* Invalid principal validation
* Invalid tenure validation
* Negative interest validation
* Tenure conversion
* Repository save and reopen behavior
* ViewModel validation and state flow

## Summary

This project demonstrates clean iOS architecture, reusable business logic, SwiftUI presentation, local persistence, validation, and testable financial calculation logic.
