import Foundation

struct CalculoRecorrido: Identifiable, Codable, Hashable, Equatable {
    var id: String = UUID().uuidString
    var distancia: Double = 0.0
    var tiempo: Double = 0.0
    var volumenAplicado: Double = 0.0
}
