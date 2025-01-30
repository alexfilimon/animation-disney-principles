import SwiftUI

//struct LaunchScreen<Content: View>: View {
//    ...
//    @Namespace var namespace
//
//    var body: some View {
//        ZStack { ... }
//        .mask {
//            ZStack {
//                if isFinished {
//                    Circle()
//                        .fill(Color.blue)
//                        .matchedGeometryEffect(
//                            id: "2-circle",
//                            in: namespace
//                        )
//                        .frame(width: 1000, height: 1000)
//                } else {
//                    HStack(spacing: 40) {
//                        ForEach(0..<5) { index in
//                            Circle()
//                                .matchedGeometryEffect(
//                                    id: "\(index)-circle",
//                                    in: namespace
//                                )
//                            ...
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear { ... }
//        .animation(.easeInOut, value: isFinished)
//    }
//}

struct LaunchScreen<Content: View>: View {
    @State private var isAnimating = false

    private let contentView: () -> Content
    @Binding var isFinished: Bool
    @Namespace var namespace

    init(
        @ViewBuilder contentView: @escaping () -> Content,
        onFinished: Binding<Bool>
    ) {
        self.contentView = contentView
        self._isFinished = onFinished
    }

    var body: some View {
        ZStack {
            contentView()
                .ignoresSafeArea()
            Rectangle()
                .fill(.blue)
                .opacity(isFinished ? 0 : 1)
                .ignoresSafeArea()
        }
        .mask {
            ZStack {
                if isFinished {
                    Circle()
                        .fill(Color.blue)
                        .matchedGeometryEffect(id: "2-circle", in: namespace)
                        .frame(width: 1000, height: 1000)
                        .zIndex(100)
                } else {
                    maskView()
                        .zIndex(10)
                }
            }

        }
        .animation(.easeInOut(duration: 0.8), value: isFinished)
        .onChange(of: isFinished) { oldValue, newValue in
            isAnimating.toggle()
        }
    }

    @ViewBuilder func maskView() -> some View {
        HStack(spacing: 40) {
            ForEach(0..<5) { index in
                let centerScaleFactor: CGFloat = 1
                let otherOpacity: CGFloat = 1
                Circle()
                    .fill(Color.green)
                    .matchedGeometryEffect(id: "\(index)-circle", in: namespace)
                    .frame(width: 30, height: 30)
                    .opacity(otherOpacity)
                    .scaleEffect(centerScaleFactor, anchor: .center)
                    .offset(y: isAnimating ? 0 : 70)

                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
                    .zIndex(1)
            }
        }
        .offset(y: -70)
        .onAppear {
            isAnimating = true
        }
    }
}

struct CustomPreviewView: View {

    @State private var isFinished = false

    var body: some View {
        LaunchScreen(contentView: {
            Text("Добро пожаловать!")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)
        }, onFinished: $isFinished)
//        .contentShape(Rectangle())
//        .border(.green)
        .onAppear {
            print("appear")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                isFinished.toggle()
//            }
        }
        .onTapGesture {
            print("toggle")
            isFinished.toggle()
        }
    }

}

struct LaunchScreen_Previews: PreviewProvider {



    static var previews: some View {
        CustomPreviewView()
    }
}
