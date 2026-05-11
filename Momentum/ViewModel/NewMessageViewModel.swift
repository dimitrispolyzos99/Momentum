//
//  NewMessageViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 11/5/26.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class NewMessageViewModel: ObservableObject {
    // Εδώ αποθηκεύουμε τους χρήστες που βρίσκουμε
    @Published var users = [User]()
    
    private let userService = UserService()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        // Καλούμε τον UserService για να φέρει τα δεδομένα
        userService.fetchUsers { [weak self] fetchedUsers in
            DispatchQueue.main.async {
                // Ενημερώνουμε τη λίστα users που βλέπει το View
                self?.users = fetchedUsers
            }
        }
    }
}
