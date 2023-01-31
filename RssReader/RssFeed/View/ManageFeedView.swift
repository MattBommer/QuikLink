//
//  ManageFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/31/23.
//

import SwiftUI

struct ManageFeedView: View {
    @EnvironmentObject var feedViewModel: RSSFeedViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Manage Feeds")
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color(uiColor: .brandWhite))
                .background(Color(uiColor: .brandPurple), ignoresSafeAreaEdges: .top)
            
            ScrollView {
                LazyVStack {
                    ForEach(feedViewModel.feeds, id: \.id) { feed in
                        FeedView(feed: feed)
                    }
                    .environmentObject(feedViewModel)
                }
                .padding()
            }
        }
    }
}

struct ManageFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFeedView()
    }
}
