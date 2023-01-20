//
//  HomeHeaderView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct HomeHeaderView: View {
    @State private var addFeed: Bool = false
    @State private var removeFeed: Bool = false
    @State private var logout: Bool = false
    
    @EnvironmentObject private var modalStore: ModalStore
    @EnvironmentObject private var rssFeedViewModel: RSSFeedViewModel
    @EnvironmentObject private var AuthViewModel: AuthViewModel
    var body: some View {
        HStack {
            Button {
                modalStore.present {
                    AlertFormView()
                }
            } label: {
                Image(systemName: "plus")
                    .headerIconStyle()
            }
            
            Spacer()
            
            Text("Real Simple Syndication")
                .font(.title)
                .padding()
            
            Spacer()
            
            Button {
                removeFeed = true
            } label: {
                Image(systemName: "trash.fill")
                    .headerIconStyle()
            }
            
            Button {
                logout = true
            } label: {
                Image(systemName: "arrow.up.right.diamond")
                    .headerIconStyle()
            }.confirmationDialog("Are you sure you want to logout", isPresented: $logout) {
                Button("Logout", role: .destructive) {
                    AuthViewModel.logOut()
                }
                Button("Cancel", role: .cancel) {
                    logout = false
                }
            }
        }
        .foregroundColor(.white)
        .background(Color.blue)
        .shadow(radius: 4)
    }
}

private extension Image {
    
    func headerIconStyle() -> some View {
        self.resizable()
            .frame(width: 20, height: 20, alignment: .center)
            .padding()
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
