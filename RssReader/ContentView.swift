//
//  ContentView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authModel = AuthViewModel()
    
    var body: some View {
        Group {
            switch authModel.status {
            case .authenticated:
                HomeView()
            case .unauthenticated, .notSet:
                LoginView()
            }
        }
        .environmentObject(authModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
