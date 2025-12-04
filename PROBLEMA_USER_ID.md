# Problema: Error de tipo en `user_id` del modelo Restaurant

## Error Reportado
```
Error getting restaurants: type 'int' is not a subtype of type 'String' in type cast
```

## Análisis del Problema

### Estructura de la Base de Datos
Según el esquema de BD proporcionado:
```sql
Table restaurants {
  user_id integer [not null, unique, ref: - users.id]
}
```
El campo `user_id` en la base de datos es de tipo **`integer`**.

### Estructura del Modelo Actual
```dart
final String userId;  // ❌ Espera String

factory Restaurant.fromJson(Map<String, dynamic> json) {
  userId: json['user_id'] as String,  // ❌ Falla si viene como int
}
```

### Causa del Error
La API está devolviendo `user_id` como **`int`** (que es correcto según la BD), pero el modelo Dart intenta hacer un cast directo a **`String`**, lo que causa el error de tipo.

## Solución Implementada

### Cambio en `restaurant_model.dart`
Se modificó el método `fromJson` para manejar ambos casos:
- Si `user_id` viene como `int`: se convierte a `String`
- Si `user_id` viene como `String`: se usa directamente

```dart
userId: (json['user_id'] as num).toString(), // Convierte int/double a String
```

### Manejo de Campos Opcionales
También se agregó manejo para campos que pueden ser `null` en la BD:
- `description` (text - nullable)
- `image_url` (varchar(500) - nullable)
- `latitude` (decimal - nullable)
- `longitude` (decimal - nullable)

## ⚠️ Nota Importante

**Esta puede NO ser la solución definitiva** porque:

1. **Inconsistencia de tipos**: El modelo mantiene `userId` como `String` cuando en la BD es `integer`. Esto puede causar problemas en otras partes del código.

2. **Mejor solución**: Debería evaluarse cambiar el tipo del campo `userId` en el modelo a `int` para que coincida con la BD:
   ```dart
   final int userId;  // ✅ Coincide con la BD
   ```

3. **Impacto del cambio**: Si se cambia a `int`, habría que revisar:
   - Todos los lugares donde se usa `restaurant.userId`
   - Comparaciones con otros `user_id`
   - Serialización a JSON

## Próximos Pasos Recomendados

1. **Verificar la respuesta real de la API**: Agregar logging para ver exactamente qué estructura devuelve `/api/restaurants-complete`

2. **Decidir el tipo correcto**: 
   - Si `userId` debe ser `int`: Cambiar el modelo y actualizar todo el código que lo usa
   - Si `userId` debe ser `String`: Verificar por qué la API devuelve `int` y ajustar el backend o la conversión

3. **Revisar otros modelos**: Verificar si hay otros modelos con el mismo problema (ej: `MenuItem`, `Order`, etc.)

## Logging Agregado

Se agregó logging temporal en `restaurant_repository.dart` para diagnosticar:
- Status code de la respuesta
- Body completo de la respuesta
- Estructura del JSON recibido
- Cantidad de restaurantes parseados

**IMPORTANTE**: Este logging debe removerse después de resolver el problema definitivamente.

