//
//  Constant.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 20/05/2024.
//

import Foundation
import SwiftUI

class Constants: NSObject {
    static let endpoint = ""
    static let keyUserId = "KeyUserId"
    static let usernameMaxLength = 15
}

struct AppColors {
    static let lightGray = Color(hex: "#525354")
    static let mainGreen = Color(hex: "#65DC8A")
    static let periwinkleBlue = Color(hex: "#6173EE")
    static let silverGray = Color(hex: "#bababa")
}

struct Localization {
    static let appName = "LDQ Notes"
    static let appDescription = "Stay organized and boost your productivity with LDQ Notes, the ultimate digital notebook designed for everyone."
    static let username = "Username"
    static let registrationReminder = "* If you don't have an account, please register."
    static let register = "Register"
    static let login = "Login"
    static let errorTitle = "Ohhh, there's something wrong."
    static let userNotExist = "User does not exist, please register."
    static let ok = "OK"
    static let great = "Great!"
    static let registerSuccesfully = "You have successfully registered, please log in."
    static let usernameIsNotValid = "Username must not be more than 15 characters and must not contain special characters."
    static let myNotes = "My notes"
    static let viewNoteOtherUsers = "View note from other users"
    static let notes = "Notes"
    static let noteOf = "'s notes"
    static let lastUpdated = "Last updated:"
    static let noNotes = "No notes"
    static let enterNoteTitle = "Enter note title"
    static let saveNote = "Save"
    static let restrict = "You cannot modify this note because you are not its author."
    static let usernameAlreadyExist = "This username is already taken, please try another username."
}

struct Images {
    static let loginBackground = "background"
}

struct FontSize {
    static let titleInNoteList: CGFloat = 16.0
    static let lastUpdated: CGFloat = 12.0
    static let login_AppName: CGFloat = 30.0
    static let login_RegistrationReminder: CGFloat = 13.0
    static let login_ButtonTitle: CGFloat = 17.0
    static let noteDetail_NoteTitle: CGFloat = 25.0
    static let noteDetail_RestrictContent: CGFloat = 12.0
}

struct FrameSize {
    static let login_ButtonOutlineWidth: CGFloat = 2.0
    static let login_ButtonWidth: CGFloat = 100.0
    static let login_ButtonHeight: CGFloat = 35.0
    static let login_TextFieldLineWidth: CGFloat = 0.5
    static let noteDetail_RestrictAlertCornerRadius: CGFloat = 8.0
    static let noteDetail_TextEditorPadding: CGFloat = 12.0
}
