import 'dart:convert';
import 'package:http/http.dart' as http;

class Requester {
  String server;

  Requester(this.server);

  post(http.Client client, String url,
      {Map? data, Map<String, String>? headers}) async {
    Map decodedResponse;
    http.Response response;
    var jsonData = json.encode(data);

    if (headers != null && data != null) {
      response = await client.post(Uri.https(server, url),
          body: jsonData, headers: headers);
    } else if (headers == null && data != null) {
      response = await client.post(Uri.https(server, url), body: jsonData);
    } else if (headers != null && data == null) {
      response = await client.post(Uri.https(server, url), headers: headers);
    } else {
      response = await client.post(Uri.https(server, url));
    }

    decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  put(http.Client client, String url,
      {Map? data, Map<String, String>? headers}) async {
    Map decodedResponse;
    http.Response response;
    var jsonData = json.encode(data);

    if (headers != null && data != null) {
      response = await client.put(Uri.https(server, url),
          body: jsonData, headers: headers);
    } else if (headers == null && data != null) {
      response = await client.put(Uri.https(server, url), body: jsonData);
    } else if (headers != null && data == null) {
      response = await client.put(Uri.https(server, url), headers: headers);
    } else {
      response = await client.put(Uri.https(server, url));
    }

    decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  get(http.Client client, String url, {Map<String, String>? headers}) async {
    Map decodedResponse;
    http.Response response;

    if (headers == null) {
      response = await client.get(Uri.https(server, url));
    } else {
      response = await client.get(Uri.https(server, url), headers: headers);
    }

    decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}
