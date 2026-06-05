import SwiftUI

struct LoanListView: View {
    @State private var selectedProduct: LoanProduct?
    @State private var showApplyLoan = false
    @State private var activeLoanSummary: LoanApplicationSummary?
    @State private var activeLoanTitle: String?
    @State private var showInfoBanner = false

    private let savedLoanRepository = SavedLoanRepository.shared

    private let products: [LoanProduct] = [
        LoanProduct(
            title: "Salary E-Loan",
            subtitle: "Get quick loans to boost\nyour income",
            imageName: "salary_loan_woman",
            startColor: AppColors.salaryCardStart,
            endColor: AppColors.salaryCardEnd
        ),
        LoanProduct(
            title: "Buy Now Pay Later",
            subtitle: "Buy goods today, pay\nlater",
            imageName: "bnpl_products",
            startColor: AppColors.buyNowCardStart,
            endColor: AppColors.buyNowCardEnd
        ),
        LoanProduct(
            title: "Stock Loan",
            subtitle: "Boost your business\nstock today",
            imageName: "stock_loan_boxes",
            startColor: AppColors.stockCardStart,
            endColor: AppColors.stockCardEnd
        )
    ]

    private var availableProducts: [LoanProduct] {
        guard activeLoanSummary != nil else {
            return products
        }

        guard let activeLoanTitle else {
            return products
        }

        return products.filter { $0.title != activeLoanTitle }
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ScreenHeaderView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.responsive(22)) {
                        if let activeLoanSummary {
                            activeLoanSection(summary: activeLoanSummary)
                            divider
                            otherLoansSection
                        } else {
                            availableLoansSection
                        }
                    }
                    .padding(.bottom, AppSpacing.responsive(24))
                }
                .background(AppColors.screenBackground)
            }
            .background(AppColors.screenBackground)
            .ignoresSafeArea(edges: .top)

            if showInfoBanner {
                InfoBannerView(
                    message: "Please repay the current loan to apply for a new one."
                )
                .padding(.top, AppSpacing.responsive(58))
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showInfoBanner)
        .onAppear {
            loadSavedLoan()
        }
        .fullScreenCover(isPresented: $showApplyLoan) {
            ApplyLoanView(
                selectedLoanTitle: selectedProduct?.title ?? "Salary E-Loan",
                onBack: {
                    showApplyLoan = false
                },
                onClose: {
                    showApplyLoan = false
                },
                onLoanConfirmed: { summary in
                    saveConfirmedLoan(summary)
                }
            )
        }
    }

    private var availableLoansSection: some View {
        VStack(spacing: AppSpacing.responsive(16)) {
            Text("Available Loans")
                .font(AppFonts.gilroyMedium(AppSpacing.responsive(16)))
                .foregroundStyle(AppColors.primaryText)
                .padding(.top, AppSpacing.responsive(22))

            VStack(spacing: AppSpacing.responsive(16)) {
                ForEach(availableProducts) { product in
                    LoanCardView(product: product) {
                        openLoanApplication(for: product)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }

    private func activeLoanSection(summary: LoanApplicationSummary) -> some View {
        VStack(spacing: AppSpacing.responsive(18)) {
            Text("Active Loans")
                .font(AppFonts.gilroyMedium(AppSpacing.responsive(22)))
                .foregroundStyle(AppColors.primaryText)
                .padding(.top, AppSpacing.responsive(24))

            ActiveLoanCardView(summary: summary)
                .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }

    private var otherLoansSection: some View {
        VStack(spacing: AppSpacing.responsive(16)) {
            Text("Other Loans Available")
                .font(AppFonts.gilroyMedium(AppSpacing.responsive(22)))
                .foregroundStyle(AppColors.primaryText)

            VStack(spacing: AppSpacing.responsive(16)) {
                ForEach(availableProducts) { product in
                    LoanCardView(product: product) {
                        openLoanApplication(for: product)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.22))
            .frame(height: 1)
            .padding(.horizontal, AppSpacing.responsive(64))
            .padding(.top, AppSpacing.responsive(12))
    }

    private func openLoanApplication(for product: LoanProduct) {
        if activeLoanSummary != nil {
            showInfoBannerMessage()
            return
        }

        selectedProduct = product
        showApplyLoan = true
    }

    private func saveConfirmedLoan(_ summary: LoanApplicationSummary) {
        guard let result = summary.result else {
            activeLoanSummary = summary
            activeLoanTitle = summary.loanTitle
            return
        }

        let entity = SavedLoanEntity(
            id: summary.id,
            loanTitle: summary.loanTitle,
            accountNumber: summary.accountNumber,
            result: result
        )

        do {
            try savedLoanRepository.save(entity)
            activeLoanSummary = LoanApplicationSummary(entity: entity)
            activeLoanTitle = entity.loanTitle
        } catch {
            // Do not block UI completely in the assessment.
            // We still show the calculated active loan, but persistence failed.
            activeLoanSummary = summary
            activeLoanTitle = summary.loanTitle
            print("Failed to save loan: \(error.localizedDescription)")
        }
    }

    private func loadSavedLoan() {
        do {
            guard let savedLoan = try savedLoanRepository.fetchLatest() else {
                return
            }

            activeLoanSummary = LoanApplicationSummary(entity: savedLoan)
            activeLoanTitle = savedLoan.loanTitle
        } catch {
            print("Failed to load saved loan: \(error.localizedDescription)")
        }
    }

    private func showInfoBannerMessage() {
        showInfoBanner = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showInfoBanner = false
        }
    }
}

#Preview {
    LoanListView()
}
