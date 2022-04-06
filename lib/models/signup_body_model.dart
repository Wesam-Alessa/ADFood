class SignUpBody {
  String name;

  String password;

  String email;

  String phone;

  SignUpBody({
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
  });

  Map<String,dynamic> tojson(){
    final Map<String,dynamic> data = {};
    data['f_name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
