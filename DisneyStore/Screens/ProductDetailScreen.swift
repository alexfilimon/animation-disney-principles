import SwiftUI

struct ProductDetailScreen: View {

    enum Action {
        case increase
        case decrease
        case toCart
    }

    let animationNamespace: Namespace.ID
    let product: ProductModel
    let cartCount: Int
    let onAction: (Action) -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 10) {

                Rectangle()
                    .fill(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .matchedGeometryEffect(
                        id: "card_image_\(product.id)",
                        in: animationNamespace
                    )
                    .frame(height: 400)

                Text(product.title)
                    .font(.title2)
//                    .matchedGeometryEffect(
//                        id: "card_title_\(product.id)",
//                        in: animationNamespace
//                    )
                Text(product.price.formatted(.currency(code: "GBP")))
                    .font(.headline)
                    .foregroundStyle(.green)
//                    .matchedGeometryEffect(
//                        id: "card_price_\(product.id)",
//                        in: animationNamespace
//                    )

                HStack {
    //                if cartCount > 0 {
    //                    Button {
    //                        onAction(.decrease)
    //                    } label: {
    //                        Image(systemName: "minus")
    //                            .imageScale(.medium)
    //                            .padding(.horizontal, 10)
    //                            .frame(height: 30)
    //                    }
    //                    .frame(height: 30)
    //                    .buttonStyle(.borderedProminent)
    //                    .buttonBorderShape(.roundedRectangle(radius: 12))
    //                    .transition(.offset(x: -50).combined(with: .opacity))
    //
    //                    Text(cartCount.description)
    //                        .frame(maxWidth: .infinity)
    //                        .font(.title3)
    //                        .contentTransition(.numericText(value: Double(cartCount)))
    //                        .transition(.scale(scale: 0.5).combined(with: .opacity))
    //                }

                    Button {
                        onClose()
                    } label: {
    //                    if cartCount > 0 {
                            Image(systemName: "xmark")
                                .imageScale(.medium)
                                .padding(.horizontal, 10)
                                .frame(height: 30)
    //                            .transition(.offset(x: -50).combined(with: .opacity))
    //                    } else {
    //                        Text("Add to Cart")
    //                            .frame(maxWidth: .infinity)
    //                            .frame(height: 30)
    //                            .transition(.offset(x: 50).combined(with: .opacity))
    //                    }
                    }
                    .frame(height: 30)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 12))

                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
//        .transition(.opacity)

//        .animation(
//            .spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.5),
//            value: cartCount
//        )
    }

}
