import 'package:FAQ/services/auth.dart';
import 'package:FAQ/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {

  String qtext= "";
  String anstext= "";
  bool isLoading = false;


  final formKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods =  new AuthMethods();

  TextEditingController namer = new TextEditingController();
  TextEditingController emailr = new TextEditingController();
  TextEditingController questioner = new TextEditingController();


  afterSignInValidation(){

    if(formKey.currentState.validate()){

       Map<String, String>userInfoMap = {
      "name" : namer.text,
      "email": emailr.text,
      "question": questioner.text
    };


      setState(() {
        isLoading = true;
      });


      authMethods.signInWithEmailAndPassword(emailr.text, namer.text)
          .then((val){
            print("${val.uid}");

      databaseMethods.uploadUserInfo(userInfoMap);

         });      
       }

  }    


  okayLoaded(){
    Container(
      child: CircularProgressIndicator(),
    );
  }



  void _add(String q) async {
    Map<String,dynamic> messageMap = {
        "Question" : "${q}",
        "Answer" : "Trying to do something",
        
      };

    Firestore.instance.collection("myData")
        .document("dummy").setData(messageMap).catchError((e){
        print(e.toString());
   });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
       body: isLoading ? okayLoaded() : SingleChildScrollView(
              child: Container(
                 height: 800,
                 width: 400,
                 decoration:BoxDecoration(
                   image: DecorationImage(
                     image: AssetImage('assets/back.jpg'),
                   fit: BoxFit.fill
                   )
                   ),
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 15.0),),
                    Text("Frequently",textDirection: TextDirection.ltr,
                    style: new TextStyle(fontSize: 20.0, color: Colors.black),
               ),
                Text("Asked Question",textDirection: TextDirection.ltr,
                    style: new TextStyle(fontSize: 20.0, color: Colors.black),
               ),
              Padding(padding: const EdgeInsets.only(top: 20.0),),
              Container(
                height: 350,
                child: new ListView.builder(
                  itemBuilder: (_, int index)=>EachList(),
                  itemCount: 10,
                  ),
               ),
              Padding(padding: const EdgeInsets.all(30.0),),
              Container(
                height: 300,
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 5.0),),
                    Text("Join Our Community",textDirection: TextDirection.ltr,
                    style: new TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 5.0),),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Name",textDirection: TextDirection.ltr,
                        style: new TextStyle(fontSize: 10.0, color: Colors.black),
                        ), 
                        Padding(padding: const EdgeInsets.only(right: 5.0),),
                        Expanded(
                              child: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    validator: (val){
                                      return val.isEmpty || val.length< 4 ? "Please Provide strong username" : null;
                                    },
                                  controller: namer,
                            decoration: InputDecoration(
                                hintText: "Name"
                            ),
                          ),
                              ),
                        ),
                          ],
                        ),
                      ],
                    ),
                  Padding(padding: const EdgeInsets.only(top: 5.0),),  
                  Row(
                      children: [
                        Text("Email",textDirection: TextDirection.ltr,
                    style: new TextStyle(fontSize: 10.0, color: Colors.black),
                    ), 
                    Padding(padding: const EdgeInsets.only(right: 5.0),),
                    Expanded(
                          child: Form(
                                key: formKey,
                                child: TextFormField(
                                  validator: (val) {
                                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) && val.isNotEmpty ? null : "Enter correct email";
                                          },
                              controller: emailr,
                        decoration: InputDecoration(
                            hintText: "Email"
                        ),
                      ),
                          ),
                    ),
                      ],
                    ),
                  Padding(padding: const EdgeInsets.only(top: 5.0),),
                  Row(
                      children: [
                        Text("Question",textDirection: TextDirection.ltr,
                    style: new TextStyle(fontSize: 10.0, color: Colors.black),
                    ), 
                    Padding(padding: const EdgeInsets.only(right: 5.0),),
                    Expanded(
                          child: Form(
                            key: formKey,
                              child: TextFormField(
                              controller: questioner,
                        decoration: InputDecoration(
                            hintText: "Question"
                        ),
                      ),
                          ),
                    ),
                      ],
                    ),
                  Padding(padding: const EdgeInsets.only(top: 5.0),),
                  RaisedButton(
                    onPressed:
                    afterSignInValidation(),
              padding: const EdgeInsets.all(10.0),
              child:
                  const Text('Submit', style: TextStyle(fontSize: 20)),
            ),
                  ],
                ),
              ),
                  ],
                ),
               ),
           ),
        ); }
}



class EachList extends StatelessWidget {

  String qtext= "";
  String anstext= "";
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            new Text(qtext,textDirection: TextDirection.ltr,
                    style: new TextStyle(fontSize: 5.0, color: Colors.black),
            ),
            Padding(padding: const EdgeInsets.only(top: 10.0),),
                Text(anstext,textDirection: TextDirection.ltr,
                    style: new TextStyle(fontSize: 5.0, color: Colors.black),
            ),
          ],
          ),
      )
    );
  }
}