import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('User')
          .where('user_id', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      
      if (userData['user_password'] != password) {
        return null;
      }

      return UserModel.fromFirestore(userData);
    } catch (e) {
      rethrow;
    }
  }
}
