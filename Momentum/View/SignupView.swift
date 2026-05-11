//
//  LoginView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 8/5/26.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Sign up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    if !viewModel.email.isEmpty && !viewModel.isEmailValid {
                        Text("Please enter a valid email address.")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Username", text: $viewModel.fullname)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        HStack{
                            Button("Sign up") {
                                viewModel.signUp()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(!viewModel.canSubmit)
                            .opacity(viewModel.canSubmit ? 1 : 0.6)
                            
                        }
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
                    LoginView()
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
