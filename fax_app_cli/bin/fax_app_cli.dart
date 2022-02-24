import 'package:http/http.dart' as http;
import 'user.dart' as u;

void main(List<String> arguments) async {
  var client = http.Client();
  const server = "11stein.com";
  String username = "test_user";
  String password = "testpassword";

  Map userData = {
    "username": username,
    "password": password,
    "server": server,
    "roomIDs": ["hi", "hello"]
  };

  var user = u.User(userData);
  user.login(client);
}
