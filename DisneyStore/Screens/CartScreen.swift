import SwiftUI

struct CartScreen: View {

    @Environment(CartService.self) var cartService
    @Environment(ProductsDataProvider.self) var productsDataProvider

    @State var isProcessing = false
    @State var isError = false
    @State var isErrorAnimating = false
    @State var isCompleted = false

//    @State var nonAnimatedIsCompleted: Bool = false

    var body: some View {
        ScrollView {
            content()
        }
        .overlay {
            if cartService.cartItems.isEmpty {
                ContentUnavailableView(
                    "Cart is empty",
                    systemImage: "trash",
                    description: Text("Add some products to the cart")
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            ZStack {


                if !cartService.cartItems.isEmpty {
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .offset(y: 10)
                    .frame(height: 70)

                    bottomButton()
                }
            }
        }
        .navigationTitle("Cart")
//        .animation(
//            .spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.5),
//            value: cartService.cartItems.count
//        )
    }

    @ViewBuilder func content() -> some View {
        LazyVStack {
            ForEach(cartService.cartItems, id: \.product.id) { cartItem in
                let cartCount = cartService
                    .cartItems
                    .first(where: { $0.product.id == cartItem.product.id })?
                    .count ?? 0
                CartCardView(
                    product: cartItem.product,
                    cartCount: cartCount,
                    onAction: { action in
                        Task {
                            do {
                                switch action {
                                case .increase:
                                    try await cartService.changeProductCount(
                                        cartItem.product,
                                        cartCount + 1
                                    )
                                case .decrease:
                                    try await cartService.changeProductCount(
                                        cartItem.product,
                                        cartCount - 1
                                    )
                                case .toCart:
                                    try await cartService.addProduct(                                            cartItem.product)
                                }
                            } catch {

                            }
                        }
                    }
                )
                .sensoryFeedback(trigger: cartCount) { oldValue, newValue in
                    if newValue > oldValue {
                        return .increase
                    }
                    if newValue < oldValue {
                        return .decrease
                    }
                    return .none
                }
//                .transition(.slide)
            }
        }
    }

    @ViewBuilder func bottomButton() -> some View {
        CartButton(
            state: {
                if isCompleted {
                    return .success
                }
                if isError {
                    return .error
                }
                if isProcessing {
                    return .loading
                }
                return .normal
            }(),
            sum: cartService.wholeSum
        ) {
            Task { @MainActor in
                isProcessing = true

                try? await Task.sleep(for: .seconds(5))
                isError = true

                try? await Task.sleep(for: .seconds(5))
                isCompleted = true

                try? await Task.sleep(for: .seconds(5))
                isError = false
                isProcessing = false
                isCompleted = false

//                Task {
//                    try? await cartService.removeAll()
//                }
//                isProcessing = false
            }
        }
    }

//    var combinedState: AnyHashable {
//        return "\(isProcessing)-\(isError)-\(cartService.wholeSum)-\(isCompleted)"
//    }

}

struct CartButton: View {
    enum AppearanceState: String {
        case normal
        case loading
        case error
        case success
    }
    let state: AppearanceState

    let sum: Double
    let onTap: () -> Void

    @State var isErrorAnimating = false

    var body: some View {
        Button(action: onTap) {
            ZStack {
                switch state {
                case .normal:
                    let priceStr: String = sum.formatted(.currency(code: "GBP"))
                    HStack {
                        Text("Checkout")
                            .font(.headline)
                            .transition(.offset(x: -50).combined(with: .opacity))
                        Spacer()
                        Text(priceStr)
                            .transition(.offset(x: 50).combined(with: .opacity))
                            .contentTransition(.numericText(value: sum))
                    }
                case .loading:
                    ActivityIndicator()
                        .frame(width: 34, height: 34)
                        .frame(width: 12, height: 20, alignment: .center)
                        .foregroundColor(.white)
                        .transition(.opacity)
                case .error:
                    Image(systemName: "exclamationmark")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .frame(width: 12, height: 20, alignment: .center)
                        .transition(.asymmetric(insertion: .opacity, removal: .scale))
                case .success:
                    Image(systemName: "checkmark")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .frame(width: 12, height: 20, alignment: .center)
                        .transition(.asymmetric(insertion: .opacity, removal: .scale))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .background {
            Rectangle()
                .fill(.tint)
                .clipShape(RoundedRectangle(cornerRadius: state == .normal ? 12 : 30))
        }
        .foregroundStyle(.white)
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .tint({
            switch state {
            case .normal, .loading:
                return .accentColor
            case .error:
                return .red
            case .success:
                return .green
            }
        }())
        .onChange(of: state) { oldValue, newValue in
            if newValue == .error {
                isErrorAnimating = true
            }
        }
        .onChange(of: isErrorAnimating, { oldValue, newValue in
            if newValue {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                    isErrorAnimating = false
                }
            }
        })
        .offset(x: isErrorAnimating ? 30 : 0)
        .animation(
            .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8),
            value: "\(state.rawValue)-\(sum)"
        )
        .sensoryFeedback(trigger: state) { old, new in
            switch new {
            case .normal:
                return .none
            case .loading:
                return .impact(weight: .medium)
            case .error:
                return .error
            case .success:
                return .success
            }
        }
    }
}
//        Button {
//
////            Task { @MainActor in
////                try? await Task.sleep(for: .seconds(2))
////                Task {
////                    try? await cartService.removeAll()
////                }
////                nonAnimatedIsCompleted = true
////            }
//
////            isProcessing.toggle()
////
////            if [false, true].randomElement()! {
////                Task { @MainActor in
////                    try? await Task.sleep(for: .seconds(1))
////                    isError = true
////                    isErrorAnimating = true
////                    try? await Task.sleep(for: .seconds(1))
////                    isError = false
////                    isProcessing = false
////                }
////            } else {
////                Task { @MainActor in
////                    try? await Task.sleep(for: .seconds(1))
////                    isCompleted = true
////                    try? await Task.sleep(for: .seconds(1))
////                    isCompleted = false
////                    isProcessing = false
////                }
////            }
//
//
//        } label: {
//
//            ZStack {
//                if isError {
//                    Image(systemName: "exclamationmark")
//                        .imageScale(.large)
//                        .fontWeight(.bold)
//                        .frame(width: 12, height: 20, alignment: .center)
//                        .transition(.asymmetric(insertion: .opacity, removal: .scale))
//
//                } else if isCompleted {
//                    Image(systemName: "checkmark")
//                        .imageScale(.large)
//                        .fontWeight(.bold)
//                        .frame(width: 12, height: 20, alignment: .center)
//                        .transition(.asymmetric(insertion: .opacity, removal: .scale))
//                } else if isProcessing {
//                    ActivityIndicator()
//                        .frame(width: 34, height: 34)
//                        .frame(width: 12, height: 20, alignment: .center)
//                        .foregroundColor(.white)
//                        .transition(.opacity)
//                } else {
//                    let priceStr: String = cartService.wholeSum.formatted(.currency(code: "GBP"))
//                    HStack {
//                        Text("Checkout")
//                            .font(.headline)
//                            .transition(.offset(x: -50).combined(with: .opacity))
//                        Spacer()
//                        Text(priceStr)
//                            .transition(.offset(x: 50).combined(with: .opacity))
////                            .contentTransition(.numericText(value: cartService.wholeSum))
//                    }
//                    .contentShape(Rectangle())
//
//                }
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 16)
//            .contentShape(Rectangle())
//        }
//        .background {
//            Rectangle()
//                .fill(.tint)
//                .clipShape(RoundedRectangle(cornerRadius: (isProcessing || isError || isCompleted) ? 30 : 12))
//        }
//        .foregroundStyle(.white)
//        .onChange(of: isErrorAnimating, { oldValue, newValue in
//            if newValue {
//                withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
//                    isErrorAnimating = false
//                }
//            }
//        })
//        .buttonStyle(.plain)
//        .padding(.horizontal, 16)
//        .padding(.bottom, 16)
//        .tint({
//            if isError {
//                return .red
//            }
//            if isCompleted {
//                return .green
//            }
//            return .accentColor
//        }())
//        .offset(x: isErrorAnimating ? 30 : 0)
//        .sensoryFeedback(trigger: isError) { oldValue, newValue in
//            if newValue {
//                return .error
//            }
//            return .none
//        }
//        .sensoryFeedback(trigger: isProcessing) { oldValue, newValue in
//            if newValue {
//                return .impact(weight: .medium)
//            }
//            return .none
//        }
//        .sensoryFeedback(trigger: isCompleted) { oldValue, newValue in
//            if newValue {
//                return .success
//            }
//            return .none
//        }
//        .animation(
//            .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8),
//            value: combinedState
//        )
//    }
//
//}

struct ActivityIndicator: View {

    @State private var isAnimating: Bool = false

    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(calcScale(index: index))
                        .offset(y: calcYOffset(geometry))
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                                .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                                .repeatForever(autoreverses: false))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
        }
    }

    func calcScale(index: Int) -> CGFloat {
        return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
    }

    func calcYOffset(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / 10 - geometry.size.height / 2
    }

}

