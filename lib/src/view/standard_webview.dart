import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/src/models/responses/charge_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StandardWebView extends StatefulWidget {
  final String url;

  const StandardWebView({
    required this.url,
  });

  @override
  State<StandardWebView> createState() => _StandardWebViewAppState();
}

class _StandardWebViewAppState extends State<StandardWebView> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };

    UniqueKey _key = UniqueKey();

    return SafeArea(
      child: Scaffold(
        key: _key,
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureRecognizers: gestureRecognizers,
          onPageStarted: _processUrl,
        ),
      ),
    );
  }

  _processUrl(String webUrl) {
    final uri = Uri.parse(webUrl);
    if (_checkHasAppendedWithResponse(uri)) {
      _finishWithAppendedResponse(uri);
    } else {
      _checkHasCompletedProcessing(uri);
    }
  }

  _checkHasCompletedProcessing(final Uri uri) {
    final status = uri.queryParameters["status"];
    final txRef = uri.queryParameters["tx_ref"];
    final id = uri.queryParameters["transaction_id"];
    if (status != null && txRef != null) {
      _finish(uri);
    }
  }

  bool _checkHasAppendedWithResponse(final Uri uri) {
    final response = uri.queryParameters["response"];
    if (response != null) {
      final json = jsonDecode(response);
      final status = json["status"];
      final txRef = json["txRef"];
      return status != null && txRef != null;
    }
    return false;
  }

  _finishWithAppendedResponse(Uri uri) {
    final response = uri.queryParameters["response"];
    final decoded = Uri.decodeFull(response!);
    final json = jsonDecode(decoded);
    final status = json["status"];
    final txRef = json["txRef"];
    final id = json["id"];

    final ChargeResponse chargeResponse = ChargeResponse(
      status: status,
      transactionId: "$id",
      txRef: txRef,
      success: status?.contains("success") == true,
    );
    Navigator.pop(context, chargeResponse);
  }

  _finish(final Uri uri) {
    final status = uri.queryParameters["status"];
    final txRef = uri.queryParameters["tx_ref"];
    final id = uri.queryParameters["transaction_id"];
    final ChargeResponse chargeResponse = ChargeResponse(
      status: status,
      transactionId: id,
      txRef: txRef,
      success: status?.contains("success") == true,
    );
    Navigator.pop(context, chargeResponse);
  }
}
