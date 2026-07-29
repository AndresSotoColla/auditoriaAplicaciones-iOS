import SwiftUI

struct FormularioCalibracionView: View {
    @State var info: AuditoriaInfo
    @Environment(\.presentationMode) var presentationMode

    @State private var operarioCalib: String = ""
    @State private var tractorCalib: String = ""
    @State private var volumenTanque: String = ""
    @State private var implementoCalib: String = ""
    @State private var numBoquillas: String = ""
    @State private var tipoBoquillas: String = ""
    @State private var referenciaBoquillas: String = ""
    @State private var tiempoCalib: String = ""
    @State private var descargaCalib: String = ""
    @State private var calculosRecorrido: [CalculoRecorrido] = [CalculoRecorrido()]
    @State private var distBoquillasCalib: String = ""
    @State private var longitudBrazoCalib: String = ""
    @State private var observaciones: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CardContainer {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Calibración Spray Boom")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Finca: \(info.finca) - Lote: \(info.lote)\(info.bloque.isEmpty ? "" : " - Bloque: \(info.bloque)")")
                            .font(.subheadline)
                            .foregroundColor(.darkGray)
                    }
                    .padding(12)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Datos de la Maquinaria").font(.headline).foregroundColor(.black)

                        TextField("Operario", text: $operarioCalib).blackTextFieldStyle()
                        TextField("Código Tractor", text: $tractorCalib).blackTextFieldStyle()
                        TextField("Volumen Tanque (L)", text: $volumenTanque).keyboardType(.decimalPad).blackTextFieldStyle()
                        TextField("Implemento", text: $implementoCalib).blackTextFieldStyle()
                    }
                    .padding(16)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Parámetros de Boquillas").font(.headline).foregroundColor(.black)

                        TextField("Número de Boquillas", text: $numBoquillas).keyboardType(.numberPad).blackTextFieldStyle()
                        TextField("Tipo de Boquillas", text: $tipoBoquillas).blackTextFieldStyle()
                        TextField("Referencia Boquillas", text: $referenciaBoquillas).blackTextFieldStyle()
                        TextField("Tiempo de Descarga (s)", text: $tiempoCalib).keyboardType(.decimalPad).blackTextFieldStyle()
                        TextField("Descarga Total (L)", text: $descargaCalib).keyboardType(.decimalPad).blackTextFieldStyle()
                    }
                    .padding(16)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Pases de Calibración").font(.headline).foregroundColor(.black)
                            Spacer()
                            Button(action: addRecorrido) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                        }

                        ForEach(0..<calculosRecorrido.count, id: \.self) { idx in
                            CalculoRecorridoCardView(index: idx, item: calculosRecorrido[idx]) { updated in
                                calculosRecorrido[idx] = updated
                            }
                        }
                    }
                    .padding(16)
                }

                Button(action: saveCalibracion) {
                    Text("Guardar Calibración")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            .padding(16)
        }
        .background(Color(red: 0.96, green: 0.88, blue: 0.78).edgesIgnoringSafeArea(.all))
    }

    private func addRecorrido() {
        calculosRecorrido.append(CalculoRecorrido())
    }

    private func saveCalibracion() {
        var updated = info
        updated.operarioCalib = operarioCalib
        updated.tractorCalib = tractorCalib
        updated.volumenTanque = Double(volumenTanque.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        updated.implementoCalib = implementoCalib
        updated.numBoquillas = Int(numBoquillas) ?? 0
        updated.tipoBoquillas = tipoBoquillas
        updated.referenciaBoquillas = referenciaBoquillas
        updated.tiempoCalib = Double(tiempoCalib.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        updated.descargaCalib = Double(descargaCalib.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        updated.calculosRecorrido = calculosRecorrido
        updated.distBoquillasCalib = distBoquillasCalib
        updated.longitudBrazoCalib = longitudBrazoCalib
        updated.observaciones = observaciones

        StorageManager.shared.saveAuditoria(updated)
        presentationMode.wrappedValue.dismiss()
    }
}
