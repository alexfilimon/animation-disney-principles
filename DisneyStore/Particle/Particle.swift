import SwiftUI

struct Particle: Identifiable {
    var id: UUID = . init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1

    var opacity: CGFloat = 1

    mutating func reset() {
        self.randomX = 0
        self.randomY = 0
        self.scale = 1
        self.opacity = 1
    }

}
