
# iOS Loan Calculator Assessment

A SwiftUI iOS loan calculator application built for a practical iOS engineering assessment.

The app allows a user to view available loan products, apply for a loan, review calculated repayment details, confirm the request, and reopen a saved active loan.

## Features

* Loan product listingP
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
