//
//  UserInputValidationViewModel.swift
//  RssReader
//
//  Created by Matt Bommer on 1/25/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    
    
    enum UserFormValidationErrors {
        case invalidEmail
        case passwordTooShort
        case passwordTooLong
        case passwordsDoNotMatch
        
        var message: String {
            switch self {
            case .invalidEmail:
                return "Email is invalid. Try again."
            case .passwordTooShort:
                return "Password must be at least 8 characters long."
            case .passwordTooLong:
                return "Password must be less than 254 characters."
            case .passwordsDoNotMatch:
                return "Passwords do not match. Try again."
            }
        }
    }
    
    func validateEmail(_ email: String) {
        let emailSplit = email.split(separator: "@")
        let isValid = email.contains("@") && emailSplit.count == 2 && emailSplit.last?.split(separator: ".").count == 2
        userFormValidationError = !isValid ? .invalidEmail : nil
    }
    
    func validatePassword(_ password: String) {
        if password.count < 8 {
            userFormValidationError = .passwordTooShort
        } else if password.count > 254 {
            userFormValidationError = .passwordTooLong
        } else {
            userFormValidationError = nil
        }
    }
    
    func validateBothPasswords(_ password: String, _ password2: String) {
        if password != password2 {
            userFormValidationError = .passwordsDoNotMatch
        } else {
            userFormValidationError = nil
        }
    }
}
