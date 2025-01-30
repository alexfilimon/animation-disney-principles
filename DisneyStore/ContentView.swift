import SwiftUI

struct ContentView: View {

    @Environment(CartService.self) var cartService
    @Environment(ProductsDataProvider.self) var productsDataProvider

    @State private var selectedScreen = 0

    var body: some View {
        TabView {
            Tab("Products", systemImage: "list.bullet") {
                NavigationStack {
                    ProductsScreen()
                }
                .onAppear {
                    productsDataProvider.loadItems()
                }
            }

            Tab("Cart", systemImage: "cart") {
                NavigationStack {
                    CartScreen()
                }
            }
            .badge(cartService.wholeProductCount)
        }
    }
}

#Preview {
    ContentView()
        .environment(CartService())
        .environment(ProductsDataProvider())
}
