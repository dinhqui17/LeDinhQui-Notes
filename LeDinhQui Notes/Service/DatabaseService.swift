//
//  FirebaseRealtimeDB.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 20/05/2024.
//

import Foundation
import FirebaseDatabase
import Combine

class DatabaseService {
    
    static let shared = DatabaseService()
    private let ref = Database.database(url: EndPointItem.shared.firebaseEndpoint).reference()
    
    
    /// Add new user to Firebase Realtime DB
    /// - Parameters:
    ///   - user: The user model to be added to the database.
    /// - Returns:
    ///    Future:  A Future that represents the result of the database operation.
    func addUser(user: UserModel) -> Future<Bool, Error> {
        return Future { promise in
            let userRef = self.ref.child("users").childByAutoId()
            userRef.setValue(["username": user.username]) { (error, _) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
    }
    
    /// Check if a user exists in Firebase Realtime DB
    /// - Parameters:
    ///   - userName: The username of the user to check.
    /// - Returns: A Future encapsulating the result:
    ///   - Success: Contains the user's ID if found, or an empty string if not.
    ///   - Failure: Contains the error that caused the failure.
    func checkExistUser(userName: String) -> Future<String, Error> {
        return Future { promise in
            self.ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: userName)
                .observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() {
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot {
                                let userId = childSnapshot.key
                                promise(.success(userId))
                            }
                        }
                    } else {
                        promise(.success(""))
                    }
                }) { error in
                    promise(.failure(error))
                }
        }
    }
    
    /// Retrieve all users from Firebase Realtime DB, excluding the currently logged in user.
    /// - Returns: A Future encapsulating the result:
    ///     - Success: Contains an array of UserModel.
    ///     - Failure: Contains the error that caused the failure.
    func getAllUsers() -> Future<[UserModel], Error> {
        return Future { promise in
            self.ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
                var users = [UserModel]()
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let dict = snapshot.value as? [String: Any],
                       let username = dict["username"] as? String {
                        let userId = snapshot.key
                        // Exclude currently logged in users.
                        if userId == UserDefaults.standard.string(forKey: "KeyUserId") {
                            continue
                        }
                        let user = UserModel(userId: userId, username: username)
                        users.append(user)
                    }
                }
                promise(.success(users))
            }) { error in
                promise(.failure(error))
            }
        }
    }
    
    /// Add a new note to Firebase Realtime DB.
    /// - Parameter note: The NoteModel to be added to the database.
    /// - Returns: A Future encapsulating the result:
    ///     - Success: Contains a boolean value of `true` indicating the note was successfully added.
    ///     - Failure: Contains the error that caused the failure.
    func addNote(with note: NoteModel) -> Future<Bool, Error> {
        return Future { promise in
            let noteRef = self.ref.child("notes").childByAutoId()
            noteRef.setValue(note.toDictionary()) { (error, _) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
    }
    
    /// Update an existing note in Firebase Realtime DB.
    /// - Parameters:
    ///   - noteId: The ID of the note to be updated.
    ///   - newTitle: The new title for the note.
    ///   - newContent: The new content for the note.
    /// - Returns: A Future encapsulating the result:
    ///     - Success: Contains a boolean value of `true` indicating the note was successfully updated.
    ///     - Failure: Contains the error that caused the failure.
    func updateNote(noteId: String, newTitle: String, newContent: String) -> Future<Bool, Error> {
        return Future { promise in
            let noteRef = self.ref.child("notes").child(noteId)
            noteRef.updateChildValues(["title": newTitle, "content": newContent, "updatedDate": Int(Date().timeIntervalSince1970)]) { error, _ in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true)
                    )}
            }
        }
    }
    
    /// Retrieve all notes from a specific user in Firebase Realtime DB.
    /// - Parameter userId: The ID of the user whose notes are to be retrieved.
    /// - Returns: A Future encapsulating the result:
    ///     - Success: Contains an array of NoteModel.
    ///     - Failure: Contains the error that caused the failure.
    func getAllNotesFromUser(userId: String) -> Future<[NoteModel], Error> {
        return Future { promise in
            self.ref.child("notes").queryOrdered(byChild: "userId").queryEqual(toValue: userId)
                .observeSingleEvent(of: .value, with: { snapshot in
                    var notes = [NoteModel]()
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                           let dict = snapshot.value as? [String: Any],
                           let content = dict["content"] as? String,
                           let title = dict["title"] as? String,
                           let updatedDate = dict["updatedDate"] as? Int,
                           let createdDate = dict["createdDate"] as? Int,
                           let userId = dict["userId"] as? String
                        {
                            let note = NoteModel(noteId: snapshot.key, userId: userId, title: title, content: content, createdDate: createdDate, updatedDate: updatedDate)
                            notes.append(note)
                        }
                    }
                    promise(.success(notes))
                }) { error in
                    promise(.failure(error))
                }
        }
    }
    
}
