import Foundation

@Observable
class ProductsDataProvider {

    enum State: Equatable {
        case loading
        case items([ProductModel])

        var rawValue: String {
            switch self {
            case .loading:
                return "loading"
            case .items:
                return "items"
            }
        }
    }

    var state: State = .loading

    func loadItems() {
        if case .items = state {
            state = .loading
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.state = .items([
                .init(
                    id: UUID(),
                    title: "Donald Duck Cookie Jar",
                    price: 19.99,
                    imageName: "product_6.jpg",
                    isFav: false
                ),
                .init(
                    id: UUID(),
                    title: "Tigger Figural Mug",
                    price: 17.99,
                    imageName: "product_5.jpg",
                    isFav: false
                ),
                .init(
                    id: UUID(),
                    title: "Minnie Mouse Red Rolling Luggage",
                    price: 60,
                    imageName: "product_3.jpg",
                    isFav: false
                ),
                .init(
                    id: UUID(),
                    title: "Mickey Mouse Soft Toy",
                    price: 21,
                    imageName: "product_1.jpg",
                    isFav: false
                ),
                .init(
                    id: UUID(),
                    title: "Mickey Mouse and Friends Luggage Tag",
                    price: 13,
                    imageName: "product_8.jpg",
                    isFav: false
                ),
                .init(
                    id: UUID(),
                    title: "Belle Classic Doll, Beauty and the Beast",
                    price: 15.99,
                    imageName: "product_4.jpg",
                    isFav: false
                ),
                .init(
                    id: UUID(),
                    title: "The Lion King Hooded Sweatshirt For Kids",
                    price: 22,
                    imageName: "product_2.jpg",
                    isFav: false
                ),
                .init(
                    id: UUID(),
                    title: "Winnie the Pooh and Piglet Pin, Winnie the Pooh",
                    price: 12,
                    imageName: "product_7.jpg",
                    isFav: false
                )
            ])
//        }
    }

}
