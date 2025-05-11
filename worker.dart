class Worker {
  String? iD;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;

  Worker(
  {
    this.iD,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.address,
  });
   Worker.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    name = json['full_name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = iD;
    data['full_name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}
