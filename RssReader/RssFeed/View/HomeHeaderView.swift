//
//  HomeHeaderView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct HomeHeaderView: View {
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
                print("Profile Settings")
            } label: {
                Image(systemName: "person")
                    .headerIconStyle()
            }

        }
        .foregroundColor(Color(uiColor: .brandWhite))
        .background(Color(uiColor: .brandPurple), ignoresSafeAreaEdges: .top)
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
