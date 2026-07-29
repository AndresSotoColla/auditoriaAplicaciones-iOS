import SwiftUI

struct SelectionDialogView: View {
    let onSelect: (String) -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Seleccionar Tipo de Auditoría")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 20)

            Divider()

            VStack(spacing: 12) {
                AuditOptionCard(title: "Spray Boom", subtitle: "Auditoría de boquillas y desplazamiento", icon: "spigot.fill") {
                    onSelect("Spray Boom")
                }

                AuditOptionCard(title: "Mezclas", subtitle: "Verificación de productos e incompatibilidad", icon: "flask.fill") {
                    onSelect("Mezclas")
                }

                AuditOptionCard(title: "Calibración Spray Boom", subtitle: "Calibración de caudal y velocidad requerida", icon: "gauge.with.needle.fill") {
                    onSelect("Calibracion Spray Boom")
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.red)
            .font(.headline)
            .padding(.bottom, 20)
        }
        .background(Color(red: 0.98, green: 0.96, blue: 0.93))
    }
}

struct AuditOptionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .frame(width: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
        }
    }
}
