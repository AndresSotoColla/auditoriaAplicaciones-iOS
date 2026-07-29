import Foundation

class CsvParser {
    static func parseCsv() -> [InsumoData] {
        var list: [InsumoData] = []
        guard let path = Bundle.main.path(forResource: "datos", ofType: "csv") else {
            print("datos.csv no encontrado en el bundle")
            return list
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            for (index, line) in lines.enumerated() {
                if index == 0 || line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { continue }
                let tokens = line.components(separatedBy: ";")
                if tokens.count >= 6 {
                    let insumo = InsumoData(
                        codigo: tokens[0].trimmingCharacters(in: .whitespaces),
                        descripcion: tokens[1].trimmingCharacters(in: .whitespaces),
                        numero: Int(tokens[2].trimmingCharacters(in: .whitespaces)) ?? 0,
                        insumo: tokens[3].trimmingCharacters(in: .whitespaces),
                        cantidad: tokens[4].trimmingCharacters(in: .whitespaces),
                        unidad: tokens[5].trimmingCharacters(in: .whitespaces)
                    )
                    list.append(insumo)
                }
            }
        } catch {
            print("Error leyendo CSV: \(error)")
        }
        return list
    }
}
