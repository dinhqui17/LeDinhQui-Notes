//
//  UserNotes.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 22/05/2024.
//

import Foundation
import SwiftUI

struct UserNotesScreen: View {
    
    @ObservedObject var viewModel: UserNotesViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Display a "No Notes" message if the notes array is empty.
            if viewModel.notes.isEmpty {
                Text(Localization.noNotes)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } 
            // Display the list of notes if the notes array is not empty.
            else {
                List {
                    Section(header: Text(viewModel.username != nil ? "\(viewModel.username!)\(Localization.noteOf)" : Localization.myNotes)) {
                        ForEach(viewModel.notes, id: \.self) { note in
                            NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(noteDetail: note))) {
                                VStack(alignment: .leading, spacing: 5.0) {
                                    Text(note.title)
                                        .font(.system(size: FontSize.titleInNoteList, weight: .bold))
                                    Text("\(Localization.lastUpdated) \(note.updatedDate.formattedDateString())")
                                        .font(.system(size: FontSize.lastUpdated))
                                        .foregroundColor(Color.gray)
                                }
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            Button(action: {}) {
                NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(noteDetail: nil))) {
                    Image(systemName: "pencil")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(AppColors.periwinkleBlue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
        .onAppear{
            viewModel.loadNotes()
        }
        .navigationTitle(Text(viewModel.username != nil ? "\(viewModel.username!)\(Localization.noteOf)" : Localization.myNotes))
    }
}


