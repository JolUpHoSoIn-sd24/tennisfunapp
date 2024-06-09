class Game {
  final String gameId;
  final double rentalCost;
  final List<Player> players;
  final DateTime startTime;
  final String state;
  final DateTime endTime;
  final Court court;
  final Map<String, bool> paymentStatus;

  Game({
    required this.gameId,
    required this.rentalCost,
    required this.players,
    required this.startTime,
    required this.state,
    required this.endTime,
    required this.court,
    required this.paymentStatus,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['gameId'],
      rentalCost: json['rentalCost'],
      players: (json['players'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      startTime: DateTime.parse(json['startTime']),
      state: json['state'],
      endTime: DateTime.parse(json['endTime']),
      court: Court.fromJson(json['court']),
      paymentStatus: Map<String, bool>.from(json['paymentStatus']),
    );
  }
}

class Player {
  final String userId;
  final String name;
  final double ntrp;
  final int age;
  final String gender;
  final bool feedback; // Added feedback attribute

  Player({
    required this.userId,
    required this.name,
    required this.ntrp,
    required this.age,
    required this.gender,
    required this.feedback,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json['userId'],
      name: json['name'],
      ntrp: json['ntrp'],
      age: json['age'],
      gender: json['gender'],
      feedback: json['feedback'],
    );
  }
}

class Court {
  final String courtId;
  final String name;
  final String location;
  final String surfaceType;

  Court({
    required this.courtId,
    required this.name,
    required this.location,
    required this.surfaceType,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      courtId: json['courtId'],
      name: json['name'],
      location: json['location'],
      surfaceType: json['surfaceType'],
    );
  }
}
