// Picks the browser download on web and the system share sheet everywhere else.
export 'file_export_io.dart' if (dart.library.js_interop) 'file_export_web.dart';
