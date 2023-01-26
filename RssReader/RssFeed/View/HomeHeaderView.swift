//
//  HomeHeaderView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct HomeHeaderView: View {
    @State private var manageFeedsPressed: Bool = false
    @State private var profilePressed: Bool = false
    
    var body: some View {
        HStack {
            Button {
                print("Manage feeds")
            } label: {
                Image(systemName: "square.stack.3d.up")
                    .headerIconStyle()
            }
            
            Spacer()
            
            Text("QuikLink")
                .font(.title)
            
            Spacer()
            
            Button {
                profilePressed = true
            } label: {
                Image(systemName: "person")
                    .headerIconStyle()
            }

        }
        .foregroundColor(Color(uiColor: .brandWhite))
        .background(Color(uiColor: .brandPurple), ignoresSafeAreaEdges: .top)
        .sheet(isPresented: $profilePressed) {
            profilePressed = false
        } content: {
            ProfileView()
        }

    }
}

private extension Image {
    
    func headerIconStyle() -> some View {
        resizable()
            .frame(width: 20, height: 20, alignment: .center)
            .padding()
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
