import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Usuario actual
  User? get currentUser => _auth.currentUser;
  
  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registro con email y contraseña
  Future<Map<String, dynamic>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enviar verificación de email
      await result.user!.sendEmailVerification();

      // Guardar datos adicionales en Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
      });

      return {
        'success': true,
        'user': result.user,
        'message': 'Usuario registrado exitosamente. Verifica tu email.'
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

  // Recuperar contraseña
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Email de recuperación enviado exitosamente'
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Error al enviar email';
      switch (e.code) {
        case 'user-not-found':
          message = 'No existe usuario con este email';
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

  // Reenviar verificación de email
  Future<Map<String, dynamic>> resendEmailVerification() async {
    try {
      User? user = currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return {
          'success': true,
          'message': 'Email de verificación reenviado'
        };
      }
      return {
        'success': false,
        'message': 'No hay usuario o ya está verificado'
      };
    } catch (e) {
      return {'success': false, 'message': 'Error al reenviar: $e'};
    }
  }

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
    await _auth.signOut();
  }

  // Eliminar cuenta
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      User? user = currentUser;
      if (user != null) {
        // Eliminar datos de Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        // Eliminar cuenta de Auth
        await user.delete();
        return {'success': true, 'message': 'Cuenta eliminada exitosamente'};
      }
      return {'success': false, 'message': 'No hay usuario autenticado'};
    } catch (e) {
      return {'success': false, 'message': 'Error al eliminar cuenta: $e'};
    }
  }
}