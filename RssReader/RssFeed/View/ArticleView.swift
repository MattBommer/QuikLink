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
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
                
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], 16)
                }
            }
        }
        .padding(.bottom, 8)
        .onTapGesture {
            showWebView = true
        }
        .sheet(isPresented: $showWebView, onDismiss: {
            showWebView = false
        }) {
            ArticleWebView(url: article.contentUrl)
        }
        .background(Color(uiColor: .brandWhite))
        .cornerRadius(8)
        .shadow(color: Color(uiColor: .black.withAlphaComponent(0.2)), radius: 2, x: 0, y: 2)
    }
}

extension Image {
    
    func feedImage() -> some View {
        return self
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .clipped()
    }
}
