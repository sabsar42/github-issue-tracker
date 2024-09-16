class IssueModel {
  final int id;
  final String title;
  final String body;
  final String state; // e.g., "open" or "closed"

  IssueModel({
    required this.id,
    required this.title,
    required this.body,
    required this.state,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      state: json['state'],
    );
  }
}
