import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:trabalho_2/Banco/banco.dart';
import 'package:trabalho_2/Page/LoginPage.dart';
import 'package:trabalho_2/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _RegisterState();
}

class _RegisterState extends State<LoginPage> {
  var banco;

  final _formKey = GlobalKey<FormState>();
  final _formEmail = TextEditingController();
  final _formPassword = TextEditingController();
  final fEmail = FocusNode();
  final fPassword = FocusNode();

  bool _isShowingPassword = false;

  void _changePasswordVisibility() {
    setState(() {
      _isShowingPassword = !_isShowingPassword;
    });
  }

  String? _validateEmail(String? value) {
    if (EmailValidator.validate(value!)) {
      return null;
    }

    return "E-mail é invalido";
  }

  String? _validatePassword(String? value) {
    if (value!.length > 3) {
      return null;
    }

    return "Password tem que ter pelo menos 3 caracteres";
  }

  @override
  Widget build(BuildContext context) {
    banco = Banco((e) => print('Não foi possível estabelecer conexão - $e'));

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _formEmail,
                    focusNode: fEmail,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: const Text("Email"),
                      hintText: "Digite seu Email",
                      suffixIcon: const Icon(Icons.alternate_email),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _formPassword,
                    obscureText: !_isShowingPassword,
                    focusNode: fPassword,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: const Text("Password"),
                      hintText: "Digite sua senha",
                      suffixIcon: IconButton(
                        icon: Icon(_isShowingPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: _changePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    bool validity = _formKey.currentState!.validate();
                    if (validity) {
                      _logar(context);
                    }
                  },
                  child: const Text("Logar-se"),
                ),
              ],
            ),
          )),
    );
  }

  _logar(context) {
    banco?.query(
        "select * from tb_usuario where email = '${_formEmail.text}' and password = '${_formPassword.text}'",
        (numR, result) {
      if (numR == 0) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Invalido!'),
              content: Text(
                'Email ou senha inválidos!',
                style: TextStyle(fontSize: 16),
              ),
            );
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Trabalho - Arthur'),
          ),
        );
      }
    }, (e) => print('Erro: $e'));
  }
}
