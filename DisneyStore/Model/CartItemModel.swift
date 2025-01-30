struct CartItemModel: Hashable, Equatable {
    let product: ProductModel
    var count: Int

//    func hash(into hasher: inout Hasher) {
//        hasher.combine(count)
//        hasher.combine(product.id)
//    }
}
