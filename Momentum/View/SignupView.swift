//
//  LoginView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 8/5/26.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear],
                               center: .top, startRadius: 0, endRadius: 350)
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 44))
                            .foregroundColor(.purple)
                        Text("Create Account")
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.white)
                        Text("Start your journey")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                    }

                    Spacer().frame(height: 8)

                    VStack(spacing: 14) {
                        customField(icon: "person", placeholder: "Username",
                                    text: $viewModel.fullname, secure: false)
                            .autocapitalization(.none)

                        customField(icon: "envelope", placeholder: "Email",
                                    text: $viewModel.email, secure: false)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        if !viewModel.email.isEmpty && !viewModel.isEmailValid {
                            Text("Please enter a valid email address.")
                                .foregroundColor(.orange)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }

                        customField(icon: "lock", placeholder: "Password",
                                    text: $viewModel.password, secure: true)

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView().tint(.purple)
                    } else {
                        VStack(spacing: 12) {
                            Button {
                                viewModel.signUp()
                            } label: {
                                Text("Sign Up")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(viewModel.canSubmit ? Color.purple : Color.purple.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                            }
                            .disabled(!viewModel.canSubmit)

                            Button {
                                dismiss()
                            } label: {
                                Text("Already have an account? **Log in**")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 28)
                .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
                    HomeView()
                }
            }
        }
    }

    private func customField(icon: String, placeholder: String,
                              text: Binding<String>, secure: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 20)
            if secure {
                SecureField(placeholder, text: text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: text)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.07))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    SignupView()
}

#Preview {
    SignupView()
}
