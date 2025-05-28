
import SwiftUI

struct FirstInfoScreen: View {
//    @State private var viewModel: FirstOnboardingViewModel = .init()
    @State private var path: NavigationPath = .init()
    @StateObject private var authMain = AuthMain()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                Spacer()
                
                Text("You want to get your nerves jangled?")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 32))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .background(.black.opacity(0.5))
                
                Button {
                    path.append(Router.root)
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
                Image(.firstInfoBackground)
                    .resizable()
                    .ignoresSafeArea()
            )
            .navigationDestination(for: Router.self) { router in
                switch router {
                case .main:
                    MainScreen(path: $path)
                        .navigationBarBackButtonHidden(true)
                case .secInfo:
                    SecondInfoScreen(path: $path)
                        .navigationBarBackButtonHidden(true)
                case .root:
                    RootScreen(viewModel: authMain, path: $path)
                        .navigationBarBackButtonHidden(true)
                case .info:
                    InfoScreen(path: $path)
                        .navigationBarBackButtonHidden(true)
                case .profile:
                    ProfileScreen(viewModel: .init(), authMain: authMain, path: $path)
                        .navigationBarBackButtonHidden(true)
                case .quize:
                    QuestScreen(path: $path)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    FirstInfoScreen()
}
