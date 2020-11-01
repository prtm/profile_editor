import 'dart:async';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

Future<Uint8List> getBlobData(html.Blob blob) {
  final completer = Completer<Uint8List>();
  final reader = html.FileReader();
  reader.readAsArrayBuffer(blob);
  reader.onLoad.listen((_) => completer.complete(reader.result));
  return completer.future;
}
