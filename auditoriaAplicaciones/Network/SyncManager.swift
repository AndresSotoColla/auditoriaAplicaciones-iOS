import Foundation

class SyncManager {
    static let shared = SyncManager()
    private let endpoint = "http://190.13.174.195:8000/api/auditoria/"
    
    static func syncAudit(_ audit: AuditoriaInfo, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: shared.endpoint) else {
            completion(false, "URL inválida")
            return
        }
        
        var jsonMap: [String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let auditDate = Date(timeIntervalSince1970: audit.fecha / 1000.0)
        
        if audit.tipoAuditoria == "Calibracion Spray Boom" {
            jsonMap["tipo_auditoria"] = "calibracion_sprayboom"
            jsonMap["evaluador"] = audit.evaluador
            jsonMap["fecha"] = dateFormatter.string(from: auditDate)
            jsonMap["hora"] = audit.hora.count == 5 ? "\(audit.hora):00" : audit.hora
            jsonMap["finca"] = audit.finca
            jsonMap["lote"] = audit.lote
            jsonMap["bloque"] = audit.bloque
            jsonMap["operario"] = audit.operarioCalib
            jsonMap["tractor"] = audit.tractorCalib
            jsonMap["volumen_tanque"] = audit.volumenTanque
            jsonMap["implemento"] = audit.implementoCalib
            jsonMap["num_boquillas"] = audit.numBoquillas
            jsonMap["tipo_boquillas"] = audit.tipoBoquillas
            jsonMap["referencia_boquillas"] = audit.referenciaBoquillas
            jsonMap["tiempo_descarga"] = audit.tiempoCalib
            jsonMap["descarga"] = audit.descargaCalib
            jsonMap["distancia_boquillas"] = Double(audit.distBoquillasCalib) ?? 0.0
            jsonMap["longitud_brazo"] = Double(audit.longitudBrazoCalib) ?? 0.0
            jsonMap["observaciones"] = audit.observaciones
            
            let runsList = audit.calculosRecorrido.map { run in
                return [
                    "distancia": run.distancia,
                    "tiempo": run.tiempo,
                    "volumen_aplicado": run.volumenAplicado
                ]
            }
            jsonMap["calculos_recorrido"] = runsList
        } else if audit.tipoAuditoria == "Mezclas" {
            jsonMap["tipo_auditoria"] = "mezclas"
            jsonMap["evaluador"] = audit.evaluador
            jsonMap["fecha"] = dateFormatter.string(from: auditDate)
            jsonMap["hora"] = audit.hora.count == 5 ? "\(audit.hora):00" : audit.hora
            jsonMap["finca"] = audit.finca
            jsonMap["lote"] = audit.lote
            jsonMap["bloque"] = audit.bloque
            jsonMap["mezclador"] = audit.mezclador
            jsonMap["formula"] = audit.formulaMezclar
            jsonMap["ph_agua"] = audit.phAgua
            jsonMap["dureza_agua"] = audit.durezaAgua
            jsonMap["ce_agua"] = audit.ceAgua
            jsonMap["ph_final"] = audit.phFinal
            jsonMap["ce_final"] = audit.ceFinal
            jsonMap["incompatibilidad"] = audit.incompatibilidad
            jsonMap["usa_epp"] = audit.usaEpp
            jsonMap["obs_epp"] = audit.obsEpp
            jsonMap["tanque_limpio"] = audit.tanqueLimpio
            jsonMap["obs_tanque_limpio"] = audit.obsTanqueLimpio
            jsonMap["observaciones"] = audit.observaciones
            jsonMap["agua_percent"] = audit.getMezclasAguaPercent()
            jsonMap["insumos_percent"] = audit.getMezclasInsumosPercent()
            jsonMap["datos_generales_percent"] = audit.getMezclasDatosGeneralesPercent()
            
            let productsList = audit.productosEvaluados.map { prod in
                return [
                    "producto": prod.producto,
                    "cumple": prod.cumple,
                    "reemplazo": prod.reemplazo,
                    "cantidad": prod.cantidad,
                    "unidad": prod.unidad,
                    "orden": prod.orden
                ]
            }
            jsonMap["productos_evaluados"] = productsList
        } else {
            jsonMap["tipo_auditoria"] = "sprayboom"
            jsonMap["evaluador"] = audit.evaluador
            jsonMap["fecha"] = dateFormatter.string(from: auditDate)
            jsonMap["hora"] = audit.hora.count == 5 ? "\(audit.hora):00" : audit.hora
            jsonMap["finca"] = audit.finca
            jsonMap["lote"] = audit.lote
            jsonMap["bloque"] = audit.bloque
            jsonMap["operador"] = audit.operador
            jsonMap["ubicacion"] = audit.ubicacion
            jsonMap["tipo_muestreo"] = audit.tipoMuestreo
            jsonMap["volumen_inicial"] = audit.volumenInicial
            jsonMap["volumen_final"] = audit.volumenFinal
            jsonMap["area_bloque"] = audit.areaBloque
            jsonMap["tractor"] = audit.codTractor
            jsonMap["spray"] = audit.codImplemento
            jsonMap["potencia_tractor"] = Int(audit.potenciaTractor) ?? 0
            jsonMap["potencia_tdf"] = Int(audit.potenciaTdf) ?? 0
            jsonMap["formula"] = audit.formula
            jsonMap["presion_aplicacion"] = Float(audit.presion.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            jsonMap["volumen_aplicar"] = Float(audit.volumen.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            jsonMap["velocidad_kmh"] = audit.velocidadKmh
            jsonMap["metros_desplazamiento"] = audit.distanciaMetros
            jsonMap["tiempo_desplazamiento"] = Double(audit.tiempoDesplazamientoSegundos)
            jsonMap["boquillas_tapadas"] = audit.boquillasTapadas ?? false
            jsonMap["cuantas_tapadas"] = Int(audit.boquillasTapadasNum) ?? 0
            jsonMap["presencia_personal"] = audit.presenciaPersonal ?? false
            jsonMap["estado_via"] = audit.estadoVia
            jsonMap["altura_uniforme"] = audit.alturaUniforme ?? false
            jsonMap["papel_hidrosensible"] = audit.papelHidrosensible
            jsonMap["velocidad_optima"] = audit.velocidadOptima
            jsonMap["observaciones"] = audit.observaciones
            jsonMap["volumen_percent"] = audit.getVolumenPercent()
            jsonMap["altura_percent"] = audit.getAlturaPercent()
            jsonMap["boquillas_percent"] = audit.getBoquillasTapadasPercent()
            jsonMap["uniformidad_percent"] = audit.getUniformidadPercent()
            
            var nozzlesList: [[String: Any]] = []
            let allNozzles = audit.nozzlesIzquierdo + audit.nozzlesDerecho
            allNozzles.forEach { n in
                nozzlesList.append([
                    "id": n.id,
                    "presion": n.presion,
                    "volumen": n.volumen,
                    "tiempo_segundos": n.tiempoSegundos
                ])
            }
            jsonMap["boquillas"] = nozzlesList
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonMap, options: [])
        } catch {
            completion(false, "Error serializando JSON: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Error de red: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Respuesta inválida del servidor")
                return
            }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                var updated = audit
                updated.isSynced = true
                StorageManager.shared.saveAuditoria(updated)
                completion(true, "Auditoría sincronizada exitosamente")
            } else {
                completion(false, "Error en el servidor: Código \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
