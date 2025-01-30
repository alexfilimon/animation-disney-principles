import SwiftUI

struct CustomContentView: View {
    @State var show = false
    @Namespace var namespace

    var body: some View {
        ZStack {
            if !show {
                VStack {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 10)
                            .matchedGeometryEffect(id: "shape", in: namespace)
                            .frame(width: 44)
                        Text("Fever")
                            .matchedGeometryEffect(id: "title", in: namespace)
                        Spacer()
                        Image(systemName: "play.fill")
                            .matchedGeometryEffect(id: "play", in: namespace)
                            .font(.title)
                        Image(systemName: "forward.fill")
                            .matchedGeometryEffect(id: "forward", in: namespace)
                            .font(.title)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.blue)
                        .matchedGeometryEffect(id: "background", in: namespace)
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                PlayView(namespace: namespace)
            }
        }
        .foregroundColor(.white)
        .onTapGesture {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                show.toggle()
            }
        }
    }
}

struct PlayView: View {
    var namespace: Namespace.ID

    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 30)
                .matchedGeometryEffect(id: "shape", in: namespace)
                .frame(height: 300)
                .padding()
            Text("Fever")
                .matchedGeometryEffect(id: "title", in: namespace)
            HStack {
                Image(systemName: "play.fill")
                    .matchedGeometryEffect(id: "play", in: namespace)
                    .font(.title)
                Image(systemName: "forward.fill")
                    .matchedGeometryEffect(id: "forward", in: namespace)
                    .font(.title)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.blue)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .ignoresSafeArea()
    }
}

//struct PlayView_Previews: PreviewProvider {
//    @Namespace static var namespace
//
//    static var previews: some View {
//        PlayView(namespace: namespace)
//    }
//}

#Preview {
    CustomContentView()
}
