import Foundation

struct AuditoriaInfo: Identifiable, Codable, Hashable, Equatable {
    var id: String = UUID().uuidString
    var tipoAuditoria: String = ""
    var evaluador: String = ""
    var fecha: Double = Date().timeIntervalSince1970 * 1000
    var hora: String = ""
    var lote: String = ""
    var bloque: String = ""
    var finca: String = ""
    var operador: String = ""
    var codTractor: String = ""
    var codImplemento: String = ""
    var potenciaTractor: String = ""
    var potenciaTdf: String = ""
    var formula: String = ""
    var presion: String = ""
    var volumen: String = ""
    
    var mezclador: String = ""
    var formulaMezclar: String = ""
    var productosEvaluados: [ProductoEvaluado] = []
    var incompatibilidad: Bool = false
    var ordenMezclado: Bool = true
    var obsOrdenMezclado: String = ""
    var usaEpp: Bool = true
    var obsEpp: String = ""
    var tanqueLimpio: Bool = true
    var obsTanqueLimpio: String = ""
    
    var phAgua: String = ""
    var durezaAgua: String = ""
    var ceAgua: String = ""
    var phFinal: String = ""
    var ceFinal: String = ""
    
    // Boquillas y Brazos
    var tipoMuestreo: String = "BOQUILLAS"
    var volumenInicial: String = ""
    var volumenFinal: String = ""
    var areaBloque: String = ""
    var longitudBrazoIzquierdo: String = ""
    var longitudBrazoDerecho: String = ""
    var cantidadBoquillasIzquierdas: String = ""
    var cantidadBoquillasDerechas: String = ""
    var nozzlesIzquierdo: [NozzleData] = []
    var nozzlesDerecho: [NozzleData] = []
    
    // GPS y Desplazamiento
    var tiempoDesplazamientoSegundos: Int64 = 0
    var distanciaMetros: Float = 0.0
    var velocidadKmh: Float = 0.0

    // Cuestionario Final
    var boquillasTapadas: Bool? = nil
    var boquillasTapadasNum: String = ""
    var presenciaPersonal: Bool? = nil
    var alturaUniforme: Bool? = nil
    var estadoVia: String = ""
    var papelHidrosensible: Bool = false
    var papelGotas1cm: String = ""
    var tamanoGotas: String = ""
    var ubicacion: String = ""
    var observaciones: String = ""
    var velocidadOptima: Float = 0.0
    var isSynced: Bool = false

    // Calibración Spray Boom
    var operarioCalib: String = ""
    var tractorCalib: String = ""
    var volumenTanque: Double = 0.0
    var implementoCalib: String = ""
    var numBoquillas: Int = 0
    var tipoBoquillas: String = ""
    var referenciaBoquillas: String = ""
    var tiempoCalib: Double = 0.0
    var descargaCalib: Double = 0.0
    var calculosRecorrido: [CalculoRecorrido] = []
    var distBoquillasCalib: String = ""
    var longitudBrazoCalib: String = ""
    
