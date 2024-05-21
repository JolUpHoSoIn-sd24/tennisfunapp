class CandidateModel {
  final String name;
  final String skillLevel;
  bool isPrompt;

  CandidateModel(
      {required this.name, required this.skillLevel, this.isPrompt = false});
}
