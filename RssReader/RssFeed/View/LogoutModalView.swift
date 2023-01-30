//
//  LogoutModalView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/30/23.
//

import SwiftUI

struct LogoutModalView: View {
    @EnvironmentObject var modalStore: ModalStore
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Are you sure you want to log out?")
                .font(.headline)
                .padding()
            HStack {
                Button {
                    authViewModel.logOut()
                } label: {
                    Text("Yes")
                        .padding()
                        .background(Color(uiColor: .brandRed))
                        .cornerRadius(8)
                }
                Button {
                    modalStore.dismiss()
                } label: {
                    Text("No")
                        .padding()
                        .background(Color(uiColor: .brandGreen))
                        .cornerRadius(8)
                }
            }
            .foregroundColor(Color(uiColor: .brandWhite))
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: .brandWhite))
        }
    }
}

struct LogoutModalView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutModalView()
    }
}
