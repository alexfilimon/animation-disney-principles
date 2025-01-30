import SwiftUI

extension View {

    @ViewBuilder
    func particleEffect(
        systemImage: String,
        font: Font,
        status: Bool,
        activeTint: Color,
        inActiveTint: Color
    ) -> some View {
        self.modifier(ParticleEffectModifier(
            systemImage: systemImage,
            font: font,
            status: status,
            activeTint: activeTint,
            inActiveTint: inActiveTint
        ))
    }

}

private struct ParticleEffectModifier: ViewModifier {

    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color

    @State private var particles: [Particle] = []

    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            ZStack {
                ForEach(particles, id: \.id) { particle in
                    Image(systemName: systemImage)
                        .foregroundColor(status ? activeTint : inActiveTint)
                        .scaleEffect(particle.scale)
                        .offset(x: particle.randomX, y: particle.randomY)
                        .opacity(particle.opacity)

                        .opacity(status ? 1 : 0)
                        .animation(.none, value: status)
                }
            }
            .onAppear {
                if particles.isEmpty {
                    particles = (0..<10).map { _ in
                        Particle()
                    }
                }
            }
            .onChange(of: status) {
                if !status {
//                    print("reset")
                    for index in particles.indices {
                        particles[index].reset()
                    }
                } else {
                    for index in particles.indices {
                        let total = CGFloat(particles.count)
                        let progress = CGFloat(index) / total
                        let maxX: CGFloat = progress > 0.5 ? 100 : -100
                        let maxY: CGFloat = 60

                        let randomX: CGFloat = (progress > 0.5 ? progress - 0.5 : progress) * maxX
                        let randomY: CGFloat = (progress > 0.5 ? progress - 0.5 : progress) * maxY + 35

                        let randomScale = CGFloat.random(in: 0.35...1)

                        particles[index].opacity = 0

                        withAnimation(.easeInOut(duration: 0.2).delay(0.3)) {
                            particles[index].opacity = 1
                        }

                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.3)) {

                            let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                            let extraRandomY: CGFloat = .random(in: 0...30)

                            particles[index].randomX = randomX + extraRandomX
                            particles[index].randomY = -randomY - extraRandomY
                        }

                        withAnimation(.easeInOut(duration: 0.3)) {
                            particles[index].scale = randomScale
                        }

                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.75 + Double(index) * 0.005)) {
                            particles[index].scale = 0.001
                        }
                    }
                }
            }
        }
    }

}

//private struct ParticleButtonWrapper: View {
//
//    @State private var status: Bool = false
//
//    var body: some View {
//        ParticleButton(onTap: {
//            status.toggle()
//        }, systemName: "heart.fill", status: status)
//    }
//
//}
//
//#Preview {
//    ParticleButtonWrapper()
//}
