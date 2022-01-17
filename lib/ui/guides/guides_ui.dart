import 'package:flutter/material.dart';
import 'package:worker_app/ui/guides/guides_page.dart';

//placeholder for guides screen
class GuidesUI extends StatelessWidget {
  const GuidesUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GuidePage(),
      ),
    );
  }
}
