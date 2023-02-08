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
                    image.resizable()
                        .scaledToFill()
                default:
                    GradientLoadingView()
                }
            }
            .frame(height: 175, alignment: .top)
            .clipped()

            
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.title2)
                    
                
                Text(article.publication)
                    .font(.body)
                    .foregroundColor(.gray)
                
                Text(article.publishedString)
                    .font(.caption2)
                    .foregroundColor(.gray)
                                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], 16)
        }
        .padding(.bottom, 8)
        .onTapGesture {
            showWebView = true
        }
        .sheet(isPresented: $showWebView) {
            ArticleWebView(url: article.contentUrl)
                .ignoresSafeArea()
        }
        .background(Color(uiColor: .brandWhite))
        .cornerRadius(8)
        .shadow(color: Color(uiColor: .black.withAlphaComponent(0.2)), radius: 4, x: 0, y: 2)
    }
}
