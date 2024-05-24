//
//  UserNotesViewModel.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 22/05/2024.
//

import Foundation
import Combine

class UserNotesViewModel: ObservableObject {
    
    @Published var notes: [NoteModel] = []
    @Published var error: Error?
    @Published var userId: String
    @Published var username: String?
    
    init(userId: String, username: String?) {
        self.userId = userId
        self.username = username
    }
    
    var requestDataCancellable: AnyCancellable? {
        willSet {
            requestDataCancellable?.cancel()
        }
    }
    
    func loadNotes() {
        requestDataCancellable = DatabaseService.shared.getAllNotesFromUser(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    self?.error = nil
                }
            } receiveValue: { [weak self] results in
                self?.notes = results
            }
    }
    
}
