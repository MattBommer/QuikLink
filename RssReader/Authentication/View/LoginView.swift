//
//  LoginView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var userAction: UserAction = .login
    @State var username: String = ""
    @State var password: String = ""
    @State var verifyPassword: String = ""
    
    var user: User {
        User(username: username, password: password)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Image(uiImage: UIImage(named: "logo")!)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(8)
            
            VStack(spacing: 8) {
                EmailTextField(email: $username)
                PasswordTextField(placeholder: "Password", password: $password)
                if userAction == .signUp {
                    PasswordTextField(placeholder: "Retype Password", password: $verifyPassword)
                }
            }
            
            VStack(spacing: 40) {
                VStack {
                    StretchButton {
                        Task {
                            switch userAction {
                            case .login:
                                try await authViewModel.login(user: user)
                            case .signUp:
                                let _ = try await authViewModel.signUp(user: user)
                            }
                        }
                    } label: {
                            Text(userAction.rawValue)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .fill(backgroundColor: .brandBlue)

                    Button {
                        switch userAction {
                        case .login:
                            print("Forgot password flow") //TODO: Don't think I will do this
                        case .signUp:
                            userAction = .login
                        }
                    } label: {
                        switch userAction {
                        case .login:
                            Text("Forgot your password?")
                                .font(.callout)
                                .foregroundColor(.gray)
                        case .signUp:
                            Text("Already have an account? Login here")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(4)

                }
                
                VStack {
                    Text("Don't have a QuikLink account?")
                    StretchButton {
                        userAction = .signUp
                    } label: {
                        Text("Create new account")
                            .foregroundColor(Color(uiColor: .brandBlue))
                    }
                    .outline(backgroundColor: .brandWhite, strokeColor: .brandBlue)
                }
                .isHidden(userAction == .signUp)
            }
            
            Spacer()
        }
        .padding()
    }
    
    enum UserAction: String {
        case login = "Login"
        case signUp = "Sign Up"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel.shared)
    }
}

extension View {
    @ViewBuilder
    func isHidden(_ hide: Bool, hideInPlace: Bool = true) -> some View {
        if hideInPlace {
            self.opacity(hide ? 0.0 : 1.0)
        } else if hide {
            self.hidden()
        } else {
            self
        }
    }
}
