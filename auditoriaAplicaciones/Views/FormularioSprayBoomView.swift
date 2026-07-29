import SwiftUI

struct FormularioSprayBoomView: View {
    @State var info: AuditoriaInfo
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()

    @State private var operador: String = ""
    @State private var codTractor: String = ""
    @State private var codImplemento: String = ""
    @State private var potenciaTractor: String = ""
    @State private var potenciaTdf: String = ""
    @State private var formula: String = "OTRO"
    @State private var manualFormulaName: String = ""
    @State private var presion: String = ""
    @State private var volumen: String = ""
    @State private var longitudBrazoIzquierdo: String = ""
    @State private var longitudBrazoDerecho: String = ""
    @State private var cantidadBoquillasIzquierdas: String = ""
    @State private var cantidadBoquillasDerechas: String = ""
    @State private var leftNozzles: [NozzleData] = []
    @State private var rightNozzles: [NozzleData] = []

    @State private var tipoMuestreo: String = "BOQUILLAS"
    @State private var volumenInicial: String = ""
    @State private var volumenFinal: String = ""
    @State private var areaBloque: String = ""

    @State private var boquillasTapadas: Bool? = nil
    @State private var boquillasTapadasNum: String = ""
    @State private var presenciaPersonal: Bool? = nil
    @State private var alturaUniforme: Bool? = nil
    @State private var estadoVia: String = ""
    @State private var papelHidro: Bool = false
    @State private var observaciones: String = ""

