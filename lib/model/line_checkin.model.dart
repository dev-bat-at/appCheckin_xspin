class LineCheckin {
  final String idLineCheckin;
  final String tenLine;

  LineCheckin({
    required this.idLineCheckin,
    required this.tenLine,
  });

  factory LineCheckin.fromJson(Map<String, dynamic> json) {
    return LineCheckin(
      idLineCheckin: json['idLineCheckin']?.toString() ?? '',
      tenLine: json['TenLine']?.toString() ?? '',
    );
  }
}
