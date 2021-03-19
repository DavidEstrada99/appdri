import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Student.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _text = TextEditingController();
  bool _validate = false;
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: <Widget>[
        Container(
          height: 150.0,
          width: 190.0,
          padding: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(200)),
          child: Center(
            child: Image.asset('../asset/images/logo-ipn.png'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          // margin: EdgeInsets.only(top: 300.0, left: 120.0),
          child: TextField(
            controller: _text,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              errorText: _validate ? 'Tiene que ser un email válido' : null,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          // margin: EdgeInsets.only(top: 30.0, left: 120.0),
          child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  hintText: 'Introduce la contraseña')),
        ),
        TextButton(
            onPressed: () {
              // Aquí va la ventana de olvidé mi contraseña
            },
            child: Text('Olvidé mi contraseña',
                style: TextStyle(color: Colors.black, fontSize: 15))),
        Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 132, 43, 87),
              borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => StudentHome()));
            },
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        )
      ],
    );
    return content;
  }

  bool validateMyInput(String input) {
    Pattern pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(input))
      return false;
    else
      return true;
  }
}
