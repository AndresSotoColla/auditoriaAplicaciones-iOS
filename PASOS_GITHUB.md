# Instrucciones para Obtener el Archivo .IPA con GitHub Actions (Gratis sin Mac)

Esta carpeta ya contiene **todos los archivos y la configuración automática de GitHub Actions** (`.github/workflows/build_ios.yml`).

Sigue estos **4 sencillos pasos** para compilar la app en la nube de GitHub y descargar tu archivo `.ipa`:

---

### Paso 1: Crear un Repositorio en GitHub
1. Entra a [GitHub.com](https://github.com) e inicia sesión (o crea una cuenta gratuita).
2. Haz clic en el botón **New** (Nuevo Repositorio).
3. Escribe un nombre como `auditoriaAplicaciones-iOS`.
4. Elige si deseas que sea **Público** o **Privado**.
5. Haz clic en **Create repository**.

---

### Paso 2: Subir esta Carpeta a GitHub
Elige la opción que prefieras:

#### Opción A: Usar GitHub Desktop (Fácil sin comandos)
1. Abre [GitHub Desktop](https://desktop.github.com/).
2. Arrastra esta carpeta (`C:\Users\sotoc\Downloads\auditoriaAplicaciones_iOS`) a la aplicación.
3. Haz clic en **Publish repository** para subirlo a tu cuenta.

#### Opción B: Usar Git desde la Consola
Abre la consola en esta carpeta y ejecuta:
```bash
git init
git add .
git commit -m "Initial iOS SwiftUI commit"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/auditoriaAplicaciones-iOS.git
git push -u origin main
```

---

### Paso 3: Observar la Compilación Automática
1. Al subir los archivos, entra a tu repositorio en GitHub.com.
2. Haz clic en la pestaña **Actions** en la parte superior.
3. Verás la ejecución en tiempo real llamada **"Compilar iOS App (GitHub Actions)"**.
4. GitHub asignará automáticamente una computadora Mac en la nube (`macos-14`), compilará el proyecto Xcode y empaquetará el archivo `.ipa` en **aproximadamente 2-3 minutos**.

---

### Paso 4: Descargar tu Archivo `.ipa`
1. Cuando la compilación muestre un check verde (✓ **Success**), haz clic sobre la compilación.
2. Ve a la parte inferior en la sección **Artifacts** (Artefactos).
3. Haz clic en **`auditoriaAplicaciones-iOS-IPA`** para descargar el archivo zip que contiene el `.ipa` de la aplicación de iPhone.

¡Listo! Ya tienes el instalador nativo de iOS generado en la nube sin necesidad de tener una Mac física.
