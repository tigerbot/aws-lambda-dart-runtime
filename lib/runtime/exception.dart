/// An exception thrown when there is an error in the runtime.
class RuntimeException implements Exception {
  const RuntimeException(this.cause);

  /// Explains the reason why there is an exception thrown
  /// in the runtime.
  final String cause;

  @override
  String toString() => 'RuntimeException: $cause';
}

/// An exception thrown when a required OS environment value is missing.
class MissingEnvException implements Exception {
  const MissingEnvException(this.environmentKey);

  final String environmentKey;

  @override
  String toString() => "Missing OS enviroment value for $environmentKey";
}
