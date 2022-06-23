// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final index;
  const WebViewContainer(this.url, this.index, {Key? key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  createState() => _WebViewContainerState(url, index);
}

final socialStrings = ['CCHS Instagram', 'CCHS Twitter', 'CCHS Website'];

class _WebViewContainerState extends State<WebViewContainer> {
  final _url;
  final _index;
  final _key = UniqueKey();
  _WebViewContainerState(this._url, int this._index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF212121),
          title: Text(socialStrings[_index]),
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}
