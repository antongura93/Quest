
import SwiftUI

struct SecondInfoScreen: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Then let's begin...")
                .frame(maxWidth: .infinity)
                .font(.custom("Sancreek-Regular", size: 44))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .background(.black.opacity(0.5))
            
            Button {
                path.append(Router.main)
            } label: {
                Text("Start")
                    .font(.custom("Sancreek-Regular", size: 32))
                    .foregroundStyle(Color(r: 48, g: 28, b: 0))
                    .textCase(.uppercase)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 95)
            }
            .background(
                Image(.mainButton)
                    .resizable()
                    .scaledToFit()
            )
            .padding(.vertical, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.secondInfoBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SecondInfoScreen(path: .constant(.init()))
}
