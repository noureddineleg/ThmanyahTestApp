//
//  AsyncImageView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    let contentMode: ContentMode

    init(url: URL?, contentMode: ContentMode = .fill) {
        self.url = url
        self.contentMode = contentMode
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.cardBackground)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.cardBackground)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview("AsyncImageView - Success") {
    AsyncImageView(
        url: URL(string: "https://link.com/image.jpg"),
        contentMode: .fill
    )
    .frame(width: 160, height: 100)
    .background(AppColors.cardBackground)
}

#Preview("AsyncImageView - Failure") {
    AsyncImageView(
        url: URL(string: "https://"),
        contentMode: .fit
    )
    .frame(width: 160, height: 100)
    .background(AppColors.cardBackground)
}

#Preview("AsyncImageView - Empty URL") {
    AsyncImageView(
        url: nil,
        contentMode: .fill
    )
    .frame(width: 160, height: 100)
    .background(AppColors.cardBackground)
}
