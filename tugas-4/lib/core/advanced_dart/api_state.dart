/// Implementasi Advance Dart:
/// 1. Sealed Classes & Algebraic Data Types (ADT)
/// 2. Generics `<T>`
/// 3. Exhaustive Switch Expressions & Object Pattern Destructuring
/// 4. Dart 3 Records & Named Record Destructuring
library;

/// Record untuk menyimpan rangkuman rating bintang (1 s/d 5) seperti pada komponen Figma.
typedef RatingSummaryRecord = ({
  double average,
  int totalCount,
  Map<int, int> starCounts,
});

/// Sealed class untuk merepresentasikan state operasi asynchronous / API secara aman (type-safe).
sealed class ApiState<T> {
  const ApiState();

  /// Helper menggunakan exhaustive switch expression & object pattern matching (Dart 3).
  R match<R>({
    required R Function() onInitial,
    required R Function(String? message) onLoading,
    required R Function(T data) onSuccess,
    required R Function(String error, int? statusCode) onError,
  }) =>
      switch (this) {
        ApiInitial<T>() => onInitial(),
        ApiLoading<T>(:final message) => onLoading(message),
        ApiSuccess<T>(:final data) => onSuccess(data),
        ApiError<T>(:final message, :final statusCode) =>
          onError(message, statusCode),
      };

  bool get isLoading => this is ApiLoading<T>;
  bool get hasData => this is ApiSuccess<T>;

  T? get dataOrNull => switch (this) {
        ApiSuccess<T>(:final data) => data,
        _ => null,
      };
}

final class ApiInitial<T> extends ApiState<T> {
  const ApiInitial();
}

final class ApiLoading<T> extends ApiState<T> {
  final String? message;
  const ApiLoading([this.message]);
}

final class ApiSuccess<T> extends ApiState<T> {
  final T data;
  final DateTime fetchedAt;

  ApiSuccess(this.data, {DateTime? fetchedAt})
      : fetchedAt = fetchedAt ?? DateTime.now();
}

final class ApiError<T> extends ApiState<T> {
  final String message;
  final int? statusCode;

  const ApiError(this.message, {this.statusCode});
}

/// Fungsi utilitas berbasis Dart 3 Record & Relational Pattern Matching
/// untuk menghitung distribusi bintang 1-5 dari daftar nilai rating.
RatingSummaryRecord calculateRatingSummary(Iterable<double> ratings) {
  final counts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  var sum = 0.0;
  var total = 0;

  for (final r in ratings) {
    sum += r;
    total++;
    final bucket = switch (r.round()) {
      >= 5 => 5,
      4 => 4,
      3 => 3,
      2 => 2,
      _ => 1,
    };
    counts[bucket] = (counts[bucket] ?? 0) + 1;
  }

  final avg = total == 0 ? 0.0 : sum / total;
  return (average: avg, totalCount: total, starCounts: counts);
}
