import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserStorageService {
  static const String _userKey = 'current_user';
  static const String _profileKey = 'current_profile';
  static String? _cachedUserId;
  static String? _cachedClienteId;
  static Map<String, dynamic>? _cachedUser;
  static Map<String, dynamic>? _cachedProfile;

  static Future<void> saveUser({
    required Map<String, dynamic> user,
    required Map<String, dynamic> profile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
    await prefs.setString(_profileKey, jsonEncode(profile));

    // Cache
    _cachedUser = user;
    _cachedProfile = profile;
    _cachedUserId = user['id'].toString();
    _cachedClienteId = profile['id'].toString();
  }

  static Future<Map<String, dynamic>?> getUser() async {
    if (_cachedUser != null) return _cachedUser;

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      _cachedUser = jsonDecode(userJson);
      return _cachedUser;
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    if (_cachedProfile != null) return _cachedProfile;

    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);

    if (profileJson != null) {
      _cachedProfile = jsonDecode(profileJson);
      return _cachedProfile;
    }

    return null;
  }

  static Future<int?> getClienteId() async {
    if (_cachedClienteId != null) {
      return int.tryParse(_cachedClienteId!);
    }

    final profile = await getProfile();
    if (profile != null && profile['id'] != null) {
      _cachedClienteId = profile['id'].toString();
      return profile['id'];
    }

    return null;
  }

  static Future<int?> getUserId() async {
    if (_cachedUserId != null) {
      return int.tryParse(_cachedUserId!);
    }

    final user = await getUser();
    if (user != null && user['id'] != null) {
      _cachedUserId = user['id'].toString();
      return user['id'];
    }

    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_profileKey);

    _cachedUser = null;
    _cachedProfile = null;
    _cachedUserId = null;
    _cachedClienteId = null;
  }
}
