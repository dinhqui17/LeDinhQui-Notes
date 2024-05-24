//
//  UserListView.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 22/05/2024.
//

import Foundation
import SwiftUI

struct UserListView: View {
    
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            VStack {
                List {
                    Section(header: Text(Localization.myNotes)
                    ) {
                        NavigationLink(destination: UserNotesScreen(viewModel: UserNotesViewModel(userId: UserDefaults.standard.string(forKey: Constants.keyUserId) ?? "", username: nil))) {
                            Text(Localization.myNotes)
                        }
                    }
                    .headerProminence(.increased)
                    
                    Section(header:Text(Localization.viewNoteOtherUsers)) {
                        ForEach(viewModel.userList, id: \.self) { user in
                            NavigationLink(destination: UserNotesScreen(viewModel: UserNotesViewModel(userId: user.userId, username: user.username))) {
                                Text(user.username)
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
                .listStyle(.insetGrouped)
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
        .onAppear {
            viewModel.loadUserList()
        }
        .navigationTitle(Text(Localization.notes))
    }
}

struct UserListView_Preview: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
