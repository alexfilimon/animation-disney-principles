import SwiftUI

//struct KeynoteExampleScreen: View {
//
//    @State private var isSquare = true
//
//    var body: some View {
//        VStack {
//            Spacer()
//
////            if isAppeared {
////
////            }
//
//            Rectangle()
//                .fill(.orange)
//                .clipShape(RoundedRectangle(cornerRadius: isSquare ? 30 : 50))
//                .frame(
//                    width: isSquare ? 140 : 100,
//                    height: isSquare ? 140 : 100
//                )
//                .onTapGesture {
//                    isSquare.toggle()
//                }
//                .transition(.move(edge: .trailing).combined(with: .opacity))
//                .padding(30)
//
//            Button("Toggle") {
//                isSquare.toggle()
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
////        .animation(
////            .spring(
////                response: 0.5,
////                dampingFraction: 0.65,
////                blendDuration: 0.5
////            ),
////            value: isSquare
////        )
//    }
//
//}

struct KeynoteExampleScreen: View {
    @State private var isSquare = true

    var body: some View {
        VStack {
            Spacer()
//            if isSquare {
                Rectangle()
                    .fill(.orange)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: isSquare ? 30 : 50
                        )
                    )
                    .frame(
                        width: isSquare ? 140 : 100,
                        height: isSquare ? 140 : 100
                    )
//                    .transition(.slide.combined(with: .opacity))
                    .padding(30)
                    .disabled(isSquare)
//                    .id("rectangle")
//            }
            Rectangle()
                .fill(.green)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: isSquare ? 30 : 50
                    )
                )
                .frame(
                    width: isSquare ? 140 : 100,
                    height: isSquare ? 140 : 100
                )
//                    .transition(.slide.combined(with: .opacity))
                .padding(30)
                .opacity(isSquare ? 1 : 0)
//                .id("rectangle")
            Button("Toggle") {
                withAnimation(.spring(
                    response: 0.5,
                    dampingFraction: 0.65,
                    blendDuration: 0.5
                )) {
                    isSquare.toggle()
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
//        .animation(
//            .spring(
//                response: 0.5,
//                dampingFraction: 0.65,
//                blendDuration: 0.5
//            ),
//            value: isVisible
//        )
    }
}

//struct KeynoteExampleScreen: View {
//    var body: some View {
//        NavigationStack {
//            List(1..<100) { row in
//                Text("Row \(row)")
//            }
//            .refreshable {
//                try? await Task.sleep(for: .seconds(1))
//                print("Do your refresh work here")
//            }
//        }
//    }
//}

#Preview {

    KeynoteExampleScreen()

}
