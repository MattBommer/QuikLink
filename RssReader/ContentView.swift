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
        switch authViewModel.status {
        case .authenticated:
            HomeView()
                .environmentObject(authViewModel)
        case .unauthenticated, .notSet:
            LoginView(authViewModel: authViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
