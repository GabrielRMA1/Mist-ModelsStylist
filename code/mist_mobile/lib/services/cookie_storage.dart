import 'package:shared_preferences/shared_preferences.dart';

class CookieStorage {
  static const _cookieKey = 'auth_cookie';

  Future<void> saveFromSetCookie(String? setCookieHeader) async {
    if (setCookieHeader == null || setCookieHeader.isEmpty) return;

    final cookie = setCookieHeader.split(';').first.trim();
    if (cookie.isEmpty) return;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_cookieKey, cookie);
  }

  Future<String?> getCookie() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_cookieKey);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_cookieKey);
  }
}
