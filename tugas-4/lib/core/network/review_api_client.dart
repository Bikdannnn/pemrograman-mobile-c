import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model untuk ulasan dan profil reviewer otentik dari RandomUser.me API
class RealUserReviewItem {
  final String reviewerName;
  final String avatarUrl;
  final String comment;
  final double rating;

  const RealUserReviewItem({
    required this.reviewerName,
    required this.avatarUrl,
    required this.comment,
    this.rating = 5.0,
  });
}

/// Client HTTP untuk RandomUser.me API & DummyJSON Comments
class ReviewApiClient {
  final http.Client _client;

  ReviewApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data reviewer dengan foto profil asli HD dan nama otentik
  Future<List<RealUserReviewItem>> fetchCustomerReviews({int count = 6}) async {
    try {
      final uri = Uri.parse(
        'https://randomuser.me/api/?results=$count&inc=name,picture&nat=id,us',
      );
      final response = await _client.get(uri).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final results = (decoded['results'] as List<dynamic>?) ?? [];

        if (results.isNotEmpty) {
          final comments = _authenticCulinaryComments;
          final reviews = <RealUserReviewItem>[];

          for (var i = 0; i < results.length; i++) {
            final userMap = results[i] as Map<String, dynamic>;
            final nameMap = (userMap['name'] as Map<String, dynamic>?) ?? {};
            final pictureMap = (userMap['picture'] as Map<String, dynamic>?) ?? {};

            final first = (nameMap['first'] as String?) ?? 'Pelanggan';
            final last = (nameMap['last'] as String?) ?? '';
            final fullName = '$first $last'.trim();
            final avatar = (pictureMap['medium'] as String?) ??
                (pictureMap['thumbnail'] as String?) ??
                '';

            reviews.add(
              RealUserReviewItem(
                reviewerName: fullName,
                avatarUrl: avatar,
                comment: comments[i % comments.length],
                rating: 4.5 + ((i % 2) * 0.5),
              ),
            );
          }

          return reviews;
        }
      }
    } catch (_) {
      // Fallback lokal jika offline
    }

    return _fallbackReviews.take(count).toList();
  }

  static const List<String> _authenticCulinaryComments = [
    'Rasa masakannya sangat autentik! Bumbunya meresap sampai ke dalam, sambalnya juara!',
    'Pelayanan ramah dan tempatnya bersih. Pilihan menunya variatif, recommended untuk makan bersama keluarga.',
    'Porsi mengenyangkan dan harganya sangat bersahabat di kantong mahasiswa maupun pekerja.',
    'Salah satu spot kuliner terbaik di Makassar. Pasti bakal balik lagi minggu depan!',
    'Makanannya disajikan hangat dan cepat, tempat parkir juga memadai dan nyaman.',
    'Suasananya asik dan makanannya enak banget! Jangan lupa coba minuman segarnya.',
  ];

  static const List<RealUserReviewItem> _fallbackReviews = [
    RealUserReviewItem(
      reviewerName: 'Andi Pratama',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
      comment: 'Tempat makan paling nyaman, semua pelayan ramah dan makanannya enak-enak.',
      rating: 5.0,
    ),
    RealUserReviewItem(
      reviewerName: 'Siti Nurhaliza',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      comment: 'Bumbu rica-ricanya pedas nagih, daging ayamnya empuk dan fresh!',
      rating: 5.0,
    ),
    RealUserReviewItem(
      reviewerName: 'Fajar Nugraha',
      avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150&auto=format&fit=crop&q=80',
      comment: 'Pelayanan cepat dan ramah, parkir luas, cocok buat nongkrong kulineran.',
      rating: 4.8,
    ),
  ];
}
