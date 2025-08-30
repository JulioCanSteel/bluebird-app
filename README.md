# 🐦 Bluebird App

<div align="center">
  <img src="assets/images/birdblue.png" alt="Bluebird Logo" width="120" height="120">
  
  **Una aplicación Flutter moderna con sistema de autenticación y diseño responsive**
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
  
</div>

---

## 📱 Descripción

Bluebird App es una aplicación móvil desarrollada en Flutter que presenta un sistema completo de autenticación con un diseño moderno y atractivo. La aplicación incluye pantallas de bienvenida, inicio de sesión, registro, recuperación de contraseña y verificación por código.

## ✨ Características Principales

- 🎨 **Diseño Moderno**: Interfaz elegante con tema Bluebird Soft
- 📱 **Totalmente Responsive**: Se adapta a cualquier tamaño de pantalla
- 🔐 **Sistema de Autenticación**: Login, registro y recuperación de contraseña
- ✅ **Validación en Tiempo Real**: Formularios con validación inteligente
- 🎯 **Navegación Fluida**: Transiciones suaves entre pantallas
- 🐦 **Widget Personalizado**: Pájaro azul como mascota de la aplicación
- 🔄 **Estados de Carga**: Feedback visual durante las operaciones
- 🎭 **Animaciones**: Elementos interactivos y animados

## 🏗️ Pantallas Incluidas

| Pantalla | Descripción | Estado |
|----------|-------------|---------|
| **Welcome Screen** | Pantalla de bienvenida con navegación inicial | ✅ Completado |
| **Login Screen** | Autenticación de usuarios existentes | ✅ Completado |
| **Register Screen** | Registro de nuevos usuarios | ✅ Completado |
| **Forgot Password** | Recuperación de contraseña | ✅ Completado |
| **Verification Screen** | Verificación por código de 6 dígitos | ✅ Completado |

## 🚀 Instalación y Configuración

### Prerrequisitos

Asegúrate de tener instalado:

- **Flutter SDK** (>=3.0.0)
- **Dart SDK** (>=2.17.0)
- **Android Studio** o **VS Code**
- **Emulador Android/iOS** o dispositivo físico

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/EsveBavi/bluebird-app.git
   ```

2. **Navegar al directorio del proyecto**
   ```bash
   cd bluebird-app
   ```

3. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

4. **Verificar configuración de Flutter**
   ```bash
   flutter doctor
   ```

5. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📁 Estructura del Proyecto

```
lib/
├── constants/              # Constantes y configuración
│   └── app_constants.dart   # Colores, textos y valores constantes
├── screens/                # Pantallas de la aplicación
│   ├── welcome_screen.dart      # Pantalla de bienvenida
│   ├── login_screen.dart        # Pantalla de inicio de sesión
│   ├── register_screen.dart     # Pantalla de registro
│   ├── forgot_password_screen.dart # Recuperación de contraseña
│   └── verification_screen.dart    # Verificación por código
├── widgets/                # Componentes reutilizables
│   ├── custom_button.dart       # Botón personalizado
│   ├── custom_text_field.dart   # Campo de texto personalizado
│   └── bird_widget.dart         # Widget del pájaro mascota
├── utils/                  # Utilidades y helpers
│   └── validators.dart          # Validaciones de formularios
└── main.dart              # Archivo principal de la aplicación

assets/
└── images/
    └── birdblue.png       # Imagen del pájaro mascota
```

## 🎨 Personalización

### Modificar Colores

Los colores principales se encuentran en `lib/constants/app_constants.dart`:

```dart
class AppConstants {
  static const Color primaryBlue = Color(0xFF4C6EF5);      // Azul principal
  static const Color backgroundColor = Color(0xFF1A202C);   // Fondo oscuro
  static const Color cardColor = Color(0xFF2D3748);        // Tarjetas
  // ... más colores
}
```

### Cambiar Textos

Todos los textos están centralizados en la misma clase:

```dart
static const String appName = "Bluebird Soft";
static const String welcomeTitle = "Bienvenido a Bluebird Soft";
// ... más textos
```

### Personalizar Fuentes

En `pubspec.yaml` puedes agregar fuentes personalizadas:

```yaml
fonts:
  - family: Poppins
    fonts:
      - asset: fonts/Poppins-Regular.ttf
      - asset: fonts/Poppins-Bold.ttf
        weight: 700
