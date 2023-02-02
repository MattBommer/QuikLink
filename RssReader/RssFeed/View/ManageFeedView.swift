//
//  ManageFeedView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/31/23.
//

import SwiftUI

struct ManageFeedView: View {
    @EnvironmentObject var feedStore: FeedStore
    @State var feedUrl: String = ""
    
    var body: some View {
        VStack {
            Text("Manage Feeds")
                .font(.title)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color(uiColor: .brandWhite))
                .background(Color(uiColor: .brandPurple), ignoresSafeAreaEdges: .top)
            
            VStack(spacing: 24) {
                VStack {
                    Text("Add New Feed")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Insert rss feed url", text: $feedUrl)
                        .padding()
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        }
                    
                    StretchButton {
                        guard !feedUrl.isEmpty else { return }
                        Task {
                            try await feedStore.addFeed(feedUrl)
                        }
                    } label: {
                        Text("Add Feed")
                    }
                    .foregroundColor(Color(uiColor: .brandWhite))
                    .background(Color(uiColor: .brandGreen))
                    .cornerRadius(8)
                }.padding([.leading, .trailing])
                
                VStack {
                    Text("Subscribed feeds")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing])
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(feedStore.feeds, id: \.id) { feed in
                                FeedView(feed: feed)
                            }
                            .padding([.leading, .trailing])
                            .environmentObject(feedStore)
                        }
                        .padding([.top], 8)
                    } 
                }
                .ignoresSafeArea(edges: [.bottom])
            }
        }
    }
}

struct ManageFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFeedView()
    }
}

extension Image {
    
    @ViewBuilder
    func icon(size: CGSize = CGSize(width: 20, height: 20)) -> some View {
        self
            .resizable()
            .frame(width: size.width, height: size.height)
            .padding()
    }
}
