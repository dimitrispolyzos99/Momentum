//
//  UserService.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 11/5/26.
//

import FirebaseFirestore
import FirebaseAuth

class UserService {
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        // Παίρνουμε όλα τα έγγραφα από την collection "users"
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("DEBUG: Δεν βρέθηκαν χρήστες")
                return
            }
            
            // Μετατρέπουμε τα δεδομένα σε [User] objects
            let users = documents.compactMap({ try? $0.data(as: User.self) })
            
            // ΦΙΛΤΡΟ: Κρατάμε όλους τους χρήστες ΕΚΤΟΣ από τον εαυτό μας
            // Δεν θέλεις να στέλνεις μήνυμα στον εαυτό σου!
            let filteredUsers = users.filter({ $0.uid != Auth.auth().currentUser?.uid })
            
            // Επιστρέφουμε τη λίστα στο ViewModel
            completion(filteredUsers)
        }
    }
}
