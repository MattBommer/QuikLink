//
//  HomeHeaderView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/17/23.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Button {
                    print("add feed")
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding()
                }
                
                Spacer()
                
                Text("Simple RSS Reader")
                    .font(.title)
                    .padding()

                Spacer()
                
                Button {
                    print("remove feed")
                } label: {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding()
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

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
