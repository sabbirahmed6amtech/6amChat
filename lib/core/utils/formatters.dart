class Formatters {
  static String getInitials(String name) {
    final parts = name.split(' ');
    return parts.map((p) => p[0]).join('').toUpperCase();
  }

  static String truncate(String text, int length) {
    return text.length > length ? '${text.substring(0, length)}...' : text;
  }
}
