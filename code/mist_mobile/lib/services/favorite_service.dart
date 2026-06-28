import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const _favoriteStylistsKey = 'favorite_stylist_ids';

  Future<List<int>> getFavoriteStylistIds() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences
        .getStringList(_favoriteStylistsKey)
        ?.map(int.parse)
        .toList() ??
        [];
  }

  Future<bool> isFavorite(int stylistId) async {
    final ids = await getFavoriteStylistIds();
    return ids.contains(stylistId);
  }

  Future<bool> toggleFavorite(int stylistId) async {
    final preferences = await SharedPreferences.getInstance();
    final ids = await getFavoriteStylistIds();
    var isFavorite = false;

    if (ids.contains(stylistId)) {
      ids.remove(stylistId);
    } else {
      ids.add(stylistId);
      isFavorite = true;
    }

    await preferences.setStringList(
      _favoriteStylistsKey,
      ids.map((id) => id.toString()).toList(),
    );

    return isFavorite;
  }
}
