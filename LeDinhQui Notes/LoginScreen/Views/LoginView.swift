//
//  LoginView.swift
//  LeDinhQui Notes
//
//  Created by Le Dinh Qui on 20/05/2024.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @ObservedObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack{
                    Spacer()
                    Image(Images.loginBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack(spacing: 50) {
                    VStack(spacing: 20){
                        Text(Localization.appName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: FontSize.login_AppName, weight: .heavy))
                        Text(Localization.appDescription)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(AppColors.lightGray)
                    }
                    
                    VStack {
                        TextField(Localization.username, text: $viewModel.userName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .strokeBorder(Color.gray, lineWidth: FrameSize.login_TextFieldLineWidth)
                            )
                            .padding(EdgeInsets(.zero))
                        Text(Localization.registrationReminder)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: FontSize.login_RegistrationReminder))
                        
                        HStack {
                            Button(action: {
                                viewModel.register()
                            }) {
                                Text(Localization.register)
                                    .foregroundColor(.white)
                                    .font(.system(size: FontSize.login_ButtonTitle, weight: .bold))
                            }
                            .frame(width: FrameSize.login_ButtonWidth, height: FrameSize.login_ButtonHeight, alignment: .center)
                            .background(AppColors.periwinkleBlue)
                            .cornerRadius(.infinity)
                            
                            
                            Button(action: {
                                viewModel.login()
                            }) {
                                Text(Localization.login)
                                    .foregroundColor(AppColors.periwinkleBlue)
                            }
                            .frame(width: FrameSize.login_ButtonWidth - FrameSize.login_ButtonOutlineWidth, height: FrameSize.login_ButtonHeight - FrameSize.login_ButtonOutlineWidth, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(AppColors.periwinkleBlue, lineWidth: FrameSize.login_ButtonOutlineWidth)
                            )
                            .padding()
                        }
                    }
                    Spacer()
                }
                .padding()
                .alert(item: $viewModel.alertType) { alertType in
                    let error = viewModel.alertInfo(forType: alertType)
                    return Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text(Localization.ok)))
                }
                .navigationDestination(
                    isPresented: $viewModel.isLoggedIn) {
                        UserListView()
                    }
            }
        }
        .tint(AppColors.periwinkleBlue)
        
    }
    
}
