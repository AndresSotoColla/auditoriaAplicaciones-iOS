import SwiftUI

struct HistorialView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var audits: [AuditoriaInfo] = []
    @State private var selectedFilter: String = "TODOS"
    @State private var syncStatusMessage: String = ""
    @State private var showSyncToast: Bool = false

    var filteredAudits: [AuditoriaInfo] {
        if selectedFilter == "TODOS" { return audits }
        return audits.filter { $0.tipoAuditoria == selectedFilter }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Text("Historial de Muestreos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                let unsynced = audits.filter { !$0.isSynced }
                if !unsynced.isEmpty {
                    Button(action: syncAllUnsynced) {
                        Image(systemName: "icloud.and.arrow.up.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChipView(title: "Todos", isSelected: selectedFilter == "TODOS") { selectedFilter = "TODOS" }
                    FilterChipView(title: "Spray Boom", isSelected: selectedFilter == "Spray Boom") { selectedFilter = "Spray Boom" }
                    FilterChipView(title: "Mezclas", isSelected: selectedFilter == "Mezclas") { selectedFilter = "Mezclas" }
                    FilterChipView(title: "Calibración", isSelected: selectedFilter == "Calibracion Spray Boom") { selectedFilter = "Calibracion Spray Boom" }
                }
                .padding(.horizontal, 16)
            }

            if filteredAudits.isEmpty {
                Spacer()
                Text("No hay muestreos guardados.").foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(filteredAudits) { audit in
                        AuditHistoryRow(
                            audit: audit,
                            onSync: { syncSingle(audit) },
                            onPdf: { downloadPdf(audit) },
                            onDelete: { deleteSingle(audit.id) }
                        )
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding(.top, 12)
        .background(Color(red: 0.96, green: 0.88, blue: 0.78).edgesIgnoringSafeArea(.all))
        .onAppear {
            loadData()
        }
        .overlay(
            VStack {
                if showSyncToast {
                    Text(syncStatusMessage)
                        .font(.caption)
                        .bold()
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .top))
                }
                Spacer()
            }
            .animation(.easeInOut, value: showSyncToast)
        )
    }

    private func loadData() {
        audits = StorageManager.shared.getAuditorias()
    }

    private func syncSingle(_ audit: AuditoriaInfo) {
        SyncManager.syncAudit(audit) { success, msg in
            DispatchQueue.main.async {
                syncStatusMessage = msg
                showSyncToast = true
                if success { loadData() }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { showSyncToast = false }
            }
        }
    }

    private func syncAllUnsynced() {
        let unsynced = audits.filter { !$0.isSynced }
        unsynced.forEach { syncSingle($0) }
    }

    private func downloadPdf(_ audit: AuditoriaInfo) {
        if let url = PdfExportManager.exportToPdf(audit: audit) {
            shareFile(url: url)
        }
    }

    private func deleteSingle(_ id: String) {
        StorageManager.shared.deleteAuditoria(id: id)
        loadData()
    }

    private func shareFile(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}

struct FilterChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.black : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.2), lineWidth: 1))
        }
    }
}

struct AuditHistoryRow: View {
    let audit: AuditoriaInfo
    let onSync: () -> Void
    let onPdf: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(audit.tipoAuditoria) - Finca: \(audit.finca)")
                    .font(.headline)
                    .foregroundColor(.black)
                let dateFormatter: DateFormatter = {
                    let df = DateFormatter()
                    df.dateFormat = "dd/MM/yyyy"
                    return df
                }()
                let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: audit.fecha / 1000.0))
                Text("Fecha: \(dateStr) - Lote: \(audit.lote)\(audit.bloque.isEmpty ? "" : " - Bloque: \(audit.bloque)")")
                    .font(.caption)
                    .foregroundColor(.darkGray)
                Text("Evaluador: \(audit.evaluador)")
                    .font(.caption)
                    .foregroundColor(.gray)

                if audit.isSynced {
                    Text("✓ Sincronizado")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.green)
                }
            }

            Spacer()

            if audit.tipoAuditoria == "Calibracion Spray Boom" {
                Button(action: onPdf) {
                    Image(systemName: "doc.richtext.fill").foregroundColor(.red)
                }
            }

            if !audit.isSynced {
                Button(action: onSync) {
                    Image(systemName: "icloud.and.arrow.up").foregroundColor(.blue)
                }
            }

            Button(action: onDelete) {
                Image(systemName: "trash").foregroundColor(.red)
            }
        }
        .padding(.vertical, 6)
    }
}
