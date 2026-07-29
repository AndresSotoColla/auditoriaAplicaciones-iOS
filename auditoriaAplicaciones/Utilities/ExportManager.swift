import Foundation

class ExportManager {
    static func exportToCsv() -> URL? {
        let audits = StorageManager.shared.getAuditorias()
        guard !audits.isEmpty else { return nil }

        var csvString = "ID;TipoAuditoria;Fecha;Hora;Evaluador;Finca;Lote;Bloque;Operador;Tractor;Implemento;Observaciones;Sincronizado\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        audits.forEach { audit in
            let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: audit.fecha / 1000.0))
            let line = "\(audit.id);\(audit.tipoAuditoria);\(dateStr);\(audit.hora);\(audit.evaluador);\(audit.finca);\(audit.lote);\(audit.bloque);\(audit.operador);\(audit.codTractor);\(audit.codImplemento);\(audit.observaciones);\(audit.isSynced ? "SI" : "NO")\n"
            csvString.append(line)
        }

        let fileName = "Auditorias_\(Int(Date().timeIntervalSince1970)).csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Error generando archivo CSV: \(error)")
            return nil
        }
    }
}
