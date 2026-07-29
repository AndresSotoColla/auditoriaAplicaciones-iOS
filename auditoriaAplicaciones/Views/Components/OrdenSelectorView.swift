import SwiftUI

struct OrdenSelectorView: View {
    let totalProductos: Int
    @Binding var selectedOrden: String
    let assignedOrders: [String]
    let currentProductIndex: Int

    var body: some View {
        Picker("Orden", selection: $selectedOrden) {
            Text("Sin orden").tag("")
            ForEach(1...max(1, totalProductos), id: \.self) { num in
                let strNum = "\(num)"
                let isAssignedElsewhere = assignedOrders.enumerated().contains { (idx, ord) in
                    idx != currentProductIndex && ord == strNum
                }
                if !isAssignedElsewhere {
                    Text("\(num)").tag(strNum)
                }
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.3), lineWidth: 1))
    }
}
