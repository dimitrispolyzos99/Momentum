//
//  LoginView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 8/5/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isNewUser = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Welcome Back")
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
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        HStack {
                            Button("Login") {
                                viewModel.login()
                            }
                            .disabled(!viewModel.canSubmit)
                            .opacity(viewModel.canSubmit ? 1 : 0.6)
                            .padding()
                            .background(Color.purple.opacity(0.3))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            
                            Button("Sign up") {
                                isNewUser = true
                            }
                            .padding()
                            .background(Color.purple.opacity(0.3))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
                    HomeView()
                }
            }
            .sheet(isPresented: $isNewUser) {
                SignupView()
            }
        }
    }
}

#Preview {
    LoginView()
}
