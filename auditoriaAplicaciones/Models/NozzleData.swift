import Foundation

struct NozzleData: Identifiable, Codable, Hashable, Equatable {
    var id: Int
    var volumen: String = ""
    var presion: String = ""
    var tiempoSegundos: Int = 0
}
