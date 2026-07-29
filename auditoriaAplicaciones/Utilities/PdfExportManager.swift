import Foundation
import UIKit
import PDFKit

class PdfExportManager {
    static func exportToPdf(audit: AuditoriaInfo) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Auditoría Aplicaciones iOS",
            kCGPDFContextAuthor: audit.evaluador,
            kCGPDFContextTitle: "Reporte de Calibración Spray Boom"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11.0 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in
            context.beginPage()

            let titleFont = UIFont.boldSystemFont(ofSize: 18)
            let headerFont = UIFont.boldSystemFont(ofSize: 12)
            let bodyFont = UIFont.systemFont(ofSize: 10)

            let title = "REPORTE DE CALIBRACIÓN SPRAY BOOM"
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: UIColor.black]
            title.draw(at: CGPoint(x: 40, y: 40), withAttributes: titleAttributes)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: audit.fecha / 1000.0))

            var y: CGFloat = 80
            func drawLine(_ label: String, _ val: String) {
                let text = "\(label): \(val)"
                let attrs: [NSAttributedString.Key: Any] = [.font: bodyFont, .foregroundColor: UIColor.darkGray]
                text.draw(at: CGPoint(x: 40, y: y), withAttributes: attrs)
                y += 18
            }

            drawLine("Evaluador", audit.evaluador)
            drawLine("Fecha", dateStr)
            drawLine("Hora", audit.hora)
            drawLine("Finca", audit.finca)
            drawLine("Lote", audit.lote)
            drawLine("Bloque", audit.bloque)
            drawLine("Operario", audit.operarioCalib)
            drawLine("Tractor", audit.tractorCalib)
            drawLine("Implemento", audit.implementoCalib)
            drawLine("Volumen Tanque", "\(audit.volumenTanque) L")
            drawLine("Número Boquillas", "\(audit.numBoquillas)")
            drawLine("Tipo Boquillas", audit.tipoBoquillas)
            drawLine("Referencia", audit.referenciaBoquillas)
            drawLine("Descarga", "\(audit.descargaCalib) L en \(audit.tiempoCalib) s")
            drawLine("Observaciones", audit.observaciones)

            y += 20
            let tableHeader = "CÁLCULOS DE RECORRIDO:"
            tableHeader.draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: headerFont, .foregroundColor: UIColor.black])
            y += 20

            for (idx, run) in audit.calculosRecorrido.enumerated() {
                let runText = "Pase #\(idx + 1) - Distancia: \(run.distancia) m | Tiempo: \(run.tiempo) s | Vol. Aplicado: \(run.volumenAplicado) L"
                runText.draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont, .foregroundColor: UIColor.black])
                y += 16
            }
        }

        let fileName = "Calibracion_\(audit.lote)_\(Int(Date().timeIntervalSince1970)).pdf"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: path)
            return path
        } catch {
            print("Error guardando PDF: \(error)")
            return nil
        }
    }
}
