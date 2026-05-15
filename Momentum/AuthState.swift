//
//  AuthState.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 15/5/26.
//

import Foundation
import FirebaseAuth
import Combine

class AuthState: ObservableObject {
    @Published var isLoggedIn: Bool = false

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
        }
    }

    deinit {
        if let handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
