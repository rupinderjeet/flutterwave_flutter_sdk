import 'dart:convert';

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
  late WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStartedLoading,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

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
        body: WebViewWidget(controller: _controller, gestureRecognizers: gestureRecognizers),
      ),
    );
  }

  void _onPageStartedLoading(String webUrl) {
    final uri = Uri.parse(webUrl);

    bool handled = _handleIfHasAppendedResponse(uri);
    if (handled) return;

    handled = _handleIfHasCompletedProcessing(uri);
    if (handled) return;

    // ignored:
    // print('flw:page_started_loading unhandled:$webUrl');
  }

  bool _handleIfHasAppendedResponse(final Uri uri) {
    final response = uri.queryParameters["response"];
    if (response == null) return false;

    final decoded = Uri.decodeFull(response); // TODO: test this
    final json = jsonDecode(decoded);

    final status = json["status"];
    if (status == null) return false;

    final txRef = json["txRef"];
    if (txRef == null) return false;

    final id = json["id"];

    final chargeResponse = ChargeResponse(
      status: status,
      transactionId: "$id",
      txRef: txRef,
    );
    Navigator.pop(context, chargeResponse);
    return true;
  }

  bool _handleIfHasCompletedProcessing(final Uri uri) {
    final status = uri.queryParameters["status"];
    if (status == null) return false;

    final txRef = uri.queryParameters["tx_ref"];
    if (txRef == null) return false;

    final id = uri.queryParameters["transaction_id"];
    final chargeResponse = ChargeResponse(
      status: status,
      transactionId: id,
      txRef: txRef,
    );
    Navigator.pop(context, chargeResponse);
    return true;
  }
}
