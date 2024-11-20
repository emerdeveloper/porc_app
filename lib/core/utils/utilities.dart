class Utilities {
  static String generateId() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  static String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0'); // Asegura que tenga 2 dígitos
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();

  return '$day-$month-$year';
}
}
