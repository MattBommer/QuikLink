//
//  UserFormView.swift
//  Quiklink
//
//  Created by Matt Bommer on 1/25/23.
//

import SwiftUI

enum UserFocusable: Hashable {
    case email
    case password
    case retypePassword
}

struct UserFormView: View {
    @FocusState private var fieldInFocus: UserFocusable?
    @ObservedObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            EmailTextField(email: $loginViewModel.email, focusedField: $fieldInFocus)
            PasswordTextField(placeholder: "Password", password: $loginViewModel.password, focusedField: $fieldInFocus, fieldType: .password)
            if loginViewModel.formType == .signUp {
                PasswordTextField(placeholder: "Re-type Password", password: $loginViewModel.retypePassword, focusedField: $fieldInFocus, fieldType: .retypePassword)
            }
            
            if let formInputError = loginViewModel.formInputError {
                Text(formInputError.message)
                    .foregroundColor(Color(uiColor: .brandRed))
                    .font(.caption)
            }
        }
        .onSubmit {
            guard let fieldInFocus = fieldInFocus else { return }
            switch fieldInFocus {
            case .email:
                self.fieldInFocus = .password
            case .password:
                self.fieldInFocus = loginViewModel.formType == .signUp ? .retypePassword : nil
            case .retypePassword:
                self.fieldInFocus = nil
            }
        }
    }
}

struct UserFormView_Previews: PreviewProvider {
    static var previews: some View {
        UserFormView(loginViewModel: LoginViewModel())
    }
}
