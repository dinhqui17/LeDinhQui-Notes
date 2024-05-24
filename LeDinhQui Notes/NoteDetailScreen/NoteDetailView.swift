//
//  NoteDetailView.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 22/05/2024.
//

import Foundation
import Combine
import SwiftUI

struct NoteDetailView: View {
    
    @ObservedObject private var viewModel: NoteDetailViewModel
    
    init(viewModel: NoteDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: .zero) {
                
                TextField(Localization.enterNoteTitle, text: $viewModel.noteTitle)
                    .font(.system(size: FontSize.noteDetail_NoteTitle))
                    .padding()
                    .onChange(of: viewModel.noteTitle) { _ in
                        viewModel.onChange()
                    }
                // Disable the text field if the current user is not the author of the note.
                    .disabled(!viewModel.isAuthor)
                
                TextEditor(text: $viewModel.noteContent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(FrameSize.noteDetail_TextEditorPadding)
                    .onChange(of: viewModel.noteContent) { _ in
                        viewModel.onChange()
                    }
                // Disable the text editor if the current user is not the author of the note.
                    .disabled(!viewModel.isAuthor)
                    .overlay(
                        Group {
                            // If not author, show restrict warning.
                            if !viewModel.isAuthor {
                                Text(Localization.restrict)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 2/3)
                                    .foregroundColor(.black)
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .background(AppColors.silverGray)
                                    .cornerRadius(FrameSize.noteDetail_RestrictAlertCornerRadius)
                                    .font(.system(size: FontSize.noteDetail_RestrictContent))
                            }
                        }
                    )
                
            }
            
        }
        .navigationBarItems(trailing: HStack {
            // Show the Save button only if the current user is the author of the note.
            if viewModel.isAuthor {
                Button(action: {
                    viewModel.saveNote()
                })
                {
                    Text(Localization.saveNote)
                }
                // Disable the save button if the note has already been saved.
                .disabled(viewModel.isSaved)
            }
        })
        
    }
    
}
