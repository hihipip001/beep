import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

import 'base.dart';
import 'input_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int TIMES = 50;
  static int SECS = 3;

  Timer? _timer;
  int _totalCount = TIMES; //總數
  int _count = SECS;
  bool pause = false;
  bool start = false;
  SharedPreferences? prefs;
  String inputText="";


  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    Wakelock.disable();
  }


  init() async{
    await Wakelock.enable();
    prefs = await SharedPreferences.getInstance();
    TIMES = (prefs?.getInt('times') ?? TIMES);
    _totalCount =TIMES;
    setState(() { });
  }



  void startTimer() {


    const oneSec = const Duration(seconds: 1);
    var callback = (timer) {

      if( !pause ) return;

      if (_count < 1) {
        beep();
        _timer?.cancel();
        _totalCount = _totalCount - 1;
        if( _totalCount > 0 ){
          _count = SECS;
          Future.delayed(const Duration(milliseconds: 2000), () {
            startTimer();
          });
        }

      } else {
        _count = _count - 1;
      }
      setState(() { });
    };
    _timer = Timer.periodic(oneSec, callback);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beep"),),
      body: _buildContent(),
    );
  }

  _buildContent(){
    var height =  MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          height: height,
          color:Colors.grey.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.0,),
              _buildTotalText(),
              SizedBox(height: 10.0,),
              _buildText(),
              SizedBox(height: 20.0,),
              _buildTwoButton(),
              SizedBox(height: 50.0,),
              _buildInput(),
              SizedBox(height: 50.0,),
            ],
          ),
        )
      )
    );
  }

  _buildInput(){
    if( start ){
      return Container(
        child: Text('已啟動無法設定次數',style:TextStyle(fontSize: 18)),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("次數︰",style:TextStyle(fontSize: 18)),
        Container(
          width:100,
          child: InputWidget(key:Key("machine_name"),hint:"",defaultString:inputText,mode: TextInputType.number,maxLength: 5,
            callback: (String text){
              this.inputText = text;
            },),
        ),
        buildButton(onTap: () async{
          FocusScope.of(context).unfocus();
          if( inputText=="" ) return ;
          _totalCount = int.parse(inputText);
          await prefs?.setInt('times', _totalCount);
          setState(() {

          });
        },title:"Setup"),
      ],
    );

  }



  _buildTotalText(){
    return Container(
      padding: EdgeInsets.all(5.0),
       child:Text("總數 $_totalCount 次",style:TextStyle(fontSize: 18))
    );
  }
  _buildText(){
    return Container(
      child:Text("倒數 $_count 秒",style:TextStyle(fontSize: 18))
    );
  }
  _buildTwoButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildButton(onTap: (){

          setState(() {
            pause = !pause;
          });
          //只啟動一次
          if( !start ){
            start = true;
            startTimer();
          }
        },title:pause?"pause":"start"),
        buildButton(onTap: (){
          confirmDialog();
        },title:"ReStart"),
      ],
    );
  }

  void confirmDialog(){
    showCommonDialog(context, "提示", "您確定重新啟動?",btn1fun: (){
      _timer?.cancel();
      _totalCount = TIMES;
      _count = SECS;
      start = false;
      pause = false;
      setState(() { });
    },btn2word: "取消");
  }

  //Beep 的聲音
  void beep(){
    if (Platform.isAndroid) {
      FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
    } else if (Platform.isIOS) {
      FlutterBeep.playSysSound(iOSSoundIDs.AudioToneBusy);
    }
  }












}
