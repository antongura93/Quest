
import SwiftUI

struct OnboardingScreen: View {
    @State private var isLoad: Bool = false
    @State private var dotCount = 0
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if isLoad {
            FirstInfoScreen()
        } else {
            VStack(spacing: 0) {
                Spacer()
                Image(.onb)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 58)
                Text("Loading\(String(repeating: ".", count: dotCount))")
                    .foregroundStyle(.white)
                    .font(.custom("Sancreek-Regular", size: 64))
                    .padding(.top, 23)
                    .onReceive(timer) { _ in
                        dotCount = (dotCount % 3) + 1
                    }
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoad = true
                }
            }
        }
    }
}

#Preview {
    OnboardingScreen()
}
