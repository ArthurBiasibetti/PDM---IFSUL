import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:trabalho_2/Banco/banco.dart';
import 'package:trabalho_2/Page/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  var banco;

  final _formKey = GlobalKey<FormState>();
  final _formEmail = TextEditingController();
  final _formPassword = TextEditingController();
  final _formUserName = TextEditingController();

  final fEmail = FocusNode();
  final fUserName = FocusNode();
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

  String? _validateUsername(String? value) {
    if (value!.length > 0) {
      return null;
    }

    return "Nome de usuário obrigatório";
  }

  @override
  Widget build(BuildContext context) {
    banco = Banco((e) => print('Não foi possível estabelecer conexão - $e'));

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _formUserName,
                    focusNode: fUserName,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    validator: _validateUsername,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: const Text("Usuário"),
                      hintText: "Digite seu Usuário",
                      suffixIcon: const Icon(Icons.person),
                    ),
                  ),
                ),
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
                      _registrarPessoa(context);
                    }
                  },
                  child: const Text("Registrar"),
                ),
              ],
            ),
          )),
    );
  }

  _registrarPessoa(BuildContext context) {
    banco?.query(
        "insert into TB_USUARIO (email, password, username) values ('${_formEmail.text}', '${_formPassword.text}', '${_formUserName.text}')",
        (num, result) {
      Navigator.pop(context);
    }, (e) => print('Erro: $e'));
  }
}
