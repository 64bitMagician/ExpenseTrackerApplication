import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Snackbar Utility Method
void snackbarDeleteAndOverrite (BuildContext context, String message, {Color? color}){
ScaffoldMessenger.of(context).hideCurrentSnackBar();
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color,));
}