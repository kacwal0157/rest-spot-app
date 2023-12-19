class BrowserImageStorage {
  final Map<String, String> images = <String, String>{};

  String getImageBase64(String key) {
    return images[key]!;
  }

  void setItem(String key, String value) {
    images[key] = value;
  }
}
