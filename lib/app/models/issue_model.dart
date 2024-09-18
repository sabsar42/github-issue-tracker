class IssueModel {
  final String? title;
  final String? body;
  final String state;
  final List<String>? labels;

  IssueModel({
    this.title,
    this.body,
    required this.state,
    this.labels,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    var labelsList = json['labels'] as List<dynamic>?;
    List<String>? labels = labelsList?.map((label) => label['name'] as String).toList();

    return IssueModel(
      title: json['title'] as String?,
      body: json['body'] as String?,
      state: json['state'] as String? ?? 'unknown',
      labels: labels,
    );
  }
}
