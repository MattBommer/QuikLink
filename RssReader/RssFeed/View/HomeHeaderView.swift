//
//  HomeHeaderView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct HomeHeaderView: View {
    @State private var manageFeedsPresented: Bool = false
    @EnvironmentObject private var modalStore: ModalStore
    
    var body: some View {
        HStack {
            Button {
                manageFeedsPresented = true
            } label: {
                Image(systemName: "square.stack.3d.up")
                    .icon()
            }
            
            Spacer()
            
            Text("QuikLink")
                .font(.title)
            
            Spacer()
            
            Button {
                modalStore.present {
                    LogoutModalView()
                }
            } label: {
                Image("logout")
                    .icon()
            }

        }
        .foregroundColor(Color(uiColor: .brandWhite))
        .background(Color(uiColor: .brandPurple), ignoresSafeAreaEdges: .top)
        .sheet(isPresented: $manageFeedsPresented) {
            ManageFeedView()
        }
    }
}
struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
