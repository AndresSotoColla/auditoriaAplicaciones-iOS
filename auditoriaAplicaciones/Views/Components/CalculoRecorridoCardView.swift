import SwiftUI

struct CalculoRecorridoCardView: View {
    let index: Int
    let item: CalculoRecorrido
    let onUpdate: (CalculoRecorrido) -> Void

    @State private var distancia: String = ""
    @State private var tiempo: String = ""
    @State private var volumen: String = ""

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 10) {
                Text("Recorrido #\(index + 1)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                HStack(spacing: 8) {
                    VStack(alignment: .leading) {
                        Text("Distancia (m)").font(.caption).foregroundColor(.black)
                        TextField("m", text: $distancia)
                            .keyboardType(.decimalPad)
                            .blackTextFieldStyle()
                            .onChange(of: distancia) { _ in updateItem() }
                    }
                    VStack(alignment: .leading) {
                        Text("Tiempo (s)").font(.caption).foregroundColor(.black)
                        TextField("s", text: $tiempo)
                            .keyboardType(.decimalPad)
                            .blackTextFieldStyle()
                            .onChange(of: tiempo) { _ in updateItem() }
                    }
                    VStack(alignment: .leading) {
                        Text("Volumen (L)").font(.caption).foregroundColor(.black)
                        TextField("L", text: $volumen)
                            .keyboardType(.decimalPad)
                            .blackTextFieldStyle()
                            .onChange(of: volumen) { _ in updateItem() }
                    }
                }
            }
            .padding(12)
        }
        .onAppear {
            distancia = item.distancia > 0 ? "\(item.distancia)" : ""
            tiempo = item.tiempo > 0 ? "\(item.tiempo)" : ""
            volumen = item.volumenAplicado > 0 ? "\(item.volumenAplicado)" : ""
        }
    }

    private func updateItem() {
        var updated = item
        updated.distancia = Double(distancia.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        updated.tiempo = Double(tiempo.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        updated.volumenAplicado = Double(volumen.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        onUpdate(updated)
    }
}
