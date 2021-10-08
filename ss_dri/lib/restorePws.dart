import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestorePwd extends StatefulWidget {
  RestorePwd({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _RestorePwdState createState() => _RestorePwdState();
}

class _RestorePwdState extends State<RestorePwd> {
  final _text = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool _validate = true;
  bool _validUser = true;
  int attemp = 0;

  @override
  void initState() {
    super.initState();
    _text.addListener(validateMyInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 132, 43, 87),
        title: Text('Reestablecer Contraseña'),
      ),
      body: Column(children: [
          Container(
            height: 80.0,
            width: 190.0,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(200)),
            child: Center(
              child: Image.asset('asset/images/logo-ipn.png'),
            ),
          ),
          Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: _text,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              errorText: !_validate ? 'Tiene que ser un email válido' : null,
            ),
          ),
        ),
        Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: _validate
                  ? Color.fromARGB(255, 132, 43, 87)
                  : Colors.black12,
              borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: !_validate
                ? null
                : () {
                    auth.sendPasswordResetEmail(email: _text.text);
                    Navigator.of(context).pop();
                  },
            child: Text(
              'Enviar correo',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => _validUser,
          widgetBuilder: (BuildContext context) => Text(''),
          fallbackBuilder: (BuildContext context) => Container(
              height: 50,
              width: 50,
              child: Text(
                'Usuario o contraseña inválido',
                style: TextStyle(color: Colors.red, fontSize: 25),
              ),
            ))
        ],
      ),
    );
  }

  void validateMyInput() {
    Pattern pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = new RegExp(pattern);
    setState(() {
      if (attemp == 0) {
        setState(() {
          attemp++;
          _validate = true;
          _validUser = true;
        });
      } else {
        !regex.hasMatch(_text.text) ? _validate = false : _validate = true;
      }
    });
  }
  

  /*Future loginInput(String emailInput) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailInput, password: passwordInput);
      setState(() {
        _validUser = true;
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => StudentHome()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _validUser = false;
      });
      if (e.code == 'use-not-found') {
        print('usuario o contraseña incorrectos');
      } else if (e.code == 'wrong-password') {
        print('usuario o contraseña incorrectos');
      }
    }
  }*/
}