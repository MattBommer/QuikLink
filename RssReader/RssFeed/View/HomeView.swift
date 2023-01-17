//
//  RSSFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            HomeHeaderView()
            LazyVStack {
                FeedView(feed: <#T##RSSFeed#>)
            }
        }
    }
}

struct RSSFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
