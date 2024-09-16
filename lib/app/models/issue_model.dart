class IssueModel {
  final String title;
  final int number;

  IssueModel({required this.title, required this.number});

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      title: json['title'] ?? 'No Title', // Handle null values
      number: json['number'] ?? 0, // Handle null values
    );
  }
}
