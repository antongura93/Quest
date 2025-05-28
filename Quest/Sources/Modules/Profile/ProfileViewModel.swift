

import Foundation
import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject {
    @Published var displayImage: UIImage?
    
    init() {
        loadProfileImage()
    }
    
    func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
           let savedImage = UIImage(data: imageData) {
            self.displayImage = savedImage
        }
    }
    
    @MainActor
    func saveProfileImageAsync(item: PhotosPickerItem) async {
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                Task { @MainActor in
                    self.displayImage = uiImage
                }
                objectWillChange.send()
                UserDefaults.standard.set(data, forKey: "userProfileImage")
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
    
    func deleteAcc() {
        UserDefaults.standard.set("", forKey: "userProfileImage")
    }
}
