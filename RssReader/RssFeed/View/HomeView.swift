//
//  RSSFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var rssFeedViewModel = RSSFeedViewModel()
    @State private var headerHeight: CGFloat = 0
    
    var body: some View {
        RootModalView(backgroundColor: Color(uiColor: .gray.withAlphaComponent(0.3))) {
            ZStack {
                GeometryReader { reader in
                    VStack(spacing: -8) {
                        HomeHeaderView()
                            .frame(width: reader.size.width, height: reader.size.height * 0.15)
                        HomeFeedView()
                            .frame(width: reader.size.width, height: reader.size.height * 0.85)
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    Task {
                        try await rssFeedViewModel.fetchFeeds()
                    }
                }
                RefreshFloatingActionButtonView()
            }
            .environmentObject(rssFeedViewModel)
        }
    }
}

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
