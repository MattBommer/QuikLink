//
//  HomeHeaderView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct HomeHeaderView: View {
    @EnvironmentObject private var AuthViewModel: AuthViewModel
    var body: some View {
        VStack {
            HStack {
                Button {
                    print("add feed")
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
                    print("remove feed")
                } label: {
                    Image(systemName: "trash.fill")
                        .headerIconStyle()
                }
                
                Button {
                    AuthViewModel.logOut()
                } label: {
                    Image(systemName: "arrow.up.right.diamond")
                        .headerIconStyle()
                }
            }
            .padding(.top, 24)
            .foregroundColor(.white)
            .background(Color.blue)
            .shadow(radius: 4)
            Spacer()
        }
        .ignoresSafeArea()
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
