class IssueModel {
  final String? title; // Nullable title
  final String? body;  // Nullable body
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
      state: json['state'] as String? ?? 'unknown', // Provide a default value if needed
    );
  }
}
