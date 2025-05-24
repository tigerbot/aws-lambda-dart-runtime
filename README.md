# Dart Runtime for AWS Lambda

![Main](https://github.com/katallaxie/aws-lambda-dart-runtime/workflows/Main/badge.svg?branch=main)
[![License Apache 2](https://img.shields.io/badge/License-Apache2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

<p align="center">
   A 🎯 <a href="https://dart.dev/">Dart</a> Runtime for ƛ <a href="https://aws.amazon.com/lambda/">AWS Lambda</a>
</p>

---

> Read [Introducing a Dart runtime for AWS Lambda](https://aws.amazon.com/de/blogs/opensource/introducing-a-dart-runtime-for-aws-lambda/)
>
> 🚀 [Experimental support](#-serverless-framework-experimental) for ⚡️ serverless framework
>
> If you need to access AWS APIs in your Lambda function, [please search on pub.dev](https://pub.dev/packages?q=dependency%3Ashared_aws_api&sort=popularity) for packages provided by [Agilord](https://www.agilord.com/)

## Features

- Great performance `< 10ms` on event processing and `< 50MB` memory consumption
- No need to ship the Dart runtime
- Multiple event handlers
- Typed events
- Custom events

> this package requires Dart `>= 3.0`
> currently `dart compile exe` only supports building for the platform it is run on, so you must either build on a `Linux` machine or use `docker`.

## 🚀 Introduction

[Dart](https://dart.dev/) is an unsupported [AWS Lambda](https://aws.amazon.com/lambda/) runtime language. However, with a [custom runtime](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html) you can support virtually every programming language.

There are two ways in which you could use [Dart](https://dart.dev/). You could bundle the Dart Runtime in a [Lambda layer](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html) and use JIT compilation within the lambda execution to run a Dart program. The other is to compile a shippable binary of the Dart program.

Dart `>= 3.0` introduced `dart compile exe`. The [tool](https://dart.dev/tools/dart-compile) uses AOT (ahead-of-time) to compile a Dart program to [native x64 or arm machine code](https://dart.dev/platforms). This standalone executable is native machine code that's compiled from the specific Dart file and its dependencies, plus a small Dart runtime that handles type checking and garbage collection.

We decided to use the latter approach rather then the just-in-time compilation of Dart files. The main reason for this decision is that we wanted to avoid having to ship and maintain a standalone Dart runtime version. We would eventually have to deprecate versions, or always update the version when moving forward. Furthermore, shipping a binary has the advantage of having an always runnable version of your function in addition to performance benefits.

We want to highlight [Firecracker open-source innovation](https://www.youtube.com/watch?v=yDplzXEdBTI) from re:Invent 2019 which gives you a brief overview of [Firecracker](https://firecracker-microvm.github.io/) which is the underlying technology of AWS Lambda.

## 📦 Use

Add the following snippet to your [pubspec file](https://dart.dev/tools/pub/pubspec) in `pubspec.yaml`.

```shell
dart pub add aws_lambda_runtime
```

[API Docs](https://pub.dev/documentation/aws_lambda_runtime/latest/) are available. They can also be regenerated and viewed locally.

```shell
dart doc
# access the docs local
dart pub global activate dhttpd
dhttpd --path doc/api
```

Build and deploy the Dart functions by the [serverless](https://serverless.com) framework or by custom deployment.

### 🧪 Serverless Framework (experimental)

Checkout [serverless-dart](https://github.com/katallaxie/serverless-dart) to create your functions with [serverless](https://serverless.com).

You can start your next project using the [serverless-aws-dart](https://github.com/katallaxie/serverless-aws-dart) template.

```shell
$ npx serverless install \
  --url https://github.com/katallaxie/serverless-aws-dart \
  --name hello
```

Every [serverless workflow command](https://www.serverless.com/framework/docs/providers/aws/guide/workflow/) should work out of the box. The template also includes an example [GitHub actions](https://github.com/features/actions) [configuration file](.github/workflows/main.yml) which can unlock a virtuous cycle of continuous integration and deployment
( i.e all tests are run on prs and every push to master results in a deployment).

### Custom deployment

The deployment is a manual task right now. We have a [`example/build.sh`](./example/build.sh) script which makes the process a bit easier. There are three steps to get your code ready to be shipped.

1. Compile your Dart program with `dart2native main.dart -o bootstrap`
2. Create a `.zip` file with `zip lambda.zip bootstrap`
3. Upload the `lambda.zip` to a S3 bucket or use the [AWS CLI](https://aws.amazon.com/cli) to upload it

> again, you have to build this on Linux, because `dart2native` does not support cross-compiling

When you created your function and upload it via the the console. Please, replace `arn:aws:iam::xxx:xxx` with the role you created for your lambda.

```shell
aws lambda create-function --function-name dartTest \
  --handler hello.apigateway \
  --zip-file fileb://./lambda.zip \
  --runtime provided \
  --role arn:aws:iam::xxx:xxx \
  --environment Variables={DART_BACKTRACE=1} \
  --tracing-config Mode=Active
```

Updating a function is a fairly easy task. Rebuild your `lambda.zip` package and execute the following command.

```shell
aws lambda update-function-code --function-name dartTest --zip-file fileb://./lambda.zip
```

## Events

There are a number of events that come with the Dart Runtime.

- Application Load Balancer
- Alexa
- API Gateway
- AppSync
- Cloudwatch
- Cognito
- DynamoDB
- Kinesis
- S3
- SQS

You can also register custom events.

```dart
import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

class MyCustomEvent extends Event {
  final Map<String, dynamic> rawJson;
  const MyCustomEvent(this.rawJson);

  factory MyCustomEvent.fromJson(Map<String, dynamic> json) =>
      MyCustomEvent(json);
}

String successHandler(Context ctx, MyCustomEvent event) => "SUCCESS";

void main() async {
  final rt = Runtime()
    ..registerEvent(MyCustomEvent.fromJson)
    ..registerHandler("doesnt.matter", successHandler);
  await rt.invoke();
}
```

## Example

The example in [`main.dart`](./example/lib/main.dart) show how the package is intended to be used.

```shell
dart compile exe example/lib/main.dart -o bootstrap
```

:warning: Because `dart compile` does not support cross-platform compilation, if your are not on `Linux` you will need to use the [dart Docker image](https://hub.docker.com/_/dart) container to build the project. The `build.sh` script automates the build process in the container.

```shell
# will build the binary in the container
# mount the entire repo because example uses a relative package in pubspec.yaml
docker run --rm -v ${PWD}:/app --platform linux/arm64 dart /app/example/build.sh
```

This will create a `bootstrap` binary that you can then add to a zip file and
upload either manually or with the client of your choice.

We support using multiple handlers in one executable. The following example shows to register one handler.

```dart
import 'package:aws_lambda_runtime/aws_lambda_runtime.dart';

void main() async {
  /// The Runtime is a singleton. You can define the handlers as you wish.
  final rt = Runtime()
    ..registerHandler("hello.apigateway", helloApiGateway);
  await rt.invoke();
}

/// This demo's handling an API Gateway request.
AwsApiGatewayResponse helloApiGateway(Context context, AwsApiGatewayEvent event) {
  final response = {"message": "hello ${context.requestId}"};

  /// it returns an encoded response to the gateway
  return AwsApiGatewayResponse.fromJson(response);
};
```

This example registers the `hello.apigateway` handler with the function to execute for this handler. The handler function is typed to receive a [Amazon API Gateway Event](https://aws.amazon.com/api-gateway) and it returns a response to the invoking gateway. We support many other [events](#events). Handler functions get a `Context` injected with the needed information about the invocation. You can also register your own custom events via `Runtime.registerEvent<E>(Handler<E>)` (see [events](#events)).

## Limitations

- No Just-in-time (JIT) support
- Requires Dart `>= 3.0`
- No cross-platform compile support (see [#28617](https://github.com/dart-lang/sdk/issues/28617)).

## Development

If you want to use the Repository directly you can clone it and overwrite the dependency in your `pubspec.yaml` as follows.

```yaml
dependency_overrides:
  aws_lambda_runtime:
    path: <path_to_source>
```

The [`data`](./data) folder contains examples of the used events. We use this to run our tests, but you can also use them to implement new features. If you want to request the processing of a new event, you may provide a payload here.

```shell
# run the tests
dart test
```

## License

[Apache 2.0](/LICENSE)

We :blue_heart: Dart.
