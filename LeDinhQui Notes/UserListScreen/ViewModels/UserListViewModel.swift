//
//  UserListViewModel.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 22/05/2024.
//

import Foundation
import Combine

class UserListViewModel: ObservableObject {
    
    @Published var userList: [UserModel] = []
    @Published var error: Error?
    
    var requestDataCancellable: AnyCancellable? {
        willSet {
            requestDataCancellable?.cancel()
        }
    }
    
    func loadUserList() {
        requestDataCancellable = DatabaseService.shared.getAllUsers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    self?.error = nil
                }
            } receiveValue: { [weak self] results in
                self?.userList = results
            }
    }
    
}
