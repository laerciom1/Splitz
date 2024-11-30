import 'package:gsheets/gsheets.dart';
import 'package:splitz/gsheets_credentials.dart';

const _sheetId = String.fromEnvironment('GSHEETS_SHEET_ID');

abstract class GSheetsRepository {
  static GSheets? _gsheetsClient;
  static Spreadsheet? _spreadsheetClient;
  static GSheets get _gsheets {
    if (_gsheetsClient != null) return _gsheetsClient!;
    _gsheetsClient = GSheets(gsheetCredentials);
    return _gsheetsClient!;
  }

  static Future<Spreadsheet> get _spreadsheet async {
    if (_spreadsheetClient != null) return _spreadsheetClient!;
    final gsheets = _gsheets;
    _spreadsheetClient = await gsheets.spreadsheet(_sheetId);
    return _spreadsheetClient!;
  }

  static Future<void> recreate(
    String sheetTitle,
    List<List<String>> columns,
  ) async {
    final spreadsheet = await _spreadsheet;
    var sheet = spreadsheet.worksheetByTitle(sheetTitle);
    sheet ??= await spreadsheet.addWorksheet(sheetTitle);
    await sheet.clear();
    for (final entry in columns.asMap().entries) {
      final idx = entry.key;
      final column = entry.value;
      if (column.isEmpty) continue;
      await sheet.values.insertColumn(idx + 1, column);
    }
  }
}
