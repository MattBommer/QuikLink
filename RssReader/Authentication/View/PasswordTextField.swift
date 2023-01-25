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
    var focusedField: FocusState<UserFocusable?>.Binding
    var fieldType: UserFocusable
    
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            textfield(showPassword: showPassword)
                .padding()
                .focused(focusedField, equals: fieldType)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
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
    
    @ViewBuilder
    func textfield(showPassword: Bool) -> some View {
        if showPassword {
            TextField(placeholder, text: password)
        } else {
            SecureField(placeholder, text: password)
        }
    }
}
