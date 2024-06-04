class User {
  final String id;
  final String name;
  final String emailId;
  final int age;
  final String gender;
  final Location location;
  final double maxDistance;
  final List<String> dislikedCourts;
  final double ntrp;
  final double mannerScore;
  final List<String>? clubIds;
  final bool emailVerified;

  User({
    required this.id,
    required this.name,
    required this.emailId,
    required this.age,
    required this.gender,
    required this.location,
    required this.maxDistance,
    required this.dislikedCourts,
    required this.ntrp,
    required this.mannerScore,
    this.clubIds,
    required this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      emailId: json['emailId'],
      age: json['age'],
      gender: json['gender'],
      location: Location.fromJson(json['location']),
      maxDistance: json['maxDistance'].toDouble(),
      dislikedCourts: List<String>.from(json['dislikedCourts']),
      ntrp: json['ntrp'].toDouble(),
      mannerScore: json['mannerScore'].toDouble(),
      clubIds:
          json['clubIds'] != null ? List<String>.from(json['clubIds']) : null,
      emailVerified: json['emailVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emailId': emailId,
      'age': age,
      'gender': gender,
      'location': location.toJson(),
      'maxDistance': maxDistance,
      'dislikedCourts': dislikedCourts,
      'ntrp': ntrp,
      'mannerScore': mannerScore,
      'clubIds': clubIds,
      'emailVerified': emailVerified,
    };
  }
}

class Location {
  final double x;
  final double y;

  Location({
    required this.x,
    required this.y,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}
