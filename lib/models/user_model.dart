class UserModel {
  final String parentName;
  final String userAddress;
  final int userAge;
  final String userBg;
  final String userGender;
  final String userId;
  final String userMobile;
  final String userName;
  final String userPassword;
  final String userStd;
  final String userType;

  UserModel({
    required this.parentName,
    required this.userAddress,
    required this.userAge,
    required this.userBg,
    required this.userGender,
    required this.userId,
    required this.userMobile,
    required this.userName,
    required this.userPassword,
    required this.userStd,
    required this.userType,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      parentName: data['parent_name'] ?? '',
      userAddress: data['user_address'] ?? '',
      userAge: data['user_age'] ?? 0,
      userBg: data['user_bg'] ?? '',
      userGender: data['user_gender'] ?? '',
      userId: data['user_id'] ?? '',
      userMobile: data['user_mobile'] ?? '',
      userName: data['user_name'] ?? '',
      userPassword: data['user_password'] ?? '',
      userStd: data['user_std'] ?? '',
      userType: data['user_type'] ?? '',
    );
  }
}
