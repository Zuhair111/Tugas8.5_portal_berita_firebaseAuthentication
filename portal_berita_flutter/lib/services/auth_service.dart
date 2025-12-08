import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = credential.user!;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.uid);
        await prefs.setString('user_name', user.displayName ?? 'User');
        await prefs.setString('user_email', user.email ?? '');
        
        return {
          'success': true, 
          'user': User(
            id: user.uid.hashCode,
            name: user.displayName ?? 'User',
            email: user.email ?? '',
            token: await user.getIdToken() ?? '',
          ),
        };
      } else {
        return {'success': false, 'message': 'Login gagal'};
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Login gagal';
      
      if (e.code == 'user-not-found') {
        message = 'Email tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      } else if (e.code == 'user-disabled') {
        message = 'Akun telah dinonaktifkan';
      } else if (e.code == 'invalid-credential') {
        message = 'Email atau password salah';
      }
      
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
  
  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    try {
      if (password != passwordConfirmation) {
        return {'success': false, 'message': 'Password tidak sama'};
      }

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = credential.user!;
        
        // Update display name
        await user.updateDisplayName(name);
        await user.reload();
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.uid);
        await prefs.setString('user_name', name);
        await prefs.setString('user_email', user.email ?? '');
        
        return {
          'success': true, 
          'user': User(
            id: user.uid.hashCode,
            name: name,
            email: user.email ?? '',
            token: await user.getIdToken() ?? '',
          ),
        };
      } else {
        return {'success': false, 'message': 'Registrasi gagal'};
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Registrasi gagal';
      
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah (minimal 6 karakter)';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      }
      
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error logout: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<String?> getToken() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final user = _firebaseAuth.currentUser;
    
    if (user == null) return null;
    
    return {
      'id': user.uid,
      'name': user.displayName ?? 'User',
      'email': user.email ?? '',
    };
  }

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;
}
