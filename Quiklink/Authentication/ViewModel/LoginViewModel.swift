//
//  LoginViewModel.swift
//  Quiklink
//
//  Created by Matt Bommer on 1/25/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var formType: VerificationFormType = .login
    
    @Published var formInputError: UserFormValidationError?
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var retypePassword: String = ""
    
    enum VerificationFormType: String {
        case login = "Login"
        case signUp = "Sign Up"
    }
    
    enum UserFormValidationError: Error {
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
    
    func getUser() -> User? {
        do {
            try validateEmail(email)
            try validatePassword(password)
            try validateBothPasswords(password, password)
        } catch {
            formInputError = error as? UserFormValidationError
            return nil
        }
        
        return User(username: email, password: password)
    }
    
    func validateEmail(_ email: String) throws {
        let emailSplit = email.split(separator: "@")
        if !(email.contains("@") && emailSplit.count == 2 && emailSplit.last?.split(separator: ".").count == 2) {
            throw UserFormValidationError.invalidEmail
        }
    }
    
    func validatePassword(_ password: String) throws {
        if password.count < 8 {
            throw UserFormValidationError.passwordTooShort
        } else if password.count > 254 {
            throw UserFormValidationError.passwordTooLong
        }
    }
    
    func validateBothPasswords(_ password: String, _ password2: String) throws {
        guard formType == .signUp else { return }
        if password != password2 {
            throw UserFormValidationError.passwordsDoNotMatch
        }
    }
    
    
}
