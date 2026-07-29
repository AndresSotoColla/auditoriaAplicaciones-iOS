import SwiftUI

struct BoquillaItemView: View {
    let nozzle: NozzleData
    let onUpdate: (NozzleData) -> Void

    @State private var volumen: String = ""
    @State private var presion: String = ""
    @State private var tiempoSegundos: String = ""

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 8) {
                Text("Boquilla #\(nozzle.id)")
                    .font(.headline)
                    .foregroundColor(.black)

                HStack(spacing: 8) {
                    TextField("Volumen (ml)", text: $volumen)
                        .keyboardType(.decimalPad)
                        .blackTextFieldStyle()
                        .onChange(of: volumen) { newValue in notifyUpdate() }

                    TextField("Presión (PSI)", text: $presion)
                        .keyboardType(.decimalPad)
                        .blackTextFieldStyle()
                        .onChange(of: presion) { newValue in notifyUpdate() }

                    TextField("Tiempo (s)", text: $tiempoSegundos)
                        .keyboardType(.numberPad)
                        .blackTextFieldStyle()
                        .onChange(of: tiempoSegundos) { newValue in notifyUpdate() }
                }
            }
            .padding(12)
        }
        .onAppear {
            volumen = nozzle.volumen
            presion = nozzle.presion
            tiempoSegundos = nozzle.tiempoSegundos > 0 ? "\(nozzle.tiempoSegundos)" : ""
        }
    }

    private func notifyUpdate() {
        var updated = nozzle
        updated.volumen = volumen
        updated.presion = presion
        updated.tiempoSegundos = Int(tiempoSegundos) ?? 0
        onUpdate(updated)
    }
}

struct CardContainer<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack { content }
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
