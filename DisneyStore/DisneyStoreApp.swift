//
//  DisneyStoreApp.swift
//  DisneyStore
//
//  Created by Prequel on 19.01.2025.
//

import SwiftUI

@main
struct DisneyStoreApp: App {

    @State var cartService = CartService()
    @State var productsDataProvider = ProductsDataProvider()
    @State var globalPresentationManager = GlobalPresentationManager()

    @State private var isFinished = false

    var body: some Scene {
        WindowGroup {
            LaunchScreen(contentView: {
                ContentView()
            }, onFinished: $isFinished)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    isFinished.toggle()
                }
            }
//            .onTapGesture {
//                print("toggle")
//
//            }
                .rootModal(bindable: $globalPresentationManager.currentPresentable, destination: { value in
                    value
                })
//                .if(globalPresentationManager.currentPresentable != nil) { contentView in
//                    ZStack(alignment: .top) {
//                        contentView
//                        if let overlayView = globalPresentationManager.currentPresentable {
//                            overlayView
//                                .frame(
//                                    maxWidth: .infinity,
//                                    maxHeight: .infinity,
//                                    alignment: .top
//                                )
//                                .background(Color.black.opacity(0.7))
//                                .ignoresSafeArea()
//                                .statusBarHidden(false)
//                        }
//                    }
//                }
        }
        .environment(cartService)
        .environment(productsDataProvider)
        .environment(globalPresentationManager)
    }
}

struct RootModalViewModifier<Destination: View, Bindable: View>: ViewModifier {

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
                    .background(Color.black.opacity(0.5))
//                    .opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(2)
//                    .statusBarHidden(false)
//                    .transition(.scale)
            }
        }
//        .animation(, value: selectedProduct)
        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: value != nil)
    }
}

extension View {
    func rootModal<Destination: View, Bindable: View>(bindable: Binding<Bindable?>, @ViewBuilder destination: @escaping (_ value: Bindable) -> Destination) -> some View {
        self.modifier(RootModalViewModifier(value: bindable, destination: destination))
    }
}
