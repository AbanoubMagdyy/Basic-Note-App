class UserInfo {
       String name;
       String birthday;
       String profileImage;

  UserInfo({required this.name, required this.birthday,required this.profileImage});

       Map<String,dynamic> toJson(){
         return {
           'name' :  name,
           'birthday' : birthday,
           'profileImage' : profileImage,
         };
       }

  UserInfo.fromJson(Map<String,dynamic> json) : name = json['name'] , profileImage = json['profileImage'], birthday = json['birthday'];



}