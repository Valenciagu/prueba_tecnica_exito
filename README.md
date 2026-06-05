# Prueba técnica

## Cómo correr el proyecto

1. Clona el repositorio
2. Ejecuta `flutter pub get`
3. Para Android: `flutter run`
4. Para Web: `flutter run -d chrome`

## Configuración adicional

- Requiere conexión a internet (consume fakestoreapi.com)
- El switcher express es visible únicamente entre 10:00 AM y 4:00 PM

## Decisiones técnicas

- **Provider**: usado para gestión de estado del carrito
- **GoRouter**: navegación declarativa con parámetros en URL
- **Dos carritos independientes**: normal y express, se alternan según el switch