    @State private var showRecommendationDialog = false
    @State private var tempFinalInfo: AuditoriaInfo = AuditoriaInfo()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CardContainer {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Muestreo Aplicación - Spray Boom")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Lote: \(info.lote)\(info.bloque.isEmpty ? "" : " - Bloque: \(info.bloque)")")
                            .font(.subheadline)
                            .foregroundColor(Color(white: 0.3))
                    }
                    .padding(12)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Operador y Maquinaria").font(.headline).foregroundColor(.black)

                        TextField("Operador", text: $operador).blackTextFieldStyle()
                        TextField("Código Tractor", text: $codTractor).blackTextFieldStyle()
                        TextField("Código Implemento", text: $codImplemento).blackTextFieldStyle()
                        TextField("Potencia Tractor (HP)", text: $potenciaTractor).keyboardType(.numberPad).blackTextFieldStyle()
                        TextField("Potencia TDF (HP)", text: $potenciaTdf).keyboardType(.numberPad).blackTextFieldStyle()
                    }
                    .padding(16)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Parámetros de Aplicación").font(.headline).foregroundColor(.black)

                        TextField("Fórmula de Mezcla", text: $formula).blackTextFieldStyle()
                        TextField("Presión de Trabajo (PSI)", text: $presion).keyboardType(.decimalPad).blackTextFieldStyle()
                        TextField("Volumen a Aplicar (L/Ha)", text: $volumen).keyboardType(.decimalPad).blackTextFieldStyle()
                    }
                    .padding(16)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Modo de Muestreo").font(.headline).foregroundColor(.black)

                        HStack(spacing: 8) {
                            Button(action: { tipoMuestreo = "BOQUILLAS" }) {
                                Text("Boquillas Aleatorias")
                                    .font(.caption)
                                    .bold()
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(tipoMuestreo == "BOQUILLAS" ? Color.black : Color.white)
                                    .foregroundColor(tipoMuestreo == "BOQUILLAS" ? .white : .black)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                            }

                            Button(action: { tipoMuestreo = "VOLUMEN_AREA" }) {
                                Text("Muestreo por Volumen y Área")
                                    .font(.caption)
                                    .bold()
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(tipoMuestreo == "VOLUMEN_AREA" ? Color.black : Color.white)
                                    .foregroundColor(tipoMuestreo == "VOLUMEN_AREA" ? .white : .black)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                            }
                        }

                        if tipoMuestreo == "VOLUMEN_AREA" {
                            VStack(spacing: 10) {
                                TextField("Volumen Inicial (L)", text: $volumenInicial)
                                    .keyboardType(.decimalPad)
                                    .blackTextFieldStyle()

                                TextField("Volumen Final (L)", text: $volumenFinal)
                                    .keyboardType(.decimalPad)
                                    .blackTextFieldStyle()

                                TextField("Área del Bloque (Ha)", text: $areaBloque)
                                    .keyboardType(.decimalPad)
                                    .blackTextFieldStyle()

                                let vIni = Float(volumenInicial.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                                let vFin = Float(volumenFinal.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                                let aBloq = Float(areaBloque.replacingOccurrences(of: ",", with: ".")) ?? 0.0

                                if vIni > 0 && vFin >= 0 && vIni >= vFin {
                                    let vAplicado = vIni - vFin
                                    Text("Volumen Aplicado: \(String(format: "%.1f", vAplicado)) L")
                                        .bold()
                                        .foregroundColor(.green)

                                    if aBloq > 0 {
                                        let lha = vAplicado / aBloq
                                        Text("Dosis / Caudal: \(String(format: "%.2f", lha)) L/Ha")
                                            .bold()
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding(.top, 8)
                        } else {
                            TextField("Longitud Brazo Izquierdo (m)", text: $longitudBrazoIzquierdo).keyboardType(.decimalPad).blackTextFieldStyle()
                            TextField("Longitud Brazo Derecho (m)", text: $longitudBrazoDerecho).keyboardType(.decimalPad).blackTextFieldStyle()
                            TextField("Boquillas Brazo Izquierdo", text: $cantidadBoquillasIzquierdas).keyboardType(.numberPad).blackTextFieldStyle()
                            TextField("Boquillas Brazo Derecho", text: $cantidadBoquillasDerechas).keyboardType(.numberPad).blackTextFieldStyle()

                            Button(action: generateRandomNozzles) {
                                Text("Generar Boquillas Aleatorias")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(Color.black)
                                    .cornerRadius(10)
                            }

                            if !rightNozzles.isEmpty {
                                Text("Brazo Derecho").bold().foregroundColor(.black).padding(.top, 8)
                                ForEach(0..<rightNozzles.count, id: \.self) { idx in
                                    BoquillaItemView(nozzle: rightNozzles[idx]) { updated in
                                        rightNozzles[idx] = updated
                                    }
                                }
                            }

                            if !leftNozzles.isEmpty {
                                Text("Brazo Izquierdo").bold().foregroundColor(.black).padding(.top, 8)
                                ForEach(0..<leftNozzles.count, id: \.self) { idx in
                                    BoquillaItemView(nozzle: leftNozzles[idx]) { updated in
                                        leftNozzles[idx] = updated
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Evaluación Final").font(.headline).foregroundColor(.black)

                        Toggle("¿Boquillas Tapadas?", isOn: Binding(
                            get: { boquillasTapadas ?? false },
                            set: { boquillasTapadas = $0 }
                        )).foregroundColor(.black)

                        if boquillasTapadas == true {
                            TextField("¿Cuántas boquillas tapadas?", text: $boquillasTapadasNum)
                                .keyboardType(.numberPad)
                                .blackTextFieldStyle()
                        }

                        Toggle("¿Presencia de Personal?", isOn: Binding(
                            get: { presenciaPersonal ?? false },
                            set: { presenciaPersonal = $0 }
                        )).foregroundColor(.black)

                        Toggle("¿Altura Uniforme?", isOn: Binding(
                            get: { alturaUniforme ?? false },
                            set: { alturaUniforme = $0 }
                        )).foregroundColor(.black)

                        TextField("Observaciones Generales", text: $observaciones)
                            .blackTextFieldStyle()
                    }
                    .padding(16)
                }

                Button(action: prepareSave) {
                    Text("Finalizar y Guardar Auditoría")
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
        .onAppear {
            locationManager.requestLocation()
        }
        .alert(isPresented: $showRecommendationDialog) {
            Alert(
                title: Text("Resultados y Recomendaciones"),
                message: Text(buildRecommendationMessage()),
                primaryButton: .default(Text("Guardar"), action: saveAuditoriaFinal),
                secondaryButton: .cancel()
            )
        }
    }

    private func generateRandomNozzles() {
        let n = Int(cantidadBoquillasDerechas) ?? 0
        let m = Int(cantidadBoquillasIzquierdas) ?? 0

        if n > 0 {
            let r1 = Int.random(in: 1...n)
            let r2 = n >= 2 ? (1...n).filter { $0 != r1 }.randomElement()! : r1
            rightNozzles = n >= 2 ? [NozzleData(id: r1), NozzleData(id: r2)] : [NozzleData(id: r1)]
        } else {
            rightNozzles = []
        }

        if m > 0 {
            let r1 = Int.random(in: (n + 1)...(n + m))
            let r2 = m >= 2 ? ((n + 1)...(n + m)).filter { $0 != r1 }.randomElement()! : r1
            leftNozzles = m >= 2 ? [NozzleData(id: r1), NozzleData(id: r2)] : [NozzleData(id: r1)]
        } else {
            leftNozzles = []
        }
    }

    private func prepareSave() {
        var updated = info
        updated.operador = operador
        updated.codTractor = codTractor
        updated.codImplemento = codImplemento
        updated.potenciaTractor = potenciaTractor
        updated.potenciaTdf = potenciaTdf
        updated.formula = formula
        updated.presion = presion
        updated.volumen = volumen
        updated.tipoMuestreo = tipoMuestreo
        updated.volumenInicial = volumenInicial
        updated.volumenFinal = volumenFinal
        updated.areaBloque = areaBloque
        updated.longitudBrazoIzquierdo = longitudBrazoIzquierdo
        updated.longitudBrazoDerecho = longitudBrazoDerecho
        updated.cantidadBoquillasIzquierdas = cantidadBoquillasIzquierdas
        updated.cantidadBoquillasDerechas = cantidadBoquillasDerechas
        updated.nozzlesIzquierdo = tipoMuestreo == "BOQUILLAS" ? leftNozzles : []
        updated.nozzlesDerecho = tipoMuestreo == "BOQUILLAS" ? rightNozzles : []
        updated.boquillasTapadas = boquillasTapadas
        updated.boquillasTapadasNum = boquillasTapadasNum
        updated.presenciaPersonal = presenciaPersonal
        updated.alturaUniforme = alturaUniforme
        updated.estadoVia = estadoVia
        updated.papelHidrosensible = papelHidro
        updated.observaciones = observaciones
        updated.ubicacion = locationManager.locationString

        tempFinalInfo = updated
        showRecommendationDialog = true
    }

    private func buildRecommendationMessage() -> String {
        let vol = tempFinalInfo.getVolumenPercent()
        let uni = tempFinalInfo.getUniformidadPercent()
        return "Cumplimiento Volumen: \(String(format: "%.1f", vol))%\nUniformidad: \(String(format: "%.1f", uni))%\n¿Desea guardar la auditoría?"
    }

    private func saveAuditoriaFinal() {
        StorageManager.shared.saveAuditoria(tempFinalInfo)
        presentationMode.wrappedValue.dismiss()
    }
}
