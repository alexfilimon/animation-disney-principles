import Observation

@MainActor
@Observable
class CartService {

    // MARK: - Properties

    private(set) var cartItems: [CartItemModel] = []

    var wholeSum: Double {
        return cartItems.reduce(0) { partialResult, cartModel in
            return partialResult + cartModel.product.price * Double(cartModel.count)
        }
    }

    var wholeProductCount: Int {
        return cartItems.map { $0.count }.reduce(0, +)
    }

    // MARK: - Methods

    func removeProduct(_ product: ProductModel) async throws {
        cartItems.removeAll(where: { $0.product.id == product.id })
    }

    func changeProductCount(_ product: ProductModel, _ newCount: Int) async throws {
        guard
            newCount > 0,
            let alreadyExistCartItemIndex = cartItems.firstIndex(where: { $0.product.id == product.id })
        else {
            try await removeProduct(product)
            return
        }
        cartItems[alreadyExistCartItemIndex].count = newCount
    }

    func addProduct(_ product: ProductModel) async throws {
        if let alreadyExistCartItemIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[alreadyExistCartItemIndex].count += 1
            return
        }

        cartItems.append(.init(product: product, count: 1))
    }

    func removeAll() async throws {
        cartItems = []
    }
}
