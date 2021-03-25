class Resp {
  final bool success;
  final String ecode;
  final Map<String, dynamic> data;

  Resp({this.success, this.ecode, this.data});

  factory Resp.fromJson(Map<String, dynamic> json) {
    if (json['success'] == true) {
      return Resp(
        success: json['success'],
        ecode: json['ecode'],
        data: json['data'],
      );
    } else {
      return Resp(
        success: json['success'],
        ecode: json['ecode'],
        data: null,
      );
    }
  }
}