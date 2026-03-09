//
//  ErrorView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(AppTypography.iconLarge)
                .foregroundColor(AppColors.accent)

            Text(message)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)

            Button(action: retryAction) {
                Text("إعادة المحاولة")
                    .font(AppTypography.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColors.primary)
                    .cornerRadius(8)
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview("ErrorView - Short Message") {
    ErrorView(
        message: "حدث خطأ أثناء تحميل المحتوى.",
        retryAction: {}
    )
}

#Preview("ErrorView - Long Message") {
    ErrorView(
        message: "تعذر الاتصال بالخادم في الوقت الحالي. تحقق من اتصال الإنترنت لديك ثم حاول مرة أخرى بعد بضع دقائق.",
        retryAction: {}
    )
}
