class Student {
  String? name;
  String? address;
  int? contact;
  String? gender;
  String? password;
  String? confirmPassword;
  String? role;
  String? id;

  Student(
      {this.name,
      this.role,
      this.id,
      this.address,
      this.contact,
      this.gender,
      this.password,
      this.confirmPassword});

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    id = json['id'];
    role = json['role'];
    contact = json['contact'];
    gender = json['gender'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['id'] = this.id;
    data['role'] = this.role;
    data['contact'] = this.contact;
    data['gender'] = this.gender;
    data['password'] = this.password;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}
