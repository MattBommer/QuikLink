//
//  FeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct FeedView: View {
    var feed: RSSFeed
    @EnvironmentObject var rssFeedViewModel: RSSFeedViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: feed.imageUrl, scale: 1.0) { phase in
                switch phase {
                case .success(let image):
                    styleFeedImage(image)
                default:
                    styleFeedImage(Image(uiImage: UIImage(named: "noimage")!))
                }
            }
            
            VStack(alignment: .leading) {
                Text(feed.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
                Text(feed.description ?? "")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
            }
            .background(Color.white)
            
            if (rssFeedViewModel.homeFeedStatus == .edit) {
                Button {
                    rssFeedViewModel.removeFeed(feed.id)
                } label: {
                    Text("Remove")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red)
                        )
                }
                .padding()
            }
        }
        .padding(.bottom, 8)
        .borderedCard(strokeColor: .gray)
    }
    
    private func styleFeedImage(_ image: Image) -> some View {
        return image
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .clipped()
    }
    
}

