//
//  ContentView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        RootModalView(backgroundColor: Color(uiColor: .gray.withAlphaComponent(0.3))) {
            Group {
                switch authViewModel.status {
                case .authenticated:
                    HomeView()
                case .unauthenticated, .notSet:
                    LoginView()
                }
            }
        }
        .environmentObject(authViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
