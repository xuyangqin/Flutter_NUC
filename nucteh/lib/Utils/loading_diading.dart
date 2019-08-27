import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}