import 'dart:async';
import 'package:meta/meta.dart' show visibleForTesting;

import 'package:aws_lambda_runtime/client/client.dart';
import 'package:aws_lambda_runtime/runtime/environment.dart';
import 'package:aws_lambda_runtime/runtime/event.dart';
import 'package:aws_lambda_runtime/runtime/context.dart';
import 'package:aws_lambda_runtime/runtime/exception.dart';

/// A function which ingests and Event and a [Context] and returns
/// a result to be encoded by the [Runtime] and posted to the Lambda API.
typedef Handler<E extends Event> = Function(Context context, E event);

class _RuntimeHandler {
  final Type type;
  final dynamic handler;

  const _RuntimeHandler(this.type, this.handler) : assert(handler != null);
}

/// A Runtime manages the interface to the Lambda API.
///
/// The Runtime is designed as singleton and `Runtime()`
/// returns the same instance of the [Runtime] everytime.
///
/// ```dart
/// String helloWorldHandler(Context context, AwsS3NotificationEvent event) {
///    return "HELLO WORLD";
/// };
///
/// final rt = Runtime()
///   ..registerHandler("hello.world", helloWorld);
/// await rt.invoke();
/// ```
class Runtime {
  static final Runtime _singleton = Runtime.fromEnv(Environment());
  factory Runtime() => _singleton;

  final Map<String, _RuntimeHandler> _handlers = {};
  final Client _client;
  final Environment _env;

  @visibleForTesting
  Runtime.fromEnv(this._env) : _client = Client(runtimeApi: _env.runtimeAPI);

  /// Lists the registered handlers by name.
  /// The name is a simple [String] which reflects
  /// the name of the trigger in the Lambda Execution API.
  List<String> get handlers => _handlers.keys.toList();

  /// Checks if a specific handlers has been registered
  /// with the runtime.
  bool handlerExists(String name) => _handlers.containsKey(name);

  /// Register a handler function [Handler<E>] with [name]
  /// which digests an event [E].
  ///
  /// If you are using a custom event type it must be registered
  /// before any handlers digesting it can be added.
  void registerHandler<E extends Event>(String name, Handler<E> handler) {
    assert(Event.exists<E>(), 'registered handler with unknown event type');
    assert(!handlerExists(name), 'double registered $name handler');
    _handlers[name] = _RuntimeHandler(E, handler);
  }

  /// Unregister a handler function [Handler] with [name].
  void deregisterHandler(String name) => _handlers.remove(name)?.handler;

  /// Register an new event to be ingested by a handler.
  /// The type should reflect your type in your handler definition [Handler<E>].
  void registerEvent<E extends Event>(EventParser<E> func) =>
      Event.registerEvent<E>(func);

  /// Deregister an new event to be ingested by a handler.
  /// The type should reflect your type in your handler definition [Handler<E>].
  void deregisterEvent<E extends Event>() => Event.deregisterEvent<E>();

  /// Run the [Runtime] in loop and digest events that are
  /// fetched from the AWS Lambda API Interface. The events are processed
  /// sequentially and are fetched from the AWS Lambda API Interface.
  ///
  /// If the invocation of an event was successful the function
  /// sends the result via [Client.postInvocationResponse] to the API.
  /// If there is an error during the execution. The exception gets caught
  /// and the error is posted via [Client.postInvocationError] to the API.
  Future<void> invoke() async {
    while (true) {
      await _client.getNextInvocation().then(_handleInvocation);
    }
  }

  Future<void> _handleInvocation(NextInvocation nextInvocation) async {
    try {
      // creating the new context
      final context = Context.fromNextInvocation(nextInvocation, _env);

      final func = _handlers[context.handler];
      if (func == null) {
        throw RuntimeException(
            'No handler with name "${context.handler}" registered in runtime!');
      }
      final event = Event.fromHandler(func.type, nextInvocation.response);
      final result = await func.handler(context, event);

      await _client.postInvocationResponse(context.requestId, result);
    } catch (error, stacktrace) {
      await _client.postInvocationError(
          nextInvocation.requestId, InvocationError(error, stacktrace));
    }
  }
}
