
import 'package:flutter/material.dart';



class InputWidget extends StatefulWidget {
  final String? hint;
  final String? defaultString;
  final int maxLength;
  final TextInputType mode;
  final bool obscure;
  final Function(String) callback;
  const InputWidget({this.hint,this.defaultString,
    this.maxLength=10,required this.callback,this.obscure = false,
    this.mode = TextInputType.number,Key? key}) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {

  TextEditingController? controller;
  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text:widget.defaultString??'');
  }


  _onChanged(value) {
    widget.callback(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border:Border.all(
              color:Colors.blueGrey,
              width:1.0
          ),
          color:Colors.white,
          //borderRadius: btnCorner
        ),
        child:TextField(
            enabled: true,
            maxLength: widget.maxLength,
            keyboardType: widget.mode,
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: widget.obscure,
            onChanged: _onChanged,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              hintText: widget.hint,
              counterText: '',
            ),
            style:TextStyle( fontSize: 18, ),
            onSubmitted: (text){
              widget.callback(text);
            }
        )
    );
  }
}
