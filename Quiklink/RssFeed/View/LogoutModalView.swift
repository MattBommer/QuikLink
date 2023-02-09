//
//  LogoutModalView.swift
//  Quiklink
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
                    modalStore.dismiss()
                } label: {
                    Text("Yes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color(uiColor: .brandWhite))
                }
                .background(Color(uiColor: .brandBlue))
                .cornerRadius(8)

                Button {
                    modalStore.dismiss()
                } label: {
                    Text("No")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color(uiColor: .brandBlue))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(uiColor: .brandBlue), lineWidth: 2)
                        )
                }
                .cornerRadius(8)
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: .brandWhite))
        }
        .padding()
    }
}

struct LogoutModalView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutModalView()
    }
}
