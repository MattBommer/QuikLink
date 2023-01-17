//
//  LoginView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var username: String = ""
    @State var password: String = ""
    @State var signUpStatus: String = ""
    
    var user: User {
        User(username: username, password: password)
    }
    
    var body: some View {
        VStack(spacing: 48) {
            Text("Simple Rss Reader")
                .padding()
                .font(.title)
            
            VStack(spacing: 8) {
                TextField("Username", text: $username)
                    .padding(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue)
                    )
                SecureField("Password", text: $password)
                    .padding(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue)
                    )
            }
            VStack(spacing: 8) {
                Button {
                    Task {
                        try await authViewModel.login(user: user)
                    }
                } label: {
                    Text("Login")
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue)
                )
                
                Button {
                    Task {
                        guard let message = try await authViewModel.signUp(user: user) else { return }
                        signUpStatus = message
                    }
                } label: {
                    Text("Sign Up")
                        .padding()
                }
                
                Text(signUpStatus)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel())
    }
}
