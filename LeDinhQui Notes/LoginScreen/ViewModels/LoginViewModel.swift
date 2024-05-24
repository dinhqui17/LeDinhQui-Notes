//
//  LoginViewModel.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 20/05/2024.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    enum AlertType: Identifiable {
        case userNotExist, successRegister, usernameNotValid, usernameAlreadyExist
        var id: AlertType { self }
    }
    
    var requestDataCancellable: AnyCancellable? {
        willSet {
            requestDataCancellable?.cancel()
        }
    }
    
    @Published var alertType: AlertType?
    @Published var userName: String = ""
    @Published var error: Error?
    @Published var isLoggedIn = false
    
    func isUsernameValid() -> Bool {
        var isValid = false
        // The username must not exceed 15 characters in length.
        isValid = userName.count <= Constants.usernameMaxLength
        
        // The username must not contain special characters.
        if userName.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            isValid = false
        }
        
        return isValid
    }
    
    func register() {
        // If the username is valid, check for existing users.
        if isUsernameValid() {
            requestDataCancellable = DatabaseService.shared.checkExistUser(userName: userName)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.error = error
                    case .finished:
                        self?.error = nil
                    }
                } receiveValue: { [weak self] userId in
                    // If the userId is empty, no one has registered with this username, proceed to create a new user.
                    if userId == "" {
                        self?.createUser()
                    } 
                    // If the userId is not empty, someone has already registered with this username, display an alert.
                    else {
                        DispatchQueue.main.async {
                            self?.alertType = .usernameAlreadyExist
                        }
                    }
                }
        } 
        // Display an alert if the username is not valid.
        else {
            DispatchQueue.main.async {
                self.alertType = .usernameNotValid
            }
        }
    }
    
    func createUser() {
        let user = UserModel(userId: UUID().uuidString, username: userName)
        requestDataCancellable = DatabaseService.shared.addUser(user: user)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    self?.error = nil
                }
            } receiveValue: { [weak self] success in
                // Display an alert if the registration is successful.
                if success {
                    DispatchQueue.main.async {
                        self?.alertType = .successRegister
                    }
                }
            }
    }
    
    func login() {
        requestDataCancellable = DatabaseService.shared.checkExistUser(userName: userName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    self?.error = nil
                }
            } receiveValue: { [weak self] userId in
                // If the userId has a value, the login was successful.
                self?.isLoggedIn = userId != ""
                // Save userId to UserDefaults.
                UserDefaults.standard.set(userId, forKey: Constants.keyUserId)
                // If the userId is empty, the user does not exist, display an alert.
                if userId == "" {
                    DispatchQueue.main.async {
                        self?.alertType = .userNotExist
                    }
                }
                
            }
    }
    
    func alertInfo(forType type: AlertType) -> AlertInfo {
        switch type {
        case .userNotExist:
            return AlertInfo(title: Localization.errorTitle, message: error?.localizedDescription ?? Localization.userNotExist)
        case .successRegister:
            return AlertInfo(title: Localization.great, message: error?.localizedDescription ?? Localization.registerSuccesfully)
        case .usernameNotValid:
            return AlertInfo(title: Localization.errorTitle, message: error?.localizedDescription ?? Localization.usernameIsNotValid)
        case .usernameAlreadyExist:
            return AlertInfo(title: Localization.errorTitle, message: error?.localizedDescription ?? Localization.usernameAlreadyExist)
        }
    }
    
}
