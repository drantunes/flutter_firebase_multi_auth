import 'package:flutter/material.dart';
import 'package:flutter_firebase_multi_auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final String phoneNumber = '+5555999990000';

  enableTwoFactor(BuildContext context, bool value) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            const Expanded(child: Text('Autenticação 2 Fatores')),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        children: [
          const Text('Informe seu número de celular para habilitar a autenticação 2 fatores:'),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Celular',
              ),
              initialValue: phoneNumber,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(phoneNumber),
            child: const Text('Ativar'),
          )
        ],
      ),
    );

    await ref.read(authServiceProvider).enableTwoFactor(phoneNumber, readSmsCode);
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

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(authServiceProvider).isMultiFactorEnabled;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: ref.read(authServiceProvider).logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Card(
              child: Center(
                child: SwitchListTile(
                  value: enabled,
                  onChanged: (val) => !enabled
                      ? enableTwoFactor(context, val)
                      : ref.read(authServiceProvider).disableTwoFactor(),
                  title: Text(enabled ? 'Desabilitar 2FA' : 'Habilitar 2Fa'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
