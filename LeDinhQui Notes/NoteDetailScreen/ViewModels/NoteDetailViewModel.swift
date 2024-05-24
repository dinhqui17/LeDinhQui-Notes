//
//  NoteDetailViewModel.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 22/05/2024.
//

import Foundation
import Combine

class NoteDetailViewModel: ObservableObject {
    @Published var noteTitle: String
    @Published var noteContent: String
    @Published var noteId: String
    @Published var noteDetail: NoteModel?
    @Published var isAuthor: Bool
    @Published var isSaved: Bool = true
    
    init(noteDetail: NoteModel?) {
        self.noteDetail = noteDetail
        self.noteTitle = noteDetail?.title ?? ""
        self.noteContent = noteDetail?.content ?? ""
        self.noteId = noteDetail?.noteId ?? ""
        
        // If note detail is nil, we're adding a new note.
        // If note's userId equals saved userId, the current user is the author.
        if noteDetail == nil || noteDetail?.userId == UserDefaults.standard.string(forKey: Constants.keyUserId) {
            self.isAuthor = true
        } 
        // If not, the current user isn't the author.
        else {
            self.isAuthor = false
        }
        
    }
    
    var requestDataCancellable: AnyCancellable? {
        willSet {
            requestDataCancellable?.cancel()
        }
    }

    func saveNote() {
        // Add a new note if noteId is empty, otherwise update the existing note.
        noteId == "" ? addNote() : updateNote()
    }
    
    
    func addNote() {
        guard let userId = UserDefaults.standard.string(forKey: "KeyUserId") else { return }
        let note = NoteModel(noteId: nil, userId: userId, title: noteTitle, content: noteContent, createdDate: Int(Date().timeIntervalSince1970), updatedDate: Int(Date().timeIntervalSince1970))
        requestDataCancellable = DatabaseService.shared.addNote(with: note)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                self?.isSaved = result
            }
    }
    
    func updateNote() {
        requestDataCancellable = DatabaseService.shared.updateNote(noteId: noteId, newTitle: noteTitle, newContent: noteContent)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                self?.isSaved = result
            }
    }
    
    func onChange() {
        isSaved = false
    }

}
