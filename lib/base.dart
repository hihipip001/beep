import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//open持續開著不關閉
void showCommonDialog(BuildContext context,String title,String body,{String btn1word='確認',String? btn2word,Function? btn1fun,Function? btn2fun,bool open=false}) async {
  return showDialog(
      context:context,
      barrierDismissible: false,
      builder: (BuildContext ctx){
        if( btn2word==null ){
          return WillPopScope(
            onWillPop: null,
            child: CupertinoAlertDialog(title: Text(title),content: Text(body),actions: <Widget>[
              CupertinoDialogAction(child: Text(btn1word),onPressed: (){
                if( !open ) Navigator.pop(ctx);
                if( btn1fun!=null )
                  btn1fun();
              },),
            ],),
          );
        }
        return WillPopScope(
            onWillPop: null,
            child:CupertinoAlertDialog(title: Text(title),content: Text(body),actions: <Widget>[
              CupertinoDialogAction(child: Text(btn1word),onPressed: (){
                if( !open ) Navigator.pop(ctx);
                if( btn1fun!=null )
                  btn1fun();
              },),
              CupertinoDialogAction(child: Text(btn2word),onPressed: (){
                if( !open ) Navigator.pop(ctx);
                if( btn2fun!=null )
                  btn2fun();
              },)
            ],)
        );
      }
  );
}


buildButton({onTap,title}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10.0),

      alignment: Alignment.center,
      child: Text(
        title,style:TextStyle(fontSize: 18,color:Colors.white),
      ),
    ),
  );



}
