import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let key = "auditorias_saved_list"

    func saveAuditoria(_ auditoria: AuditoriaInfo) {
        var current = getAuditorias()
        if let index = current.firstIndex(where: { $0.id == auditoria.id }) {
            current[index] = auditoria
        } else {
            current.append(auditoria)
        }
        saveAll(current)
    }

    func getAuditorias() -> [AuditoriaInfo] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([AuditoriaInfo].self, from: data)
        } catch {
            print("Error decoding auditorias: \(error)")
            return []
        }
    }

    func deleteAuditoria(id: String) {
        var current = getAuditorias()
        current.removeAll(where: { $0.id == id })
        saveAll(current)
    }

    private func saveAll(_ list: [AuditoriaInfo]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error encoding auditorias: \(error)")
        }
    }
}