```

## 🛠️ Tecnologías Utilizadas

- **[Flutter](https://flutter.dev/)** - Framework de desarrollo móvil
- **[Dart](https://dart.dev/)** - Lenguaje de programación
- **[Material Design](https://material.io/)** - Sistema de diseño de Google

## 📚 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## 🎯 Funcionalidades Implementadas

### ✅ Validación de Formularios
- Validación de email con regex
- Validación de contraseñas seguras
- Confirmación de contraseñas coincidentes
- Códigos de verificación numéricos

### ✅ Navegación
- Navegación entre pantallas con `Navigator`
- Transiciones fluidas
- Manejo del stack de navegación

### ✅ Responsive Design
- Adapta el tamaño de elementos según el dispositivo
- Soporte para tablets y teléfonos
- Textos y espaciados escalables

### ✅ Estados de UI
- Estados de carga con spinners
- Manejo de errores con mensajes
- Feedback visual para el usuario

## 📱 Capturas de Pantalla

> **Nota**: Agrega capturas de pantalla de tu aplicación en una carpeta `screenshots/` y descomenta las siguientes líneas:

<!--
<div align="center">
  <img src="screenshots/welcome_screen.png" width="250" alt="Pantalla de Bienvenida" />
  <img src="screenshots/login_screen.png" width="250" alt="Pantalla de Login" />
  <img src="screenshots/register_screen.png" width="250" alt="Pantalla de Registro" />
</div>

<div align="center">
  <img src="screenshots/forgot_password_screen.png" width="250" alt="Recuperar Contraseña" />
  <img src="screenshots/verification_screen.png" width="250" alt="Verificación" />
</div>
-->

## 🚧 Próximas Funcionalidades

- [ ] Integración con backend/API
- [ ] Autenticación con Firebase
- [ ] Base de datos local con SQLite
- [ ] Push notifications
- [ ] Perfil de usuario
- [ ] Configuraciones de la aplicación
- [ ] Modo oscuro/claro
- [ ] Internacionalización (i18n)
- [ ] Tests unitarios y de integración
- [ ] Animaciones avanzadas

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si quieres mejorar este proyecto:

1. **Fork** el proyecto
2. Crea una **rama** para tu funcionalidad (`git checkout -b feature/NuevaFuncionalidad`)
3. **Commit** tus cambios (`git commit -m '✨ Agregar nueva funcionalidad'`)
4. **Push** a la rama (`git push origin feature/NuevaFuncionalidad`)
5. Abre un **Pull Request**

### Convenciones de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

- `✨ feat:` nueva funcionalidad
- `🐛 fix:` corrección de errores
- `📝 docs:` documentación
- `💄 style:` cambios de estilo/formato
- `♻️ refactor:` refactorización de código
- `🎨 ui:` mejoras de interfaz
- `⚡ perf:` mejoras de rendimiento
- `✅ test:` agregar o corregir tests

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

```
MIT License

Copyright (c) 2024 EsveBavi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 👤 Autor

**EsveBavi**
- GitHub: [@EsveBavi](https://github.com/EsveBavi)
- Proyecto: [bluebird-app](https://github.com/EsveBavi/bluebird-app)

## 🙏 Agradecimientos

- Al equipo de [Flutter](https://flutter.dev/) por este increíble framework
- A la comunidad de [Dart](https://dart.dev/) por el excelente lenguaje
- A [Material Design](https://material.io/) por las guías de diseño
- A todos los desarrolladores que contribuyen con código abierto

---

<div align="center">
  <p>Hecho con ❤️ usando Flutter</p>
  
  **¡Si este proyecto te ayudó, dale una ⭐️!**
  
  <a href="https://github.com/EsveBavi/bluebird-app/stargazers">
    <img src="https://img.shields.io/github/stars/EsveBavi/bluebird-app?style=social" alt="Estrellas en GitHub">
  </a>
</div>
