
class ResponseModel{
  late  bool _isSuccess;
  late  String _message;
  ResponseModel(this._isSuccess,this._message);
  bool get isSuccess=> _isSuccess;
  String get message => _message;
  ResponseModel.fromJson(Map json){
    _isSuccess = json['success'];
    _message = json['message'];
  }
}