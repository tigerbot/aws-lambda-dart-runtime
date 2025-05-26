/// Invocation error occurs when there has been an
/// error in the invocation of a handler.
///
/// It contains a type and message and potentially a [StackTrace]
/// that will be reported back to the Lambda Runtime API.
class InvocationError extends Error {
  /// Category of the error encountered
  final String type;

  /// Text description of the error
  final String message;

  InvocationError({
    this.type = 'InvocationError',
    required this.message,
  });

  @override
  String toString() => '$type: $message';

  /// Extracts the [InvocationError] data into a JSON
  /// representation for the Lambda Runtime API.
  Map<String, dynamic> toJson() => {
        'errorType': type,
        'errorMessage': message,
        'stackTrace': stackTrace?.toString().split('\n'),
      };
}

/// An exception thrown when a required OS environment value is missing.
class MissingEnvException implements Exception {
  final String environmentKey;

  const MissingEnvException(this.environmentKey);

  @override
  String toString() => "Missing OS enviroment value for $environmentKey";

  @override
  bool operator ==(Object other) =>
      other is MissingEnvException && other.environmentKey == environmentKey;

  @override
  int get hashCode => Object.hash(environmentKey, null);
}
