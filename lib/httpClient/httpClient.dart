import 'dart:io';

class HttpClientFireBase {
  late HttpClient client;

  HttpClientFireBase() {
    client = HttpClient();
  }

  dynamic get({url}) async {
    HttpClientResponse response = await client
        .getUrl(Uri.parse(url))
        .then((HttpClientRequest request) {
      return request.close();
    });
    return response;
  }

  put({body, url}) {
    client.putUrl(Uri.parse(url)).then((HttpClientRequest request) {
      request.write(body);
      return request.close();
    }).then((HttpClientResponse response) {
      return response;
    });
  }

  post({body, url}) {
    client.postUrl(Uri.parse(url)).then((HttpClientRequest request) {
      request.write(body);
      return request.close();
    }).then((HttpClientResponse response) {
      return response;
    });
  }
}
