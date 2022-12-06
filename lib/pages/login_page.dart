import 'package:flutter/material.dart';
import 'package:flutter_firebase_multi_auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'drantunes.services@gmail.com');
  final _password = TextEditingController(text: '123456');

  bool _isLogin = true;
  bool _loading = false;
  late String _title;
  late String _actionButton;
  late String _toggleButton;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool showLoginScreen) {
    setState(() {
      _isLogin = showLoginScreen;
      if (_isLogin) {
        _title = 'Bem vindo';
        _actionButton = 'Login';
        _toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      } else {
        _title = 'Crie sua conta';
        _actionButton = 'Cadastrar';
        _toggleButton = 'Voltar ao Login.';
      }
    });
  }

  login() async {
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).login(_email.text, _password.text, readSmsCode);
    } on AuthException catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<String> readSmsCode() async {
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: const EdgeInsets.all(24),
        title: const Text('Código de Verificação SMS'),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Código SMS',
              ),
              initialValue: '123456',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('123456'),
            child: const Text('Confirmar'),
          )
        ],
      ),
    );
  }

  registrar() async {
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).createUser(_email.text, _password.text);
    } on AuthException catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o email corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informa sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_isLogin) {
                          login();
                        } else {
                          registrar();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (_loading)
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              const Icon(Icons.check),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  _actionButton,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setFormAction(!_isLogin),
                  child: Text(_toggleButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
