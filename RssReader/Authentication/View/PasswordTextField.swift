//
//  PasswordTextField.swift
//  RssReader
//
//  Created by Matt Bommer on 1/24/23.
//

import SwiftUI

struct PasswordTextField: View {
    var placeholder: String
    var password: Binding<String>
    @State private var showPassword: Bool = false
    @FocusState private var passwordFieldFocused: Bool
    
    var body: some View {
        ZStack {
            textfield(showPassword: showPassword)
                .padding()
                .onSubmit({
                    validate(password.wrappedValue) //TODO: 
                })
                .focused($passwordFieldFocused)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
                    if !passwordFieldFocused {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(uiColor: .gray.withAlphaComponent(0.2)))
                            .allowsHitTesting(false)
                    }
                }
            HStack {
                Spacer()
                Image(systemName: showPassword ? "eye" : "eye.slash")
                    .padding(8)
                    .onTapGesture {
                        showPassword.toggle()
                    }
                
            }
        }
    }
    
    func validate(_ password: String) -> Bool {
        return password.count > 8 && password.count < 32
    }
    
    @ViewBuilder
    func textfield(showPassword: Bool) -> some View {
        if showPassword {
            TextField(placeholder, text: password)
        } else {
            SecureField(placeholder, text: password)
        }
    }
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(placeholder: "Password", password: .constant("Password"))
    }
}
