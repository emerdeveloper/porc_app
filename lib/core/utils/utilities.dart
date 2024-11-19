class Utilities {
  static String generateId() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }
}
