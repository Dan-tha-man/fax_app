import 'dart:convert';
import 'package:http/http.dart' as http;

class Requester {
  String server;

  Requester(this.server);

  Future<Map> postRequest(http.Client client, String url,
      {Map? data, Map<String, String>? headers}) async {
    Map decodedResponse;
    http.Response response;
    var jsonData = json.encode(data);
    Uri fullURL = Uri.https(server, url);

    if (headers != null && data != null) {
      response = await client.post(fullURL, body: jsonData, headers: headers);
    } else if (headers == null && data != null) {
      response = await client.post(fullURL, body: jsonData);
    } else if (headers != null && data == null) {
      response = await client.post(fullURL, headers: headers);
    } else {
      response = await client.post(fullURL);
    }

    decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<Map> putRequest(http.Client client, String url,
      {Map? data, Map<String, String>? headers}) async {
    Map decodedResponse;
    http.Response response;
    var jsonData = json.encode(data);
    Uri fullURL = Uri.https(server, url);

    if (headers != null && data != null) {
      response = await client.put(fullURL, body: jsonData, headers: headers);
    } else if (headers == null && data != null) {
      response = await client.put(fullURL, body: jsonData);
    } else if (headers != null && data == null) {
      response = await client.put(fullURL, headers: headers);
    } else {
      response = await client.put(fullURL);
    }

    decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }

  Future<Map> getRequest(http.Client client, String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    Map decodedResponse;
    http.Response response;
    Uri fullURL = Uri.https(server, url);

    if (headers != null && data != null) {
      fullURL = Uri.https(server, url, data);
      response = await client.get(fullURL, headers: headers);
    } else if (headers == null && data != null) {
      fullURL = Uri.https(server, url, data);
      response = await client.get(fullURL);
    } else if (headers != null && data == null) {
      response = await client.get(fullURL, headers: headers);
    } else {
      response = await client.get(fullURL);
    }

    decodedResponse = jsonDecode(response.body);
    return decodedResponse;
  }
}
