//
//  AlertFormView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/18/23.
//

import SwiftUI

struct AlertFormView: View {
    @State private var feedUrl: String = ""
    
    @EnvironmentObject private var feedViewModel: RSSFeedViewModel
    @EnvironmentObject private var modalStore: ModalStore
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter URL of valid RSS feed:", text: $feedUrl)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
            
            HStack {
                Button {
                    feedViewModel.addFeed(feedUrl)
                } label: {
                    Text("Save")
                        .padding([.leading, .trailing], 24)
                        .padding([.top, .bottom], 12)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue)
                        )
                }
                
                Button {
                    modalStore.dismiss()
                } label: {
                    Text("Exit")
                        .padding([.leading, .trailing], 24)
                        .padding([.top, .bottom], 12)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue)
                        )
                }
            }
        }
        .padding(24)
        .borderedCard()
        .padding()
    }
}

struct AlertFormView_Previews: PreviewProvider {
    static var previews: some View {
        AlertFormView()
    }
}
