
import SwiftUI

struct QuestScreen: View {
    @StateObject private var viewModel = QuestViewModel()
    @State private var isPaused: Bool = false
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        isPaused = true
                        viewModel.pauseTimer()
                    } label: {
                        Image(.stopButton)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    Text(viewModel.formattedTime)
                        .font(.custom("Sancreek-Regular", size: 44))
                        .foregroundStyle(.white)
                        .shadow(color: Color(r: 58, g: 0, b: 0), radius: 4, x: 0, y: 0)
                }
                
                Text(viewModel.currentRiddle.question)
                    .padding(.vertical, 28)
                    .padding(.horizontal, 12)
                    .foregroundStyle(.white)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .background(.black.opacity(0.5))
                    .padding(.horizontal, -30)
                    .padding(.top, 40)
                
                Spacer()
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 13),
                    GridItem(.flexible(), spacing: 13)
                ], spacing: 63) {
                    ForEach(viewModel.currentRiddle.options.indices, id: \.self) { index in
                        Button(action: {
                            viewModel.submitAnswer(index)
                        }) {
                            Text(viewModel.currentRiddle.options[index])
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(r: 48, g: 28, b: 0))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .background(
                            Image(.questButton)
                                .resizable()
                                .frame(height: 120)
                        )
                        .disabled(viewModel.showResult)
                    }
                }
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
            )

            if isPaused {
                VStack {
                    Button {
                        isPaused = false
                        viewModel.resumeTimer()
                    } label: {
                        Text("Resume")
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
                    Button {
                        viewModel.restart()
                        isPaused = false
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
                    Button {
                        viewModel.stopTimer()
                        dismiss()
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
                }
                .padding(.vertical, 100)
                .padding(.horizontal, 40)
                .background(
                    Image(.stopBack)
                        .resizable()
                        .scaleEffect(1)
                )
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.5))
            }
            if viewModel.isGameOver {
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack {
                        Text("You loose")
                            .frame(maxWidth: .infinity)
                            .font(.custom("Sancreek-Regular", size: 64))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .padding(.top, 14)
                        
                        Text("Joker ate you")
                            .frame(maxWidth: .infinity)
                            .font(.custom("Sancreek-Regular", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                        
                        Text("Time: \(viewModel.formattedTime)")
                            .frame(maxWidth: .infinity)
                            .font(.custom("Sancreek-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .padding(.bottom, 10)
                        
                        Button {
                            viewModel.restart()
                        } label: {
                            Text("Restart")
                                .frame(maxWidth: .infinity)
                                .font(.custom("Sancreek-Regular", size: 32))
                                .foregroundStyle(Color(r: 255, g: 208, b: 208))
                                .textCase(.uppercase)
                                .padding(.vertical, 13)
                        }
                        .background(
                            Image(.authButton)
                                .resizable()
                                .scaleEffect(1)
                        )
                        .padding(.horizontal, 60)
                        
                        Button {
                            viewModel.stopTimer()
                            dismiss()
                        } label: {
                            Text("Exit")
                                .frame(maxWidth: .infinity)
                                .font(.custom("Sancreek-Regular", size: 32))
                                .foregroundStyle(Color(r: 255, g: 208, b: 208))
                                .textCase(.uppercase)
                                .padding(.vertical, 13)
                        }
                        .background(
                            Image(.authButton)
                                .resizable()
                                .scaleEffect(1)
                        )
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
            if viewModel.isWin {
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack {
                        Text("You win")
                            .frame(maxWidth: .infinity)
                            .font(.custom("Sancreek-Regular", size: 64))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .padding(.top, 14)
                        
                        Text("You escaped from the circus")
                            .frame(maxWidth: .infinity)
                            .font(.custom("Sancreek-Regular", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                        
                        Text("Time: \(viewModel.formattedTime)")
                            .frame(maxWidth: .infinity)
                            .font(.custom("Sancreek-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .padding(.bottom, 10)
                        
                        Button {
                            viewModel.restart()
                        } label: {
                            Text("Restart")
                                .frame(maxWidth: .infinity)
                                .font(.custom("Sancreek-Regular", size: 32))
                                .foregroundStyle(Color(r: 255, g: 208, b: 208))
                                .textCase(.uppercase)
                                .padding(.vertical, 13)
                        }
                        .background(
                            Image(.authButton)
                                .resizable()
                                .scaleEffect(1)
                        )
                        .padding(.horizontal, 60)
                        
                        Button {
                            viewModel.stopTimer()
                            dismiss()
                        } label: {
                            Text("Exit")
                                .frame(maxWidth: .infinity)
                                .font(.custom("Sancreek-Regular", size: 32))
                                .foregroundStyle(Color(r: 255, g: 208, b: 208))
                                .textCase(.uppercase)
                                .padding(.vertical, 13)
                        }
                        .background(
                            Image(.authButton)
                                .resizable()
                                .scaleEffect(1)
                        )
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
    }
}

#Preview {
    QuestScreen(path: .constant(.init()))
}
