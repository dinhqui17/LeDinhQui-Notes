//
//  NoteModel.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 22/05/2024.
//

import Foundation

struct NoteModel: Hashable {
    let noteId: String?
    let userId: String
    let title: String
    let content: String
    let createdDate: Int
    let updatedDate: Int
    
    func toDictionary() -> [String:Any] {
        return [
            "userId": userId,
            "title": title,
            "content": content,
            "createdDate": createdDate,
            "updatedDate": updatedDate
        ]
    }
}
