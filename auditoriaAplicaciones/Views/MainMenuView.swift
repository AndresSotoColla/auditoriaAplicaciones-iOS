import SwiftUI

struct MainMenuView: View {
    @State private var showSelectionDialog = false
    @State private var navigateToHistorial = false
    @State private var selectedAuditType: String? = nil
    @State private var navigateToDatosGenerales = false

    var body: some View {
        NavigationView {
            ZStack {
                VideoBackgroundView(videoName: "bg_video", videoType: "mp4")
                    .edgesIgnoringSafeArea(.all)
                
                Color.black.opacity(0.35)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 24) {
                    Spacer()

                    VStack(spacing: 8) {
                        Text("Auditoría Aplicaciones")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 4)

                        Text("Sistema de Gestión y Evaluación de Aplicaciones")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }

                    Spacer()

                    VStack(spacing: 16) {
                        MenuButton(title: "Realizar Auditoría", iconName: "doc.badge.plus") {
                            showSelectionDialog = true
                        }

                        NavigationLink(destination: HistorialView(), isActive: $navigateToHistorial) {
                            EmptyView()
                        }

                        MenuButton(title: "Historial de Muestreos", iconName: "clock.arrow.circlepath") {
                            navigateToHistorial = true
                        }

                        MenuButton(title: "Exportar Datos (CSV)", iconName: "square.and.arrow.up") {
                            if let url = ExportManager.exportToCsv() {
                                shareFile(url: url)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }

                if let auditType = selectedAuditType {
                    NavigationLink(
                        destination: DatosGeneralesView(auditType: auditType),
                        isActive: $navigateToDatosGenerales
                    ) {
                        EmptyView()
                    }
                }
            }
            .sheet(isPresented: $showSelectionDialog) {
                SelectionDialogView { selectedType in
                    showSelectionDialog = false
                    selectedAuditType = selectedType
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigateToDatosGenerales = true
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func shareFile(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}

struct MenuButton: View {
    let title: String
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(.black)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.96, green: 0.88, blue: 0.78))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
