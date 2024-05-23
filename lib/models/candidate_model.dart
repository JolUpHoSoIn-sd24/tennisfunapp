class CandidateModel {
  final String? id;
  final Map<String, dynamic>? opponent;
  final Map<String, dynamic>? matchDetails;
  final Map<String, dynamic>? court;
  final String? status;
  final String name;
  final String skillLevel;
  final int? age;
  final String? gender;
  bool isPrompt;

  CandidateModel({
    this.id,
    this.opponent,
    this.matchDetails,
    this.court,
    this.status,
    required this.name,
    required this.skillLevel,
    this.age,
    this.gender,
    this.isPrompt = false,
  });
}
