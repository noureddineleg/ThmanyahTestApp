//
//  ContentView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
            .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    ContentView()
}
