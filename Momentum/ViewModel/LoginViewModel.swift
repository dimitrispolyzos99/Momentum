//
//  LoginViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 8/5/26.
//

import Foundation
import FirebaseAuth
import Combine
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var fullname = ""
    
    // Validation logic
    var isEmailValid: Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
    
    var canSubmit: Bool {
        !isLoading && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty && isEmailValid
    }
    
    func login() {
        errorMessage = nil
        
        // 1. Προληπτικό Validation
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
                    self?.isLoggedIn = true
                }
            }
        }
    }
    
    private func mapFirebaseError(_ error: NSError) -> String {
        let authCode = AuthErrorCode(rawValue: error.code)
        let mappedError: AuthError
        
        switch authCode {
        case .networkError: mappedError = .networkError
        case .userNotFound, .invalidEmail: mappedError = .userNotFound
        case .wrongPassword: mappedError = .wrongPassword
        case .userDisabled: mappedError = .userDisabled
        case .tooManyRequests: mappedError = .tooManyRequests
        default: mappedError = .unknown(error.localizedDescription)
        }
        
        return mappedError.errorDescription ?? "An unexpected error occurred."
    }
    func signUp() {
        errorMessage = nil
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = self?.mapFirebaseError(error)
                }
            } else if let user = result?.user {
                // 1. Προετοιμασία των δεδομένων του χρήστη
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "fullname": self?.fullname ?? "",
                    "email": self?.email ?? ""
                ]
                
                // 2. Αποθήκευση στο Firestore στην collection "users"
                // Χρησιμοποιούμε το user.uid ως όνομα του εγγράφου (Document ID)
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if let error = error {
                            self?.errorMessage = "Σφάλμα βάσης: \(error.localizedDescription)"
                        } else {
                            // Επιτυχία! Σώζουμε το token και προχωράμε
                            KeychainManager.shared.save(key: "userToken", value: user.uid)
                            self?.isLoggedIn = true
                        }
                    }
                }
            }
        }
    }
}
