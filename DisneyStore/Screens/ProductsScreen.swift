import SwiftUI

struct ProductsScreen: View {

    @Environment(CartService.self) var cartService
    @Environment(ProductsDataProvider.self) var productsDataProvider

    @Namespace var screenTransitionAnimation
    @State private var selectedProduct: ProductModel?

    private var isLoading: Bool {
        if case .loading = productsDataProvider.state {
            return true
        }
        return false
    }

    var body: some View {
        ScrollView {
            let items: [ProductModel] = {
                if case let .items(items) = productsDataProvider.state {
                    return items
                }
                return []
            }()

            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 150, maximum: 300))
            ], spacing: 20) {
                ForEach(items, id: \.id) { item in
                    let cartCount = cartService
                        .cartItems
                        .first(where: { $0.product.id == item.id })?
                        .count ?? 0
                    CardView(
                        showImage: selectedProduct?.id != item.id,
                        screenAnimationNamespace: screenTransitionAnimation,
                        product: item,
                        cartCount: cartCount,
                        onAction: { action in
                            Task {
                                do {
                                    switch action {
                                    case .increase:
                                        try await cartService.changeProductCount(
                                            item,
                                            cartCount + 1
                                        )
                                    case .decrease:
                                        try await cartService.changeProductCount(
                                            item,
                                            cartCount - 1
                                        )
                                    case .toCart:
                                        try await cartService.addProduct(item)
                                    }
                                } catch {

                                }
                            }
                        }
                    )
                    .zIndex(selectedProduct?.id == item.id ? 1 : 0)
                    .onTapGesture {
                        selectedProduct = item
                    }

//                    .transition(.offset(y: 50).combined(with: .opacity))
                }

            }
            .padding()
        }
        .opacity(isLoading ? 0 : 1)
        .offset(y: isLoading ? 50 : 0)
//        .animation(.easeInOut, value: isLoading)
        .overlay {
            Text("Loading...")
                .opacity(isLoading ? 1 : 0)
                .offset(y: isLoading ? 0 : -50)
//                .animation(.easeInOut, value: isLoading)
        }

        .navigationTitle("Products")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    productsDataProvider.loadItems()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .modifier(
            CustomModalViewModifier(
                value: $selectedProduct,
                destination: { value in
                    ProductDetailScreen(
                        animationNamespace: screenTransitionAnimation,
                        product: value,
                        cartCount: 5,
                        onAction: { _ in },
                        onClose: {
                            selectedProduct = nil
                        }
                    )
                }
            )
        )
    }

}

struct CartButtonsView: View {

    enum Action {
        case increase
        case decrease
        case toCart
    }
    let onAction: (Action) -> Void
    let count: Int

    var body: some View {
        HStack {
            if count > 0 {
                Button {
                    onAction(.decrease)
                } label: {
                    Image(systemName: "minus")
                        .imageScale(.medium)
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 12))
                .transition(.offset(x: -50).combined(with: .opacity))

                Text(count.description)
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                    .contentTransition(.numericText())
            }

            Button {
                if count > 0 {
                    onAction(.increase)
                } else {
                    onAction(.toCart)
                }
            } label: {
                    if count > 0 {
                        Image(systemName: "plus")
                            .imageScale(.medium)
                            .padding(.horizontal, 10)
                            .frame(height: 30)
                            .transition(.offset(x: -50).combined(with: .opacity))
                    } else {
                        Text("Add to Cart")
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .transition(.offset(x: 50).combined(with: .opacity))
                    }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 12))

        }
        .animation(.spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.5), value: count)
    }

}

struct CardView: View {

    @Namespace private var animationNamespace

    let showImage: Bool
    let screenAnimationNamespace: Namespace.ID
    let product: ProductModel
    let cartCount: Int
    let onAction: (CartButtonsView.Action) -> Void

    @State private var isFavorite = false

    var body: some View {
        VStack(spacing: 10) {

            Image(uiImage: UIImage(named: product.imageName)!)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .matchedGeometryEffect(
                    id: "card_image_\(product.id)",
                    in: screenAnimationNamespace
                )
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(0.1))
                        .blendMode(.darken)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(product.title)
                .font(.callout)
                .foregroundStyle(.black)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)

