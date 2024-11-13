// utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  /// Formatea la fecha de cumpleaños en el formato `dd/MM/yyyy`.
  static String formatBirthday(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Convierte una cadena de texto con el formato `dd/MM/yyyy` a un `DateTime`.
  static DateTime? parseBirthday(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      // Maneja el error si la fecha es inválida
      return null;
    }
  }

  /// Formatea una fecha en un formato más legible, como `1 de Enero de 2023`.
  static String formatLongDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'es').format(date);
  }
}
