//
//  LoginViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 8/5/26.
//

import Foundation
import FirebaseAuth
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    var isEmailValid: Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    var canSubmit: Bool {
        !isLoading &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        isEmailValid
    }

    func login() {
        errorMessage = nil
        guard isEmailValid else {
            errorMessage = AuthError.invalidEmail.errorDescription
            return
        }

        isLoading = true

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error as NSError? {
                    self?.errorMessage = self?.mapFirebaseError(error)
                } else if let user = result?.user {
                    KeychainManager.shared.save(key: "userToken", value: user.uid)
                }
            }
        }
    }

    private func mapFirebaseError(_ error: NSError) -> String {
        let authCode = AuthErrorCode(rawValue: error.code)
        let mappedError: AuthError

        switch authCode {
        case .networkError:                    mappedError = .networkError
        case .userNotFound, .invalidEmail:     mappedError = .userNotFound
        case .wrongPassword:                   mappedError = .wrongPassword
        case .userDisabled:                    mappedError = .userDisabled
        case .tooManyRequests:                 mappedError = .tooManyRequests
        default: mappedError = .unknown(error.localizedDescription)
        }

        return mappedError.errorDescription ?? "An unexpected error occurred."
    }
}
