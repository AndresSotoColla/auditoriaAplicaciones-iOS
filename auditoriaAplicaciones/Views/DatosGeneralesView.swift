import SwiftUI

struct DatosGeneralesView: View {
    let auditType: String

    @State private var evaluador: String = ""
    @State private var fecha: Date = Date()
    @State private var hora: String = ""
    @State private var lote: String = ""
    @State private var bloque: String = ""
    @State private var finca: String = ""
    @State private var phAgua: String = ""
    @State private var durezaAgua: String = ""
    @State private var ceAgua: String = ""

    @State private var navigateToForm: Bool = false
    @State private var infoToPass: AuditoriaInfo = AuditoriaInfo()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(auditType)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                CardContainer {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Datos Generales")
                            .font(.headline)
                            .foregroundColor(.black)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Evaluador").font(.caption).foregroundColor(.black)
                            TextField("Nombre del evaluador", text: $evaluador)
                                .blackTextFieldStyle()
                        }

                        DatePicker("Fecha de Muestreo", selection: $fecha, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .foregroundColor(.black)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hora").font(.caption).foregroundColor(.black)
                            TextField("HH:mm", text: $hora)
                                .blackTextFieldStyle()
                        }

                        if auditType != "Calibracion Spray Boom" {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Lote (01 - 87)").font(.caption).foregroundColor(.black)
                                TextField("Número de Lote", text: $lote)
                                    .keyboardType(.numberPad)
                                    .blackTextFieldStyle()
                                    .onChange(of: lote) { newValue in
                                        handleLoteChange(newValue)
                                    }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Número de Bloque").font(.caption).foregroundColor(.black)
                                TextField("Número de Bloque", text: $bloque)
                                    .blackTextFieldStyle()
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Finca").font(.caption).foregroundColor(.black)
                                TextField("Finca", text: $finca)
                                    .blackTextFieldStyle()
                            }
                        }

                        if auditType == "Mezclas" {
                            Divider()
                            Text("Calidad del Agua").font(.headline).foregroundColor(.black)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("pH Inicial").font(.caption).foregroundColor(.black)
                                TextField("pH", text: $phAgua)
                                    .keyboardType(.decimalPad)
                                    .blackTextFieldStyle()
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dureza del Agua (ppm)").font(.caption).foregroundColor(.black)
                                TextField("Dureza", text: $durezaAgua)
                                    .keyboardType(.decimalPad)
                                    .blackTextFieldStyle()
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("CE del Agua (mS/cm)").font(.caption).foregroundColor(.black)
                                TextField("CE", text: $ceAgua)
                                    .keyboardType(.decimalPad)
                                    .blackTextFieldStyle()
                            }
                        }
                    }
                    .padding(16)
                }

                Button(action: proceedToNextScreen) {
                    Text("Continuar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.top, 12)

                NavigationLink(
                    destination: destinationFormView(),
                    isActive: $navigateToForm
                ) {
                    EmptyView()
                }
            }
            .padding(16)
        }
        .background(Color(red: 0.96, green: 0.88, blue: 0.78).edgesIgnoringSafeArea(.all))
        .onAppear {
            if hora.isEmpty {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                hora = formatter.string(from: Date())
            }
        }
    }

    private func handleLoteChange(_ val: String) {
        if val.isEmpty {
            finca = ""
        } else if let loteInt = Int(val), loteInt <= 87 {
            switch loteInt {
            case 1...20: finca = "LA FE"
            case 21...27: finca = "SULTANA"
            case 28...39: finca = "JAMAICA"
            case 40...55: finca = "EGIPTO"
            case 56...65: finca = "AMÉRICAS"
            case 66...76: finca = "BRASIL"
            case 77...87: finca = "ARGENTINA"
            default: finca = ""
            }
        }
    }

    private func proceedToNextScreen() {
        var info = AuditoriaInfo()
        info.tipoAuditoria = auditType
        info.evaluador = evaluador
        info.fecha = fecha.timeIntervalSince1970 * 1000
        info.hora = hora
        info.lote = lote
        info.bloque = bloque
        info.finca = finca
        info.phAgua = phAgua
        info.durezaAgua = durezaAgua
        info.ceAgua = ceAgua

        infoToPass = info
        navigateToForm = true
    }

    @ViewBuilder
    private func destinationFormView() -> some View {
        if auditType == "Spray Boom" {
            FormularioSprayBoomView(info: infoToPass)
        } else if auditType == "Mezclas" {
            FormularioMezclasView(info: infoToPass)
        } else {
            FormularioCalibracionView(info: infoToPass)
        }
    }
}
