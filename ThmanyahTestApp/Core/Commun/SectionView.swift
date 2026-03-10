//
//  SectionView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct SectionView: View {
    let section: Section

    var body: some View {
        Group {
            switch section.sectionType {
            case .grid, .twoLinesGrid:
                GridSectionView(section: section)
            case .squareGrid, .square, .bigSquare, .bigSquareWithSpace, .queue:
                SquareGridView(section: section)
            case .horizontalList:
                HorizontalListView(section: section)
            case .featuredBanner:
                FeaturedBannerView(section: section)
            }
        }
    }
}

#if DEBUG
#Preview("SectionView - Grid") {
    SectionView(section: PreviewData.gridSection)
        .background(AppColors.background)
}

#Preview("SectionView - Square Grid") {
    SectionView(section: PreviewData.squareGridSection)
        .background(AppColors.background)
}

#Preview("SectionView - Horizontal List") {
    SectionView(section: PreviewData.horizontalSection)
        .background(AppColors.background)
}

#Preview("SectionView - Featured Banner") {
    SectionView(section: PreviewData.featuredSection)
        .background(AppColors.background)
}

#Preview("FeaturedBannerView") {
    FeaturedBannerView(section: PreviewData.featuredSection)
        .background(AppColors.background)
        .environmentObject(NavigationManager())
        .environmentObject(AudioPlaybackManager())
}
#endif


