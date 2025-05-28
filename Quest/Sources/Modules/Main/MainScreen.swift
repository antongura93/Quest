
import SwiftUI

struct MainScreen: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Button {
                path.append(Router.quize)
            } label: {
                Text("Play")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 84))
                    .foregroundStyle(Color(r: 48, g: 28, b: 0))
                    .textCase(.uppercase)
                    .padding(.top, 135)
                    .padding(.bottom, 108)
            }
            .background(
                Image(.mainGameButton)
                    .resizable()
                    .scaleEffect(1)
            )
            
            Button {
                path.append(Router.info)
            } label: {
                Text("Info")
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
                path.append(Router.profile)
            } label: {
                Text("Profile")
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
            .padding(.top, 8)

        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    MainScreen(path: .constant(.init()))
}
