

import SwiftUI

struct ResultScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Text("You loose")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 64))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                
                Text("Joker ate you")
                    .frame(maxWidth: .infinity)
                    .font(.custom("Sancreek-Regular", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
//                    .padding(.vertical, 14)
                
                Button {
                    
                } label: {
                    Text("Restart")
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
                .padding(.horizontal, 60)
                
                Button {
                    
                } label: {
                    Text("Exit")
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
                .padding(.horizontal, 60)
            }
            .background(.black.opacity(0.5))
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
    ResultScreen()
}
