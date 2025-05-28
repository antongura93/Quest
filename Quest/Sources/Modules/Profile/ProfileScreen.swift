

import SwiftUI
import PhotosUI

struct ProfileScreen: View {
    @StateObject private var viewModel: ProfileViewModel
    @ObservedObject var authMain: AuthMain
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @State private var showingImagePicker = false
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var isPresentAlert = false
    
    init(viewModel: ProfileViewModel, authMain: AuthMain, path: Binding<NavigationPath>) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.authMain = authMain
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 80, height: 80)
                
                Text("Profile")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 44))
                    .foregroundStyle(.white)
                    .shadow(color: Color(r: 58, g: 0, b: 0), radius: 4, x: 0, y: 0)
                    .padding(.trailing, 80)
            }
            
            HStack(spacing: 20) {
                if let image = viewModel.displayImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Image(.accIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }
                
                Text(authMain.currentuser?.name ?? "Anonimous")
                    .font(.custom("Sancreek-Regular", size: 32))
                    .foregroundStyle(.white)
                    .shadow(color: Color(r: 58, g: 0, b: 0), radius: 4, x: 0, y: 0)
                    .padding(.trailing, 80)
            }
            .padding(.top, 40)
            Spacer()
            Button {
                authMain.signOut()
                viewModel.deleteAcc()
                path.removeLast(path.count - 1)
            } label: {
                Text("Log out")
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
            .padding(.top, 20)
            
            Button {
                isPresentAlert = true
            } label: {
                Text("Delete acc")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 32))
                    .foregroundStyle(Color(r: 255, g: 208, b: 208))
                    .textCase(.uppercase)
                    .padding(.vertical, 18)
            }
            .alert("Are you sure?", isPresented: $isPresentAlert) {
                Button("Delete", role: .destructive) {
                    authMain.deleteUserAccount { result in
                        switch result {
                        case .success():
                            print("Account deleted successfully.")
                            viewModel.deleteAcc()
                            authMain.userSession = nil
                            authMain.currentuser = nil
                            path.removeLast(path.count - 1)
                        case .failure(let error):
                            print("ERROR DELELETING: \(error.localizedDescription)")
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("Are you sure you want to delete the account?")
            }
            .background(
                Image(.authButton)
                    .resizable()
                    .scaleEffect(1)
            )
            .padding(.top, 8)
            

        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        )
        .photosPicker(
            isPresented: $showingImagePicker,
            selection: $selectedImage,
            matching: .images,
            photoLibrary: .shared()
        )
        .task(id: selectedImage) {
            if let item = selectedImage {
                await viewModel.saveProfileImageAsync(item: item)
                selectedImage = nil
            }
        }
    }
}

#Preview {
    ProfileScreen(viewModel: .init(), authMain: .init(), path: .constant(.init()))
}
