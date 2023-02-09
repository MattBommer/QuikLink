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
    @State var errorText: String = ""
    
    var body: some View {
        VStack {
            Text("Manage Feeds")
                .font(.custom("ShareTechMono-Regular", size: 28))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color(uiColor: .brandWhite))
                .background(Color(uiColor: .brandPurple), ignoresSafeAreaEdges: .top)
            
            VStack(spacing: 24) {
                VStack {
                    Text("Add new feed")
                        .font(.custom("ShareTechMono-Regular", size: 24))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Paste rss feed url", text: $feedUrl)
                        .padding()
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        }
                    
                    Text(errorText)
                        .font(.caption)
                        .foregroundColor(Color(uiColor: .brandRed))
                    
                    StretchButton {
                        guard !feedUrl.isEmpty else { return }
                        Task {
                            do {
                                try await feedStore.addFeed(feedUrl)
                                errorText = ""
                            } catch {
                                switch error {
                                case is ResponseError:
                                    errorText = error.localizedDescription
                                default:
                                    print("Unhandled error \(error)")
                                }
                            }
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
                        .font(.custom("ShareTechMono-Regular", size: 24))
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
