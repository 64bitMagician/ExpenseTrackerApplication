import 'dart:js_interop';
import 'dart:ui';

import 'package:web/web.dart' as web;

/// Downloads the CSV through the browser. [origin] is only used on mobile.
Future<void> exportCsvFile(String fileName, String csv, {Rect? origin}) async {
  // The BOM makes Excel read the file as UTF-8, so names like "Müller" stay intact.
  final blob = web.Blob(
    ['﻿$csv'.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName;
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
