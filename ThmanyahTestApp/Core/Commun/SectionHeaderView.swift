//
//  SectionHeaderView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let showSeeAll: Bool
    var onSeeAllTapped: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.title)
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            if showSeeAll {
                Button(action: { onSeeAllTapped?() }) {
                    HStack(spacing: AppSpacing.xxs) {
                        Text("عرض الكل")
                            .font(AppTypography.caption)
                        Image(systemName: "chevron.left")
                            .font(AppTypography.iconSmall)
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

#if DEBUG
#Preview("SectionHeader - With See All") {
    SectionHeaderView(
        title: "برامج بودكاست",
        showSeeAll: true,
        onSeeAllTapped: {}
    )
    .padding()
    .previewLayout(.sizeThatFits)
    .background(AppColors.background)
}

#Preview("SectionHeader - Without See All") {
    SectionHeaderView(
        title: "محتوى مقترح",
        showSeeAll: false,
        onSeeAllTapped: nil
    )
    .padding()
    .previewLayout(.sizeThatFits)
    .background(AppColors.background)
}
#endif


