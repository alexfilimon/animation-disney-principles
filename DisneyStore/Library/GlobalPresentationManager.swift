import SwiftUI

@MainActor
@Observable
class GlobalPresentationManager {

    var currentPresentable: AnyView?

    func present<Content: View>(destination: Content, onClose: (@escaping () -> Void) -> Void) {
        currentPresentable = AnyView(
            destination
        )
        onClose {
            self.currentPresentable = nil
        }
    }

}
