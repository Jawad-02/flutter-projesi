import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

class HttpClientService {
  static Future<String> getString(String url) async {
    final response = await HttpRequest.getString(url);
    return response;
  }

  static Future<Uint8List> getBytes(String url) async {
    final completer = Completer<Uint8List>();
    final request = HttpRequest();
    request.open('GET', url);
    request.responseType = 'arraybuffer';
    request.onLoad.listen((_) {
      if (request.status == 200) {
        final bytes = (request.response as ByteBuffer).asUint8List();
        completer.complete(bytes);
      } else {
        completer.completeError(Exception('HTTP ${request.status}'));
      }
    });
    request.onError.listen((_) {
      completer.completeError(Exception('Network error'));
    });
    request.send();
    return completer.future;
  }
}
