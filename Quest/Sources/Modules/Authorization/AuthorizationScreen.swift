

import SwiftUI

extension AuthorizationScreen: AuthorizationProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
    }
}

struct AuthorizationScreen: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @ObservedObject var viewModel: AuthMain
    @State private var isAuth = true
    
    enum AlertType {
        case error(String)
        case validation
        case none
    }
    
    @State private var alertType: AlertType = .none
    @State private var showAlert = false
    
    @Namespace private var animation
    
    @Binding var path: NavigationPath
    
    init(viewModel: AuthMain, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(isAuth ? "Log in" : "Registration")
                .frame(maxWidth: .infinity)
                .font(.custom("Sancreek-Regular", size: 44))
                .foregroundStyle(.white)
                .shadow(color: Color(r: 58, g: 0, b: 0), radius: 4, x: 0, y: 0)
                .id(isAuth ? "login_title" : "registration_title")
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut, value: isAuth)
            
            if !isAuth {
                TextField("", text: $name, prompt:
                            Text("Name")
                                .foregroundColor(Color(r: 196, g: 158, b: 100))
                                .font(.system(size: 24, weight: .regular, design: .default))
                )
                .font(.system(size: 24, weight: .regular, design: .default))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(16)
                .foregroundColor(Color(r: 196, g: 158, b: 100))
                .background(Color(r: 255, g: 247, b: 234))
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(r: 123, g: 73, b: 0), lineWidth: 2)
                )
                .padding(.top, 20)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
            
            TextField("", text: $email, prompt:
                        Text("Email")
                            .foregroundColor(Color(r: 196, g: 158, b: 100))
                            .font(.system(size: 24, weight: .regular, design: .default))
            )
            .font(.system(size: 24, weight: .regular, design: .default))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(16)
            .foregroundColor(Color(r: 196, g: 158, b: 100))
            .background(Color(r: 255, g: 247, b: 234))
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color(r: 123, g: 73, b: 0), lineWidth: 2)
            )
            .padding(.top, isAuth ? 20 : 8)
            .matchedGeometryEffect(id: "emailField", in: animation)

            SecureField("", text: $password, prompt:
                            Text("Password")
                            .foregroundColor(Color(r: 196, g: 158, b: 100))
                            .font(.system(size: 24, weight: .regular, design: .default))
            )
            .font(.system(size: 24, weight: .regular, design: .default))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(16)
            .foregroundColor(Color(r: 196, g: 158, b: 100))
            .background(Color(r: 255, g: 247, b: 234))
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color(r: 123, g: 73, b: 0), lineWidth: 2)
            )
            .padding(.top, 8)
            .matchedGeometryEffect(id: "passwordField", in: animation)
            
            if !isAuth {
                SecureField("", text: $confirmPassword, prompt:
                                Text("Confirm password")
                            .foregroundColor(Color(r: 196, g: 158, b: 100))
                            .font(.system(size: 24, weight: .regular, design: .default))
            )
            .font(.system(size: 24, weight: .regular, design: .default))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(16)
            .foregroundColor(Color(r: 196, g: 158, b: 100))
            .background(Color(r: 255, g: 247, b: 234))
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color(r: 123, g: 73, b: 0), lineWidth: 2)
            )
            .padding(.top, 8)
            .transition(.opacity.combined(with: .move(edge: .leading)))
            }
            
            Button {
                if isAuth {
                    Task {
                        do {
                            try await viewModel.signIn(email: email, password: password)
                            if !viewModel.text.isEmpty {
                                alertType = .error(viewModel.text)
                                showAlert = true
                            }
                        } catch {
                            alertType = .error(viewModel.text)
                            showAlert = true
                        }
                    }
                } else {
                    if isFormValid {
                        Task {
                            do {
                                try await viewModel.createUser(withEmail: email, password: password, name: name)
                                if !viewModel.text.isEmpty {
                                    alertType = .error(viewModel.text)
                                    showAlert = true
                                }
                            } catch {
                                alertType = .error(viewModel.text)
                                showAlert = true
                            }
                        }
                    } else {
                        alertType = .validation
                        showAlert = true
                    }
                }
            } label: {
                Text(isAuth ? "Log in" : "Create")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 32))
                    .foregroundStyle(Color(r: 48, g: 28, b: 0))
                    .textCase(.uppercase)
                    .padding(.vertical, 18)
            }
            .background(
                Image(.mainButton)
                    .resizable()
                    .scaleEffect(1)
            )
            .padding(.top, 34)
            .transition(.scale.combined(with: .opacity))
            .id(isAuth ? "loginButton" : "registerButton")
            
            Spacer()
            
            VStack(spacing: 0) {
                
                Text("Or try this way")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 32))
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isAuth.toggle()
                    }
                } label: {
                    Text(isAuth ? "Registration" : "Log in")
                        .frame(maxWidth: .infinity)
                        .font(.custom("Sancreek-Regular", size: 32))
                        .foregroundStyle(Color(r: 255, g: 208, b: 208))
                        .textCase(.uppercase)
                        .padding(.vertical, 18)
                }
                .background(
                    Image(.authButton)
                        .resizable()
                        .scaleEffect(1)
                )
                .padding(.top, 12)
                .transition(.scale.combined(with: .opacity))
                .id(isAuth ? "createAccountButton" : "loginButton")
                
                Button {
                    Task {
                        await viewModel.signInAnonymously()
                    }
                } label: {
                    Text("Anonimous")
                        .frame(maxWidth: .infinity)
                        .font(.custom("Sancreek-Regular", size: 32))
                        .foregroundStyle(Color(r: 255, g: 208, b: 208))
                        .textCase(.uppercase)
                        .padding(.vertical, 18)
                }
                .background(
                    Image(.authButton)
                        .resizable()
                        .scaleEffect(1)
                )
                .padding(.top, 10)
            }
            .background(
                Color(r: 0, g: 0, b: 0, opacity: 0.5)
                    .padding(.horizontal, -20)
                    .ignoresSafeArea(.all, edges: .bottom)
            )
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(isAuth ? .mainBackground : .regBackground)
                .resizable()
                .ignoresSafeArea()
        )
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .error(let message):
                return Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .cancel()
                )
            case .validation:
                return Alert(
                    title: Text("Error"),
                    message: Text("Please ensure your email address is valid and not empty, your password is at least 6 characters long, and your confirmation password matches your password."),
                    dismissButton: .cancel()
                )
            case .none:
                return Alert(
                    title: Text("Error"),
                    message: Text("An unknown error occurred"),
                    dismissButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    AuthorizationScreen(viewModel: .init(), path: .constant(.init()))
}