            Text(product.price.formatted(.currency(code: "GBP")))
                .font(.headline)
                .foregroundStyle(.black)

            CartButtonsView(onAction: onAction, count: cartCount)

//            HStack {
////                if cartCount > 0 {
////                    Button {
////                        onAction(.decrease)
////                    } label: {
////                        Image(systemName: "minus")
////                            .imageScale(.medium)
////                            .padding(.horizontal, 10)
////                            .frame(height: 30)
////                    }
////                    .buttonStyle(.borderedProminent)
////                    .buttonBorderShape(.roundedRectangle(radius: 12))
////                    .transition(.offset(x: -50).combined(with: .opacity))
////
////                    Text(cartCount.description)
////                        .frame(maxWidth: .infinity)
////                        .font(.title3)
////                        .contentTransition(.numericText(value: Double(cartCount)))
////                        .transition(.scale(scale: 0.5).combined(with: .opacity))
////
////                }
//
//                Button {
//                    if cartCount > 0 {
//                        onAction(.increase)
//                    } else {
//                        onAction(.toCart)
//                    }
//                } label: {
////                    if cartCount > 0 {
////                        Image(systemName: "plus")
////                            .imageScale(.medium)
////                            .padding(.horizontal, 10)
////                            .frame(height: 30)
////                            .transition(.offset(x: -50).combined(with: .opacity))
////                    } else {
//                        Text("Add to Cart")
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 30)
//                            .transition(.offset(x: 50).combined(with: .opacity))
////                    }
//                }
//                .buttonStyle(.borderedProminent)
//                .buttonBorderShape(.roundedRectangle(radius: 12))
//
//            }
        }
        .overlay {
            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .imageScale(.large)
//                    .contentTransition(.symbolEffect(.replace))
                    .foregroundStyle(isFavorite ? .red : .gray)
            }
//            .animation(.easeInOut, value: isFavorite)
            .buttonStyle(.plain)
            .frame(width: 44, height: 44)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
//        .animation(
//            .spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.5),
//            value: cartCount
//        )
    }

}

struct CustomModalViewModifier<Destination: View, Bindable: Identifiable & Equatable>: ViewModifier {

    @Environment(GlobalPresentationManager.self) var presentationManager

    @Binding var value: Bindable?
    let destination: (_ value: Bindable) -> Destination

    @State private var onClose: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onChange(of: value) {
                if let value {
                    presentationManager.present(
                        destination: destination(value)) { onClose in
                            self.onClose = onClose
                        }
                } else {
                    onClose?()
                }
            }
    }
}

struct ModalViewModifier<Destination: View, Bindable: Identifiable>: ViewModifier {
    @Binding var value: Bindable?

    let destination: (_ value: Bindable) -> Destination

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if let value {
                destination(value)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top
                    )
                    .background(Color.black).opacity(0.3)
                    .ignoresSafeArea()
                    .statusBarHidden(false)
            }
        }
    }
}

extension View {
    func modal<Destination: View, Bindable: Identifiable>(bindable: Binding<Bindable?>, @ViewBuilder destination: @escaping (_ value: Bindable) -> Destination) -> some View {
        self.modifier(ModalViewModifier(value: bindable, destination: destination))
    }
}

extension View {
   @ViewBuilder
    func `if`<ContentTrue: View, ContentFalse: View>(
        _ conditional: Bool,
        conditionalTrue: (Self) -> ContentTrue,
        conditionalFalse: (Self) -> ContentFalse
    ) -> some View {
        if conditional {
            conditionalTrue(self)
        } else {
            conditionalFalse(self)
        }
    }

    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
         if conditional {
             content(self)
         } else {
             self
         }
     }
}

private struct WrapperView: View {

    @Environment(ProductsDataProvider.self) var dataProvider
    @Environment(CartService.self) var cartService

    var body: some View {
        NavigationStack {
            ProductsScreen()
                .onAppear {
                    dataProvider.loadItems()
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
