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

    @Published var users = [User]()
    
    private let userService = UserService()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {

        userService.fetchUsers { [weak self] fetchedUsers in
            DispatchQueue.main.async {
                self?.users = fetchedUsers
            }
        }
    }
}
