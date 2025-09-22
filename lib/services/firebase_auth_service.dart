// lib/services/firebase_auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // IMPORTANTE: usa la misma región donde desplegaste las Functions
  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ===================================
  // AUTENTICACIÓN TRADICIONAL (OTP)
  // ===================================

  // Registro con email y contraseña
  Future<Map<String, dynamic>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final emailNormalized = email.trim().toLowerCase();
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: emailNormalized,
        password: password,
      );

      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': emailNormalized,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
      });

      final callable = _functions.httpsCallable('requestEmailOtp');
      await callable.call({'email': emailNormalized});

      return {
        'success': true,
        'user': result.user,
        'message': 'Usuario registrado exitosamente. Te enviamos un código.'
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Error al registrar usuario';
      switch (e.code) {
        case 'weak-password':
          message = 'La contraseña es muy débil';
          break;
        case 'email-already-in-use':
          message = 'El email ya está registrado';
          break;
        case 'invalid-email':
          message = 'Email inválido';
          break;
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  // Login con email y contraseña
  Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'user': result.user,
        'message': 'Inicio de sesión exitoso'
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Error al iniciar sesión';
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no encontrado';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta';
          break;
        case 'invalid-email':
          message = 'Email inválido';
          break;
        case 'user-disabled':
          message = 'Usuario deshabilitado';
          break;
        case 'too-many-requests':
          message = 'Demasiados intentos. Intenta más tarde';
          break;
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
  
  // Método para verificar el código de 4 dígitos del email (OTP)
  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final callable = _functions.httpsCallable('verifyEmailOtp');
      await callable.call({'email': email, 'code': code});
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } on FirebaseFunctionsException {
      rethrow;
    } catch (e) {
      throw FirebaseFunctionsException(code: 'unknown', message: e.toString());
    }
  }

  // Método para reenviar el OTP de email
  Future<Map<String, dynamic>> resendEmailOtp(String email) async {
    try {
      final callable = _functions.httpsCallable('requestEmailOtp');
      final result = await callable.call({'email': email});
      return {'success': true, 'message': result.data['message'] ?? 'Código reenviado.'};
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': _mapFunctionsError(e)};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===================================
  // AUTENTICACIÓN CON GOOGLE
  // ===================================

  // Login con Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {'success': false, 'message': 'Inicio de sesión de Google cancelado'};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'displayName': userCredential.user!.displayName,
          'photoUrl': userCredential.user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': true,
        });
      }

      return {'success': true, 'message': 'Inicio de sesión con Google exitoso'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===================================
  // RESTABLECIMIENTO DE CONTRASEÑA (OTP)
  // ===================================

  Future<Map<String, dynamic>> requestPasswordResetOtp(String email) async {
    try {
      final callable = _functions.httpsCallable('requestPasswordResetOtp');
      await callable.call({'email': email.trim().toLowerCase()});
      return {'success': true, 'message': 'Te enviamos un código a tu correo.'};
    } on FirebaseFunctionsException catch (e) {
      final msg = _mapFunctionsError(e);
      return {'success': false, 'message': msg};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> resetPasswordWithOtp({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final callable = _functions.httpsCallable('resetPasswordWithOtp');
      await callable.call({
        'email': email.trim().toLowerCase(),
        'code': code.trim(),
        'newPassword': newPassword,
      });
      return {
        'success': true,
        'message': 'Contraseña actualizada. Inicia sesión.'
      };
    } on FirebaseFunctionsException catch (e) {
      final msg = _mapFunctionsError(e);
      return {'success': false, 'message': msg};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===================================
  // OTROS MÉTODOS DE SERVICIO
  // ===================================

  // Obtener datos del usuario de Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      return null;
    }
  }

  // Actualizar datos del usuario
  Future<bool> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      return true;
    } catch (e) {
      print('Error actualizando datos: $e');
      return false;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Eliminar cuenta
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      User? user = currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
        return {'success': true, 'message': 'Cuenta eliminada exitosamente'};
      }
      return {'success': false, 'message': 'No hay usuario autenticado'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': 'Error al eliminar cuenta: $e'};
    }
  }

  // ===================================
  // HELPERS
  // ===================================

  String _mapFunctionsError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'invalid-argument':
        return e.message ?? 'Datos inválidos. Revisa email/código/contraseña.';
      case 'not-found':
        return 'No existe usuario con ese email.';
      case 'failed-precondition':
        return 'No hay un código activo. Solicítalo primero.';
      case 'deadline-exceeded':
        return 'El código expiró. Pide uno nuevo.';
      case 'resource-exhausted':
        return 'Demasiados intentos o cooldown activo.';
      case 'permission-denied':
        return 'Permisos insuficientes.';
      default:
        return e.message ?? 'Error (Functions).';
    }
  }
}