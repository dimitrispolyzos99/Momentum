//
//  SignupViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 15/5/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    var isEmailValid: Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    var canSubmit: Bool {
        !isLoading &&
        !fullname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        isEmailValid
    }

    func signUp() {
        errorMessage = nil
        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } else if let user = result?.user {
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "fullname": self?.fullname ?? "",
                    "email": self?.email ?? ""
                ]
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                        } else {
                            KeychainManager.shared.save(key: "userToken", value: user.uid)
                            self?.isLoggedIn = true
                        }
                    }
                }
            }
        }
    }
}
