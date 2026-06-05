

import SwiftUI

struct ScreenHeaderView: View {
    var body: some View {
        ZStack {
            AppColors.headerDarkGreen

            // Right diagonal shape
            HStack {
                Spacer()

                Rectangle()
                    .fill(Color.black.opacity(0.12))
                    .frame(width: 120, height: 160)
                    .rotationEffect(.degrees(-35))
                    .offset(x: 35, y: -20)
            }

            // Left diagonal shape
            HStack {
                Rectangle()
                    .fill(Color.black.opacity(0.12))
                    .frame(width: 130, height: 120)
                    .rotationEffect(.degrees(-38))
                    .offset(x: -45, y: 25)

                Spacer()
            }

            HStack(spacing: 18) {
                avatarView

                VStack(spacing: 4) {
                    Text("Hello There!")
                        .font(AppFonts.gilroyMedium(20))
                        .foregroundStyle(AppColors.white)

                    Text("Boost your income today!")
                        .font(AppFonts.productSansRegular(12))
                        .foregroundStyle(AppColors.white)
                }
                .frame(maxWidth: .infinity)

                Color.clear
                    .frame(width: 46, height: 46)
            }
            .padding(.horizontal, 24)
            .padding(.top, 42)
        }
        .frame(height: AppSpacing.headerHeight)
    }

    private var avatarView: some View {
        Group {
            if UIImage(named: "avatar_profile") != nil {
                Image("avatar_profile")
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .foregroundStyle(AppColors.headerDarkGreen)
                    .background(AppColors.white)
            }
        }
        .frame(width: 46, height: 46)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color(hex: "#168DCC"), lineWidth: 1)
        )
    }
}
