//
//  LoginView.swift
//  Vinhetas Brasileirao
//
//  Created by Bruno Thuma on 23/10/22.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var verifyPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoginScreen: Bool = true
    let verticalPaddingForForm = 40
    @Binding var isLoggedIn: Bool // here is the Binding
    
    var body: some View {
        VStack{
            Spacer()
            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.bottom, 10)
            TextField("email", text: $email)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 10)
                .textInputAutocapitalization(.never)
            SecureField("password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 10)
            if !isLoginScreen {
                SecureField("verify password", text: $verifyPassword)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 10)
            }
            Button(isLoginScreen ? "Login" : "Create Account"){
                if isLoginScreen {
                    loginUser()
                } else {
                    if password == verifyPassword {
                        print("Creating account")
                        createAccount()
                    } else {
                        errorMessage = "The passwords must match"
                    }
                }
            }
                .buttonStyle(.borderedProminent)
                .frame(width: 500)
                .fixedSize()
                .padding(.bottom, 10)
            
            Button("Proceed without login"){
                isLoggedIn = true
            }.padding(.bottom, 10)
            Button(isLoginScreen ? "Create an account" : "Already have an account") {
                isLoginScreen = !isLoginScreen
            }.padding(.bottom, 200)
            Text("Needs to be logged in order to fetch\nDownloaded files are still available")
                .multilineTextAlignment(.center)
        }.padding(.horizontal, 40)
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                errorMessage = error?.localizedDescription ?? ""
            } else {
                print("Welcome: \(authResult?.user.email ?? "")")
                isLoggedIn = true
            }
        }
    }
    
    func createAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                errorMessage = error?.localizedDescription ?? ""
            } else {
                print("New account for: \(authResult?.user.email ?? "")")
                isLoggedIn = true
            }
        }
    }
}
