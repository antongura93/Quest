
import SwiftUI

struct InfoScreen: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(path: Binding<NavigationPath>) {
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
                
                Text("Info")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 44))
                    .foregroundStyle(.white)
                    .shadow(color: Color(r: 58, g: 0, b: 0), radius: 4, x: 0, y: 0)
                    .padding(.trailing, 80)
            }
            .padding(.horizontal, 20)
            
            
            ScrollView(showsIndicators: false) {
                Text("""
🎪 Welcome to the Circus of Nightmares! 🤡

This isn't just a game — it's an interactive horror-themed quest, where your instincts and senses will be put to the test.

You’ll face 10 clown-themed blocks, each containing 10 eerie challenges. Every level presents you with 4 choices, but only one is correct. The others? They lead to failure... or something worse.

🧩 Use hints, pay attention, listen closely, feel the tension. The right answer isn’t always logical — sometimes it’s hidden in sounds, colors, or that strange feeling in your gut.

🎭 A twisted circus, dark humor, and unsettling surprises await. But remember: one wrong move, and it’s game over.

Are you ready to play?

The show is about to begin.
""")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 11)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .background(.black.opacity(0.5))
            }
            .padding(.top, 40)
            

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    InfoScreen(path: .constant(.init()))
}
