import 'package:flutter/material.dart';
import 'package:flutter_clipboard_manager/flutter_clipboard_manager.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Multiplier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Text Multiplier'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final  _textKey = GlobalKey<FormState>();

  String outputString = 'Enter anything.\nEnter a number to multiply and copy the text to clipboard';
  String tempData = '';
  int tempNum = 0;


  String generateText(int num,  String text) {

    String outputSting = '';

    for(int i=0; i<num; i++){
      outputSting+=text;
    }

    return outputSting;
  }


  Future<void> _onOpen(LinkableElement link) async {
    print(link);
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Color(0xAA283655),
      appBar: AppBar(

        backgroundColor: Color(0xFF4D648D),

        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.info),
            onPressed: (){

              showAboutDialog(
                context: context,
                applicationName: "Text Multiplier",
                applicationIcon: Image.asset('assets/ic_my_launcher.png',width: 50.0,height: 50.0,),
                applicationVersion: '1.0',
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        'Developed by',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Text(
                             'Nasir Basha K',
                             style: TextStyle(
                               color: Colors.blue,
                               fontSize: 18.0,
                             ),
                           ),
                           Linkify(
                             onOpen: _onOpen,
                             text: "https://github.com/nasirbashak",
                           ),
                         ],
                      ),
                    ],
                  )
                ]
              );
            },
          )
        ],
      ),
      body:Builder(builder: (context){
        return  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "$outputString",
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF1E1F26),
                                offset: Offset(2.0,2.0),
                                blurRadius: 2.0,
                                spreadRadius: 1.0
                            )
                          ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: Color(0xFF4D648D),
                        elevation: 0.0,
                        child: Form(
                          key: _textKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      validator: (text){
                                        if (text.isEmpty){
                                          return 'Enter a text';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      decoration: InputDecoration(
                                          hintText: 'Enter anything',
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                          )
                                      ),
                                      onChanged: (value){
                                        tempData = value;
                                      },
                                      textAlign: TextAlign.center,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (text){
                                        if (text.isEmpty){
                                          return 'A number is required';
                                        }else if(int.parse(text) >2000){
                                          return 'Number cannot be greater than 2000';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter a number',
                                        hintStyle: TextStyle(
                                          color: Colors.white
                                        )
                                      ),
                                      onChanged: (value){
                                        tempNum = int.parse(value);
                                      },
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              RaisedButton.icon(
                                onPressed: (){
                                  if (_textKey.currentState.validate()) {
                                    _textKey.currentState.reset();

                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      outputString = generateText( tempNum, tempData);
                                    });

                                     copyAndShowSnackBar(context,outputString);

                                  }

                                },
                                color: Color(0xFF5BC8AC),
                                icon: Icon(Icons.arrow_forward),
                                label: Text("Multiply"),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      )
    );
  }

  void copyAndShowSnackBar(BuildContext context, String outputString) {

    FlutterClipboardManager.copyToClipBoard(outputString)
        .then((result) {
            final snackBar = SnackBar(
                content: Text('Copied to Clipboard'),
                action: SnackBarAction(
                    label: 'Okay',
                    onPressed: () {},
                    ),
            );
        Scaffold.of(context).showSnackBar(snackBar);
    });
  }

}


