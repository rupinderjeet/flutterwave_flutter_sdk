<p align="center">    
   <img title="Flutterwave" height="100" src="https://flutterwave.com/images/logo/full.svg" width="50%"/>  
</p>    

# Flutterwave Flutter SDK (Standard)

The Flutter library helps you create seamless payment experiences in your dart mobile app. By
connecting to our modal, you can start collecting payment in no time.
See [Flutterwave Standard](https://developer.flutterwave.com/docs/collecting-payments/standard)
documentation for more details on how this works.

See Original [README.md](https://github.com/Flutterwave/Flutter) at source repository. **THIS FORK IS NOT INTENDED FOR MERGE**.

----

## How to use?

Try to run the `example/lib/main.dart` after importing the project. You can add your
test-public-key [on this line](https://github.com/rupinderjeet/flutterwave_flutter_sdk/blob/develop/example/lib/main.dart#L65)
or in the input-field in the example app.

If the payment works in the example code, you can try using the library with following
in `pubspec.yaml`:

```yaml
# Library to access "Flutterwave for Business (F4B)" v3 APIs
# See: https://github.com/Flutterwave/Flutter
# See: https://github.com/rupinderjeet/flutterwave_flutter_sdk (fork)
flutterwave_standard:
  git:
    url: https://github.com/rupinderjeet/flutterwave_flutter_sdk.git
    ref: develop
```

## License

By contributing to the Flutter library, you agree that your contributions will be licensed under
its [MIT license](/LICENSE).

Copyright (c) Flutterwave Inc.

## Flutterwave API  References

- [Flutterwave API Doc](https://developer.flutterwave.com/docs)
- [Flutterwave Standard](https://developer.flutterwave.com/docs/collecting-payments/standard) (used
  in this repository/sdk)
- [Flutterwave Inline Payment Doc](https://developer.flutterwave.com/docs/flutterwave-inline)
- [Flutterwave Dashboard](https://dashboard.flutterwave.com/login)