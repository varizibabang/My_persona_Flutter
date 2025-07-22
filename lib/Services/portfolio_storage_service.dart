import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:path_provider/path_provider.dart';
class PortfolioStorageService {
  static const String _fileName = 'portfolio.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<List<Map<String, dynamic>>> readPortfolioItems() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        // If file doesn't exist, return an empty list
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      // If any error occurs (e.g., file corruption), return an empty list
      debugPrint('Error reading portfolio items: $e');
      return [];
    }
  }

  Future<File> writePortfolioItems(List<Map<String, dynamic>> items) async {
    final file = await _localFile;
    final String jsonString = json.encode(items);
    return file.writeAsString(jsonString);
  }

  Future<void> deletePortfolioItem(int id) async {
    List<Map<String, dynamic>> currentItems = await readPortfolioItems();
    currentItems.removeWhere((item) => item['id'] == id);
    await writePortfolioItems(currentItems);
  }
}
