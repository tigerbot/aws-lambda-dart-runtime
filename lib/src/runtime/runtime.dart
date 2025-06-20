import 'dart:async';
import 'package:meta/meta.dart' show visibleForTesting;

import './client.dart';
import './context.dart';
import './environment.dart';
import './event.dart';
import './exception.dart';
import './invocation.dart';

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
  final registerEvent = Event.registerEvent;

  /// Deregister an new event to be ingested by a handler.
  /// The type should reflect your type in your handler definition [Handler<E>].
  final deregisterEvent = Event.deregisterEvent;

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

  Future<void> _handleInvocation(Invocation invocation) async {
    try {
      // creating the new context
      final context = Context.fromInvocation(invocation, _env);

      final func = _handlers[context.handler];
      if (func == null) {
        throw InvocationError(
          type: 'Runtime.NoSuchHandler',
          message: 'No handler named "${context.handler}" registered!',
        );
      }
      final event = Event.fromHandler(func.type, invocation.response);
      final result = await func.handler(context, event);

      await _client.postInvocationResponse(invocation.requestId, result);
    } on InvocationError catch (error) {
      await _client.postInvocationError(invocation.requestId, error);
    } catch (error) {
      await _client.postInvocationError(
          invocation.requestId, InvocationError(message: error.toString()));
    }
  }
}
