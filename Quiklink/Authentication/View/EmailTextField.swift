//
//  EmailTextField.swift
//  Quiklink
//
//  Created by Matt Bommer on 1/24/23.
//

import SwiftUI

struct EmailTextField: View {
    var email: Binding<String>
    var focusedField: FocusState<UserFocusable?>.Binding
    
    var body: some View {
        TextField("Email Address", text: email)
            .padding()
            .textInputAutocapitalization(.never)
            .focused(focusedField, equals: .email)
            .disableAutocorrection(true)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 0.5)
            }
    }
}
