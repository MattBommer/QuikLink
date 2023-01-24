//
//  ArticleView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/24/23.
//

import SwiftUI

struct ArticleView: View {
    var article: Article
    @State private var showWebView = false
    
    var body: some View {
        VStack {
            AsyncImage(url: article.imageUrl, scale: 1.0) { phase in
                switch phase {
                case .success(let image):
                    image.feedImage()
                default:
                    Image(uiImage: UIImage(named: "noimage")!).feedImage()
                }
            }
            
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
                
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], 16)
                }
            }
            .background(Color.white)
        }
        .padding(.bottom, 8)
        .borderedCard(strokeColor: .gray)
        .onTapGesture {
            showWebView = true
        }
        .sheet(isPresented: $showWebView, onDismiss: {
            showWebView = false
        }) {
            WebView(url: article.contentUrl)
        }
    }
}
