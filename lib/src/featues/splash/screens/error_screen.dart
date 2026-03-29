import 'package:flutter/widgets.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMsg;
const ErrorScreen({ super.key, required this.errorMsg });

  @override
  Widget build(BuildContext context){
    return Center(child: Text(errorMsg));
  }
}