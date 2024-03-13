import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthFirebase {
  final auth = FirebaseAuth.instance;

  Future<bool> signUpUser(
      {required name, required String password, required String email}) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        //envia un email para verificar la cuenta del usuario
        userCredential.user!.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInUser(
      {required String password, required String email}) async {
    var band = false;
    final userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      if (userCredential.user!.emailVerified) {
        return band;
      }
    }
    return band;
  }
}
