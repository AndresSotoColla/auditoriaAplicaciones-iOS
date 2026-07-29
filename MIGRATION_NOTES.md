# Notas de Migración Android -> iOS (SwiftUI)

## Resumen Ejecutivo
Se realizó la migración completa y nativa del proyecto **AuditoriaAplicaciones** de Android (Kotlin / Jetpack Compose) a **iOS Native** utilizando **SwiftUI**, **Combine**, **Foundation**, **AVKit**, **CoreLocation** y **PDFKit**.

---

## Mapeo de Arquitectura y Tecnologías

| Componente / Funcionalidad | Android (Origen) | iOS (Destino Migrado) | Notas de Implementación |
| :--- | :--- | :--- | :--- |
| **Lenguaje de Programación** | Kotlin 1.9 | Swift 5.9 | Conversión 1:1 de data classes y lógica de negocio. |
| **UI Framework** | Jetpack Compose (Material3) | SwiftUI | Reproducción idéntica del layout, tarjetas, pickers y temas de color. |
| **Persistencia Local** | `SharedPreferences` + `Gson` | `UserDefaults` + `JSONEncoder/JSONDecoder` | Mismas claves y esquemas JSON serializados. |
| **Red & API Sync** | `HttpURLConnection` en corrutinas | `URLSession` asíncrona | Mismo endpoint `http://190.13.174.195:8000/api/auditoria/` y estructura JSON idéntica. |
| **Ubicación GPS** | `FusedLocationProviderClient` | `CoreLocation` (`LocationManager`) | Obtención automática de coordenadas GPS (`lat,long`). |
| **Reproductor de Video** | `AndroidView` con `VideoView` / `ExoPlayer` | `UIViewRepresentable` con `AVQueuePlayer` y `AVPlayerLooper` | Reproducción continua en bucle del video de fondo sin cortes. |
| **Parsing CSV** | `BufferedReader` de `res/raw/datos.csv` | `String(contentsOfFile:)` de `Bundle.main` | Parser línea por línea con tokenizador por punto y coma `;`. |
| **Exportación PDF** | `PdfDocument` nativo de Android | `UIGraphicsPDFRenderer` / `PDFKit` | Reporte formal formateado de Calibración Spray Boom. |
| **Exportación CSV** | Escritura en memoria/Downloads | `FileManager.default.temporaryDirectory` + `UIActivityViewController` | Menú nativo para compartir/guardar archivos. |

---

## Mapeo de Modelos de Datos

- `NozzleData` $ightarrow$ `struct NozzleData: Identifiable, Codable, Hashable, Equatable`
- `ProductoEvaluado` $ightarrow$ `struct ProductoEvaluado: Identifiable, Codable, Hashable, Equatable`
- `CalculoRecorrido` $ightarrow$ `struct CalculoRecorrido: Identifiable, Codable, Hashable, Equatable`
- `InsumoData` $ightarrow$ `struct InsumoData: Identifiable, Codable, Hashable, Equatable`
- `AuditoriaInfo` $ightarrow$ `struct AuditoriaInfo: Identifiable, Codable, Hashable, Equatable`
  - Incluye todas las fórmulas de porcentaje (`getVolumenPercent()`, `getUniformidadPercent()`, `getBoquillasTapadasPercent()`, `getMezclasAguaPercent()`, `getMezclasInsumosPercent()`, `getMezclasDatosGeneralesPercent()`).

---

## Permisos Requeridos en iOS (`Info.plist`)
- `NSLocationWhenInUseUsageDescription`: Coordenadas GPS para auditorías de campo.
- `NSCameraUsageDescription`: Captura de imágenes de evidencia.
- `NSPhotoLibraryUsageDescription`: Guardado de reportes en la fototeca/archivos.
- `NSAppTransportSecurity` -> `NSAllowsArbitraryLoads`: Permitir peticiones HTTP a servidores locales o IP directa.
