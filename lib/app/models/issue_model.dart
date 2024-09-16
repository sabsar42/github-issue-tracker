class IssueModel {
  final String? title;
  final String? body;
  final String state;

  IssueModel({
    this.title,
    this.body,
    required this.state,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      title: json['title'] as String?,
      body: json['body'] as String?,
      state: json['state'] as String? ?? 'unknown',
    );
  }
}