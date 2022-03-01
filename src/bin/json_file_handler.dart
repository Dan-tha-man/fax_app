import 'dart:io';
import 'dart:convert';

mixin JsonFileHandler {
  void write(String path, Map data) {
    const JsonEncoder json = JsonEncoder.withIndent('    ');
    File jsonFile = File(path);
    jsonFile.writeAsString(json.convert(data));
  }
}
