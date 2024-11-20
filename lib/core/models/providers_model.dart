import 'dart:convert';

class ProviderModel {
  final String? id;
  final String name;
  final String owner;
  final List<PigFeedModel> pigFeed;

  ProviderModel({
    required this.id,
    required this.name,
    required this.owner,
    required this.pigFeed,
  });

  // Método para convertir un ProviderModel a mapa (para Firestore o JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'owner': owner,
      'pigFeed': pigFeed.map((feed) => feed.toMap()).toList(),
    };
  }

  // Factory para crear un ProviderModel desde un mapa (Firestore o JSON)
  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      id: map['id'] != null ? map['uid'] as String : null,
      name: map['name'] as String,
      owner: map['owner'] as String,
      pigFeed: (map['pigFeed'] as List<dynamic>)
          .map((feed) => PigFeedModel.fromMap(feed as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProviderModel.fromJson(String source) =>
      ProviderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProviderModel(id: $id, name: $name, owner: $owner, pigFeed: $pigFeed)';
  }
}

class PigFeedModel {
  final String? id;
  final String name;
  final double price;

  PigFeedModel({
    required this.id,
    required this.name,
    required this.price,
  });

  // Método para convertir un PigFeedModel a mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // Factory para crear un PigFeedModel desde un mapa
  factory PigFeedModel.fromMap(Map<String, dynamic> map) {
    return PigFeedModel(
      id: map['id'] != null ? map['uid'] as String : null,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PigFeedModel.fromJson(String source) =>
      PigFeedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PigFeedModel(id: $id, name: $name, price: $price)';
  }
}
