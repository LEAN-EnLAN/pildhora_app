# Pildhora App - Pastillero Inteligente

La aplicación Pildhora es un asistente de salud móvil diseñado para ayudar a pacientes y cuidadores a gestionar tratamientos médicos de forma sencilla y eficaz. La app se conecta con un pastillero inteligente (basado en ESP32) para automatizar y supervisar la toma de medicamentos.

Esta es la **V1 Estable**, que incluye las funcionalidades esenciales para una gestión completa del tratamiento por parte de un usuario.

## Características Principales (V1)

- **Gestión de Medicamentos**: Añade, edita y elimina medicamentos con detalles como nombre, dosis y hora de toma.
- **Persistencia de Datos**: Toda la información se guarda en una base de datos local en el dispositivo, asegurando que los datos no se pierdan al cerrar la app.
- **Seguimiento de Tomas (Adherencia)**: Permite marcar las tomas de medicamentos, guardando un historial detallado para consulta del paciente o del cuidador.
- **Notificaciones Locales**: Envía recordatorios puntuales para cada toma programada, ayudando al paciente a no olvidar sus medicamentos.
- **Perfiles de Usuario**: Sistema dual con vistas y funcionalidades diferenciadas para **Pacientes** y **Cuidadores**.
- **Panel de Paciente**: Muestra un widget con el "Próximo Medicamento" para un acceso rápido a la información más relevante.
- **Panel de Cuidador**: Ofrece un resumen de los pacientes a cargo para una supervisión sencilla.

## Estructura del Proyecto

El código fuente está organizado en los siguientes directorios principales dentro de `lib/`:

- `models/`: Contiene las clases que modelan los datos de la aplicación (ej. `Medication`, `UserProfile`).
- `providers/`: Gestiona el estado de la aplicación utilizando el paquete `flutter_riverpod`.
- `screens/`: Contiene todas las pantallas o vistas de la interfaz de usuario.
- `services/`: Agrupa la lógica de negocio y de acceso a datos, como la gestión de la base de datos (`database_service.dart`) y las notificaciones (`notification_service.dart`).
- `widgets/`: (Opcional) Para widgets reutilizables en varias partes de la aplicación.

## Cómo Empezar

Para ejecutar este proyecto, necesitarás tener Flutter instalado en tu máquina.

1.  **Clona el repositorio:**
    ```sh
    git clone <URL_DEL_REPOSITORIO>
    cd pildhora_app
    ```

2.  **Instala las dependencias:**
    ```sh
    flutter pub get
    ```

3.  **Ejecuta la aplicación:**
    ```sh
    flutter run
    ```

## Próximos Pasos

La V1 sienta las bases para futuras mejoras, como:

- Integración con un backend en la nube (ej. Firebase) para sincronización de datos.
- Autenticación de usuarios real.
- Conexión por Bluetooth con el dispositivo de hardware (ESP32).