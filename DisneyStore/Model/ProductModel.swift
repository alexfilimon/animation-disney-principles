import Foundation

struct ProductModel: Equatable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let price: Double
    let imageName: String
    let isFav: Bool
}
