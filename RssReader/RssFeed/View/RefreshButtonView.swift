//
//  RefreshButtonView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/18/23.
//

import SwiftUI

struct RefreshFloatingActionButtonView: View {
    @EnvironmentObject private var feedViewModel: RSSFeedViewModel
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    Task {
                        try await AuthViewModel.shared.fetchFreshTokens()
                        try await feedViewModel.fetchFeeds()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle())
                }
            }
            .padding()
        }
    }
}

struct RefreshButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshFloatingActionButtonView()
    }
}
