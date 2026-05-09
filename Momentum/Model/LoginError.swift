//
//  LoginError.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 8/5/26.
//

import Foundation

enum AuthError: LocalizedError {
    case emptyFields
    case invalidEmail
    case networkError
    case userNotFound
    case wrongPassword
    case userDisabled
    case tooManyRequests
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .emptyFields: return "Email and password are required."
        case .invalidEmail: return "Please enter a valid email address."
        case .networkError: return "Network error. Please check your connection."
        case .userNotFound: return "We couldn't find an account with that email."
        case .wrongPassword: return "Incorrect password. Please try again."
        case .userDisabled: return "This account has been disabled."
        case .tooManyRequests: return "Too many attempts. Please wait a moment."
        case .unknown(let message): return message
        }
    }
}
