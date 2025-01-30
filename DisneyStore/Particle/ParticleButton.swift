import SwiftUI

struct LikeButton: View {
    let onTap: () -> Void
    let status: Bool

    var body: some View {
        Button(action: onTap) {
            Image(systemName: status ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundColor(status ? .red : .black.opacity(0.5))
                .animation(.easeInOut, value: status)
                .particleEffect(
                    systemImage: "heart.fill",
                    font: .title3,
                    status: status,
                    activeTint: .red,
                    inActiveTint: .black.opacity(0.5)
                )
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
    }
}
