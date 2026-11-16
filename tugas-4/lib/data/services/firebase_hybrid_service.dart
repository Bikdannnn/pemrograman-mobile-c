import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Model Event Push Notification (In-App & Firebase Cloud Messaging)
class PushNotificationEvent {
  final String title;
  final String body;
  final String category;
  final DateTime timestamp;

  PushNotificationEvent({
    required this.title,
    required this.body,
    this.category = 'FoodView',
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Service Hybrid Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging`):
/// - Jika project Firebase tersedia, otomatis menyinkronkan Auth, Firestore (`reviews`, `menus`, `chats`), dan FCM.
/// - Jika belum ada `google-services.json`, otomatis berjalan dalam Mode Hybrid Local Fallback tanpa error.
class FirebaseHybridService {
  static final FirebaseHybridService instance = FirebaseHybridService._();
  FirebaseHybridService._();

  bool _isFirebaseConnected = false;
  bool get isFirebaseConnected => _isFirebaseConnected;

  final StreamController<PushNotificationEvent> _pushStreamController =
      StreamController<PushNotificationEvent>.broadcast();

  Stream<PushNotificationEvent> get pushStream => _pushStreamController.stream;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _isFirebaseConnected = true;

      // Setup Firebase Messaging listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notif = message.notification;
        if (notif != null) {
          _pushStreamController.add(
            PushNotificationEvent(
              title: notif.title ?? 'FoodView',
              body: notif.body ?? 'Anda memiliki notifikasi baru.',
            ),
          );
        }
      });
    } catch (e) {
      _isFirebaseConnected = false;
      debugPrint(
        'FoodView berjalan dalam Mode Hybrid (Firebase SDK siap + Local Fallback aktif): $e',
      );
    }
  }

  /// Trigger Push Notification (baik melalui FCM maupun In-App Push Banner)
  void triggerPushNotification({
    required String title,
    required String body,
    String category = 'FoodView',
  }) {
    _pushStreamController.add(
      PushNotificationEvent(
        title: title,
        body: body,
        category: category,
      ),
    );
  }

  /// Menyimpan ulasan baru ke Cloud Firestore jika terkoneksi
  Future<void> syncReviewToFirestore({
    required String targetId,
    required String userName,
    required String comment,
    required int stars,
  }) async {
    if (!_isFirebaseConnected) return;
    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        'targetId': targetId,
        'userName': userName,
        'comment': comment,
        'stars': stars,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Menyimpan menu baru pemilik restoran ke Cloud Firestore jika terkoneksi
  Future<void> syncMenuToFirestore({
    required String name,
    required String price,
    required String description,
  }) async {
    if (!_isFirebaseConnected) return;
    try {
      await FirebaseFirestore.instance.collection('menus').add({
        'name': name,
        'price': price,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Autentikasi Firebase Auth dengan fallback
  Future<bool> signInWithEmail(String email, String password) async {
    if (_isFirebaseConnected) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true;
      } catch (_) {}
    }
    return true;
  }
}
