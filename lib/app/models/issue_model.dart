class IssueModel {
  final String? title;
  final String? body;
  final String state;
  final List<String>? labels; // Add labels field

  IssueModel({
    this.title,
    this.body,
    required this.state,
    this.labels,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    var labelsList = json['labels'] as List<dynamic>?; // Adjust based on actual structure
    List<String>? labels = labelsList?.map((label) => label['name'] as String).toList();

    return IssueModel(
      title: json['title'] as String?,
      body: json['body'] as String?,
      state: json['state'] as String? ?? 'unknown',
      labels: labels,
    );
  }
}
