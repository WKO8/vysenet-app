import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerUser({
    required String email, 
    required String password
  }) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  signIn({
    required String email, 
    required String password
  }) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user?.uid != null) return true;
    return false; 
  }

  signOut() async {
    await _firebaseAuth.signOut();
  }
}
