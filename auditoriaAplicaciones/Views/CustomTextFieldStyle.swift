import SwiftUI

struct BlackBorderedTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 1)
            )
            .foregroundColor(.black)
    }
}

extension View {
    func blackTextFieldStyle() -> some View {
        self.modifier(BlackBorderedTextFieldModifier())
    }
}
