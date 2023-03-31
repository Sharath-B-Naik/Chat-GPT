import 'dart:convert';

import 'package:chat_gpt/models/favourite_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final storage = SharedPreferences.getInstance();

  static const String bucketKey = "favourite_bucket";

  static Future<bool> savefavourite(FavouriteModel value) async {
    final bucket = await storage;
    List<String> favourites = [];

    final result = bucket.getStringList(bucketKey);
    if (result != null) favourites.addAll(result);
    favourites.add(json.encode(value.toMap()));
    bucket.setStringList(bucketKey, favourites);
    return true;
  }

  static Future<List<FavouriteModel>> getfavourites() async {
    final bucket = await storage;
    final result = bucket.getStringList(bucketKey);
    if (result == null) return [];

    List<FavouriteModel> favourites = [];
    for (final element in result) {
      favourites.add(FavouriteModel.fromMap(json.decode(element)));
    }

    return favourites;
  }

  static Future<List<FavouriteModel>> deletefavourite(FavouriteModel item) async {
    final bucket = await storage;
    final result = bucket.getStringList(bucketKey);
    if (result == null) return [];

    List<FavouriteModel> favourites = [];
    result.removeWhere((element) {
      final re = FavouriteModel.fromMap(json.decode(element));
      return re.createdAt == item.createdAt;
    });
    bucket.setStringList(bucketKey, result);
    return favourites;
  }

  static Future<void> clear() async {
    final bucket = await storage;
    bucket.clear();
  }
}
