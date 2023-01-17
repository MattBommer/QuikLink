//
//  FeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct FeedView: View {
    var feed: RSSFeed
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(feed.imageUrl)) { fetchStatus in
                if let image = fetchStatus.image {
                    styleFeedImage(image)
                } else if fetchStatus.error != nil {
                    let defaultImage = UIImage(named: "noimage")!
                    styleFeedImage(Image(uiImage: defaultImage))
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
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
        }
        .padding(.bottom, 8)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 0.5)
        )
        
        .padding()
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

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleFeed: RSSFeed = .init(resourceId: "1ljga8eng032dsal", title: "New York Times", rssUrl: "The front page of world wide news!")
        FeedView(feed: exampleFeed)
    }
}

extension URL {
    init?(_ urlString: String?) {
        guard let urlString = urlString else { return nil }
        self.init(string: urlString)
    }
}