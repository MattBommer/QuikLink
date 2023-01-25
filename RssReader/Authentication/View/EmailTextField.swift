//
//  EmailTextField.swift
//  RssReader
//
//  Created by Matt Bommer on 1/24/23.
//

import SwiftUI

struct EmailTextField: View {
    @FocusState private var emailFieldFocused: Bool
    var email: Binding<String>
    
    var body: some View {
        TextField("Email Address", text: email)
            .padding()
            .onSubmit({
                validate(email.wrappedValue) //TODO:
            })
            .focused($emailFieldFocused)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 0.5)
                if !emailFieldFocused {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(uiColor: .gray.withAlphaComponent(0.2)))
                        .allowsHitTesting(false)
                }
            }
    }
    
    func validate(_ email: String) -> Bool {
        let emailSplit = email.split(separator: "@")
        return email.contains("@") && emailSplit.count == 2 && emailSplit.last?.split(separator: ".").count == 2
    }
}

struct EmailTextField_Previews: PreviewProvider {
    static var previews: some View {
        EmailTextField(email: .constant("Email"))
    }
}
