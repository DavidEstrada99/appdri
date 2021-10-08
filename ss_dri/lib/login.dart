import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'Student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'restorePws.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _text = TextEditingController();
  final _textPwd = TextEditingController();
  bool _validate = true;
  bool _validatePwd = false;
  bool _validUser = true;
  int attemp = 0;
  @override
  void initState() {
    super.initState();
    _text.addListener(validateMyInput);
    _textPwd.addListener(() {
      if (_textPwd.text.isEmpty) {
        setState(() {
          _validatePwd = false;
        });
      } else {
        setState(() {
          _validatePwd = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _text.dispose();
    _textPwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: <Widget>[
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
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
              controller: _textPwd,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  hintText: 'Introduce la contraseña')),
        ),
//        TextButton(
//            onPressed: () {
//              // Aquí va la ventana de olvidé mi contraseña
//            },
//            child: Text('Olvidé mi contraseña',
//                style: TextStyle(color: Colors.black, fontSize: 15))
//          ),
        Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: _validate && _validatePwd
                  ? Color.fromARGB(255, 132, 43, 87)
                  : Colors.black12,
              borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: !_validate || !_validatePwd
                ? null
                : () {
                    loginInput(_text.text, _textPwd.text);
                  },
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(child: Text('Olvidé mi contraseña'), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RestorePwd())) )
          ]
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
    );
    return content;
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

  Future loginInput(String emailInput, String passwordInput) async {
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
  }
}
