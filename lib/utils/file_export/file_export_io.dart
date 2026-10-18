import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:share_plus/share_plus.dart';

/// Opens the share sheet so the user can save the CSV to Files, Drive, e-mail it, etc.
/// [origin] is where the sheet points from on iPad.
Future<void> exportCsvFile(String fileName, String csv, {Rect? origin}) async {
  // The BOM makes Excel read the file as UTF-8, so names like "Müller" stay intact.
  final bytes = Uint8List.fromList(utf8.encode('﻿$csv'));
  await SharePlus.instance.share(ShareParams(
    files: [XFile.fromData(bytes, mimeType: 'text/csv', name: fileName)],
    fileNameOverrides: [fileName],
    sharePositionOrigin: origin,
  ));
}
