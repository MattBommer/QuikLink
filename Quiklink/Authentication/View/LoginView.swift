//
//  LoginView.swift
//  Quiklink
//
//  Created by Matt Bommer on 1/12/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var modalStore: ModalStore
    @StateObject var loginViewModel = LoginViewModel()
    
    private var subtitleText: String {
        switch loginViewModel.formType {
        case .login:
            return "Forgot your password?"
        case .signUp:
            return "Already have an account? Click here."
        }
    }
    
    private var captionButtonAction: () {
        switch loginViewModel.formType {
        case .login:
            print("Forgot password flow") // Won't do
        case .signUp:
            loginViewModel.formType = .login
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Image(uiImage: UIImage(named: "quiklink")!)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(8)
            
            UserFormView(loginViewModel: loginViewModel)
            
            VStack(spacing: 40) {
                VStack {
                    StretchButton {
                        Task {
                            guard let user = loginViewModel.getUser() else { return }
                            do {
                                switch loginViewModel.formType {
                                case .login:
                                    try await authViewModel.login(user: user)
                                case .signUp:
                                    let signUpResponse = try await authViewModel.signUp(user: user).message
                                    modalStore.present(view: {
                                        MessageView(message: signUpResponse)
                                    }, dim: false, ignoreSafeArea: false)
                                    loginViewModel.formType = .login
                                }
                            } catch {
                                error.displayMessage(with: modalStore)
                            }
                        }
                    } label: {
                        Text(loginViewModel.formType.rawValue)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .fill(backgroundColor: .brandBlue)
                    
                    Button {
                        captionButtonAction
                    } label: {
                        Text(subtitleText)
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                    .padding(4)
                    
                }
                
                VStack {
                    Text("Don't have a QuikLink account?")
                    StretchButton {
                        loginViewModel.formType = .signUp
                    } label: {
                        Text("Create new account")
                            .foregroundColor(Color(uiColor: .brandBlue))
                    }
                    .outline(backgroundColor: .brandWhite, strokeColor: .brandBlue)
                }
                .isHidden(loginViewModel.formType == .signUp)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
