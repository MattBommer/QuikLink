//
//  ProfileView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/26/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            Spacer()
            Button {
                authViewModel.logOut()
            } label: {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom])
                    .background(Color(uiColor: .brandRed))
                    .foregroundColor(Color(uiColor: .brandWhite))
                    .cornerRadius(8)
            }
            .padding([.leading, .trailing])

            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
