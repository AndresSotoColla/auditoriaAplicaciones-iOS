import Foundation

struct InsumoData: Identifiable, Codable, Hashable, Equatable {
    var id: String { codigo }
    let codigo: String
    let descripcion: String
    let numero: Int
    let insumo: String
    let cantidad: String
    let unidad: String
}
