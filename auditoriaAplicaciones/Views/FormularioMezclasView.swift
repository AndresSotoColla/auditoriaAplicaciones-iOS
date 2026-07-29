import SwiftUI

struct FormularioMezclasView: View {
    @State var info: AuditoriaInfo
    @Environment(\.presentationMode) var presentationMode

    @State private var mezclador: String = ""
    @State private var formulaMezclar: String = ""
    @State private var productosEvaluados: [ProductoEvaluado] = []
    @State private var insumosDisponibles: [InsumoData] = []

    @State private var incompatibilidad: Bool = false
    @State private var usaEpp: Bool = true
    @State private var obsEpp: String = ""
    @State private var tanqueLimpio: Bool = true
    @State private var obsTanqueLimpio: String = ""
    @State private var phFinal: String = ""
    @State private var ceFinal: String = ""
    @State private var observaciones: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CardContainer {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Auditoría de Mezclas")
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
                        Text("Datos de la Mezcla").font(.headline).foregroundColor(.black)

                        TextField("Nombre del Mezclador", text: $mezclador).blackTextFieldStyle()
                        TextField("Fórmula a Mezclar", text: $formulaMezclar).blackTextFieldStyle()
                    }
                    .padding(16)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Evaluación de Productos").font(.headline).foregroundColor(.black)

                        if insumosDisponibles.isEmpty {
                            Text("Cargando lista de insumos...").font(.caption).foregroundColor(.gray)
                        } else {
                            Picker("Agregar Insumo", selection: $formulaMezclar) {
                                Text("Seleccionar insumo").tag("")
                                ForEach(insumosDisponibles) { item in
                                    Text("\(item.insumo) (\(item.cantidad) \(item.unidad))").tag(item.insumo)
                                }
                            }
                            .onChange(of: formulaMezclar) { selectedName in
                                addProducto(name: selectedName)
                            }
                        }

                        ForEach(0..<productosEvaluados.count, id: \.self) { idx in
                            let prod = productosEvaluados[idx]
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(prod.producto).bold().foregroundColor(.black)
                                    Spacer()
                                    Toggle("¿Aplicó?", isOn: $productosEvaluados[idx].cumple)
                                        .labelsHidden()
                                }

                                HStack {
                                    Text("Orden en mezcla:").font(.caption).foregroundColor(.black)
                                    OrdenSelectorView(
                                        totalProductos: productosEvaluados.count,
                                        selectedOrden: $productosEvaluados[idx].orden,
                                        assignedOrders: productosEvaluados.map { $0.orden },
                                        currentProductIndex: idx
                                    )
                                }
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(16)
                }

                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Verificación General").font(.headline).foregroundColor(.black)

                        Toggle("¿Incompatibilidad de Productos?", isOn: $incompatibilidad).foregroundColor(.black)
                        Toggle("¿Utiliza EPP Adecuado?", isOn: $usaEpp).foregroundColor(.black)
                        Toggle("¿Tanque Limpio y Preparado?", isOn: $tanqueLimpio).foregroundColor(.black)

                        TextField("pH Final", text: $phFinal).keyboardType(.decimalPad).blackTextFieldStyle()
                        TextField("CE Final (mS/cm)", text: $ceFinal).keyboardType(.decimalPad).blackTextFieldStyle()
                        TextField("Observaciones Generales", text: $observaciones).blackTextFieldStyle()
                    }
                    .padding(16)
                }

                Button(action: saveMezclas) {
                    Text("Guardar Auditoría de Mezclas")
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
            insumosDisponibles = CsvParser.parseCsv()
        }
    }

    private func addProducto(name: String) {
        guard !name.isEmpty && !productosEvaluados.contains(where: { $0.producto == name }) else { return }
        let newProd = ProductoEvaluado(producto: name, cumple: true, orden: "")
        productosEvaluados.append(newProd)
    }

    private func saveMezclas() {
        var updated = info
        updated.mezclador = mezclador
        updated.formulaMezclar = formulaMezclar
        updated.productosEvaluados = productosEvaluados
        updated.incompatibilidad = incompatibilidad
        updated.usaEpp = usaEpp
        updated.tanqueLimpio = tanqueLimpio
        updated.phFinal = phFinal
        updated.ceFinal = ceFinal
        updated.observaciones = observaciones

        StorageManager.shared.saveAuditoria(updated)
        presentationMode.wrappedValue.dismiss()
    }
}