    // MARK: - Scoring Functions
    func getVolumenPercent() -> Float {
        if tipoMuestreo == "VOLUMEN_AREA" {
            let vIni = Float(volumenInicial.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let vFin = Float(volumenFinal.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let vAplicado = (vIni >= vFin) ? (vIni - vFin) : 0.0
            let areaHa = Float(areaBloque.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            
            if areaHa > 0.0 && vAplicado > 0.0 {
                let lha = vAplicado / areaHa
                return (lha / 2000.0) * 100.0
            } else if vAplicado > 0.0 {
                let longIzqVal = Float(longitudBrazoIzquierdo.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                let longDerVal = Float(longitudBrazoDerecho.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                let totalArmLen = longIzqVal + longDerVal
                if totalArmLen > 0.0 && distanciaMetros > 0.0 {
                    let calcAreaHa = (totalArmLen * distanciaMetros) / 10000.0
                    if calcAreaHa > 0.0 {
                        let lha = vAplicado / calcAreaHa
                        return (lha / 2000.0) * 100.0
                    }
                }
            }
            return vAplicado > 0.0 ? 100.0 : 0.0
        }

        let nTotal = (Int(cantidadBoquillasIzquierdas) ?? 0) + (Int(cantidadBoquillasDerechas) ?? 0)
        let longIzqVal = Float(longitudBrazoIzquierdo.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let longDerVal = Float(longitudBrazoDerecho.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let allEvaluated = nozzlesIzquierdo + nozzlesDerecho
        var lhaResults: [Float] = []
        
        allEvaluated.forEach { nozzle in
            let nTime = Float(nozzle.tiempoSegundos)
            let nVol = Float(nozzle.volumen.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            if nTime > 0.0 {
                let flow = nVol / nTime
                let totalVolTripL = (flow * Float(tiempoDesplazamientoSegundos)) / 1000.0
                let isLeft = nozzlesIzquierdo.contains(where: { $0.id == nozzle.id })
                let armLen = isLeft ? longIzqVal : longDerVal
                if armLen > 0.0 {
                    let areaHa = (armLen * distanciaMetros) / 10000.0
                    if areaHa > 0.0 {
                        let lhaIndividual = (totalVolTripL / areaHa) * Float(nTotal)
                        lhaResults.append(lhaIndividual)
                    }
                }
            }
        }
        let avgLHa = !lhaResults.isEmpty ? (lhaResults.reduce(0, +) / Float(lhaResults.count)) : 0.0
        return avgLHa > 0.0 ? (avgLHa / 2000.0) * 100.0 : 0.0
    }

    func getAlturaPercent() -> Float {
        return (alturaUniforme == true) ? 100.0 : 0.0
    }

    func getBoquillasTapadasPercent() -> Float {
        let nTotal = (Int(cantidadBoquillasIzquierdas) ?? 0) + (Int(cantidadBoquillasDerechas) ?? 0)
        let numClogged = (boquillasTapadas == true) ? (Int(boquillasTapadasNum) ?? 0) : 0
        return nTotal > 0 ? ((Float(nTotal - numClogged) / Float(nTotal)) * 100.0) : 100.0
    }

    func getUniformidadPercent() -> Double {
        let allEvaluated = nozzlesIzquierdo + nozzlesDerecho
        var flowsMLs: [Double] = []
        allEvaluated.forEach { nozzle in
            let nTime = Double(nozzle.tiempoSegundos)
            let nVol = Double(nozzle.volumen.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            if nTime > 0.0 {
                flowsMLs.append(nVol / nTime)
            }
        }
        let meanFlow = !flowsMLs.isEmpty ? (flowsMLs.reduce(0, +) / Double(flowsMLs.count)) : 0.0
        let avgDevFlow = !flowsMLs.isEmpty ? (flowsMLs.map { abs($0 - meanFlow) }.reduce(0, +) / Double(flowsMLs.count)) : 0.0
        return meanFlow > 0.0 ? (1.0 - (avgDevFlow / meanFlow)) * 100.0 : 0.0
    }

    func getMezclasAguaPercent() -> Float {
        let ph = Double(phAgua.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let dureza = Double(durezaAgua.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let ce = Double(ceAgua.replacingOccurrences(of: ",", with: ".")) ?? 0.0

        let phScore = (!phAgua.isEmpty && ph >= 5.0 && ph <= 5.8) ? (100.0 / 3.0) : 0.0
        let durezaScore = (!durezaAgua.isEmpty && dureza < 120.0) ? (100.0 / 3.0) : 0.0
        let ceScore = (!ceAgua.isEmpty && ce < 70.0) ? (100.0 / 3.0) : 0.0

        return Float(phScore + durezaScore + ceScore)
    }

    func getMezclasInsumosPercent() -> Float {
        if productosEvaluados.isEmpty { return 100.0 }
        let cumpleCount = productosEvaluados.filter { $0.cumple }.count
        return (Float(cumpleCount) / Float(productosEvaluados.count)) * 100.0
    }

    func getMezclasDatosGeneralesPercent() -> Float {
        var score: Float = 0.0
        if !incompatibilidad { score += 100.0 / 3.0 }
        if usaEpp { score += 100.0 / 3.0 }
        if tanqueLimpio { score += 100.0 / 3.0 }
        return score
    }
}
