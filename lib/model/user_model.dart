class UserModel{
  String? name;
  String? phone;
  String? age;
  String? email;
  String? uid;

  UserModel({this.name, this.phone, this.age, this.email, this.uid});

  factory UserModel.fromMap(map){
    return UserModel(
        name: map['name'],
        phone: map['phone'],
        age: map['age'],
        email: map['email'],
        uid: map['uid']
    );
  }
  Map<String , dynamic> toMap(){
    return{
      'uid': uid,
      'name': name,
      'phone': phone,
      'age': age,
      'email': email,

    };
  }
}