struct CartCardView: View {

    enum Action {
        case increase
        case decrease
        case toCart
    }

    let product: ProductModel
    let cartCount: Int
    let onAction: (CartButtonsView.Action) -> Void

    @State private var isFavorite = false

    var body: some View {
        HStack(spacing: 10) {

            Image(uiImage: UIImage(named: product.imageName)!)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(0.1))
                        .blendMode(.darken)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .containerRelativeFrame(.horizontal, count: 3, span: 1, spacing: 0, alignment: .center)

            VStack(spacing: 10) {

                Text(product.title)
                    .font(.callout)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(product.price.formatted(.currency(code: "GBP")))
                    .font(.headline)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                CartButtonsView(onAction: onAction, count: cartCount)

            }

        }

        .padding(.horizontal, 16)
        .overlay {
//            Button {
//                isFavorite.toggle()
//            } label: {
//                Image(systemName: isFavorite ? "heart.fill" : "heart")
//                    .imageScale(.large)
//                    .contentTransition(.symbolEffect(.replace))
//                    .foregroundStyle(isFavorite ? .red : .gray)
//            }
//            .animation(.easeInOut, value: isFavorite)
//            .buttonStyle(.plain)
            LikeButton(
                onTap: {
                    isFavorite.toggle()
                },
                status: isFavorite
            )
            .frame(width: 76, height: 44)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .sensoryFeedback(trigger: isFavorite) { oldValue, newValue in
            if newValue {
                return .success
            }
            return .impact(weight: .medium)
        }

//        .animation(
//            .spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.5),
//            value: cartCount
//        )
    }

}

private struct WrapperView: View {

    @Environment(ProductsDataProvider.self) var dataProvider
    @Environment(CartService.self) var cartService

    var body: some View {
        NavigationStack {
            CartScreen()
                .onAppear {
                    dataProvider.loadItems()
                }
                .onChange(of: dataProvider.state) { oldValue, newValue in
                    switch newValue {
                    case .items(let items):
                        items.enumerated().forEach { payload in
                            let (index, item) = payload
                            Task {
//                                try? await Task.sleep(for: .seconds(index))
                                try? await cartService.addProduct(item)
                            }
                        }
                    case .loading:
                        ()
                    }
                }
        }
    }

}

#Preview {
    WrapperView()
        .environment(CartService())
        .environment(ProductsDataProvider())
        .environment(GlobalPresentationManager())
}
