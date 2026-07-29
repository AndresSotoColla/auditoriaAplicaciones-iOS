import Foundation

struct ProductoEvaluado: Identifiable, Codable, Hashable, Equatable {
    var id: String = UUID().uuidString
    var producto: String
    var cumple: Bool = true
    var reemplazo: String = ""
    var cantidad: String = ""
    var unidad: String = ""
    var orden: String = ""
    
    enum CodingKeys: String, CodingKey {
        case producto, cumple, reemplazo, cantidad, unidad, orden
    }
}
