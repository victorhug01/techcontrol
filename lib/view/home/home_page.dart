import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/model/sign_out_model.dart';
import 'package:techcontrol/viewmodel/sign_out_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  final supabase = Supabase.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Map<String, dynamic>? maintenanceProfile;
  Map<String, dynamic>? openService;
  Map<String, dynamic>? clientData;
  bool isLoading = true;
  String? debugMessage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkMaintenanceProfile();
    if (maintenanceProfile != null) {
      await _checkOpenServices();
      await _updateNotificationToken();
    }
    setState(() => isLoading = false);
  }

  Future<void> _updateNotificationToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null && maintenanceProfile != null) {
      await supabase.client.from('maintenance').update({
        'token_notification': token, // Corrigido para token_notification
      }).eq('id_maintenance', maintenanceProfile!['id_maintenance']);
    }
  }

  Future<void> _checkMaintenanceProfile() async {
    final userId = supabase.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() => debugMessage = 'Usuário não autenticado');
      return;
    }

    try {
      // CORREÇÃO: usando id_supabase (como está na tabela)
      final response = await supabase.client
          .from('maintenance')
          .select()
          .eq('id_supabase', userId) // Campo corrigido
          .maybeSingle();

      if (response != null && response.isNotEmpty) {
        setState(() {
          maintenanceProfile = response;
          debugMessage = 'Perfil encontrado com ID: ${response['id_maintenance']}';
        });
      } else {
        setState(() {
          debugMessage = 'Perfil não encontrado. Verifique se existe um registro com '
                        'id_supabase = $userId na tabela maintenance';
        });
      }
    } catch (e) {
      setState(() => debugMessage = 'Erro ao buscar perfil: $e');
    }
  }

  Future<void> _checkOpenServices() async {
  if (maintenanceProfile == null) return;

  try {
    final serviceResponse = await supabase.client
        .from('service')
        .select()
        .eq('fk_id_maintenance', maintenanceProfile!['id_maintenance'])
        .eq('status', 'EM AGUARDE')
        .maybeSingle();

    if (serviceResponse != null && serviceResponse.isNotEmpty) {
      setState(() => openService = serviceResponse);

      // Corrected to use fk_id_client from service table
      final clientResponse = await supabase.client
          .from('client')
          .select()
          .eq('id_client', serviceResponse['fk_id_client']) // Changed to fk_id_client
          .maybeSingle();

      setState(() => clientData = clientResponse);
    } else {
      setState(() {
        openService = null;
        clientData = null;
      });
    }
  } catch (e) {
    setState(() => debugMessage = 'Erro ao buscar serviços: $e');
  }
}

  Future<void> _acceptService() async {
    if (openService == null) return;

    try {
      await supabase.client
          .from('service')
          .update({'status': 'CONCERTANDO'})
          .eq('id_service', openService!['id_service']);

      await _checkOpenServices();
    } catch (e) {
      setState(() => debugMessage = 'Erro ao aceitar serviço: $e');
    }
  }

  Future<void> _finishService() async {
    if (openService == null || maintenanceProfile == null || clientData == null) return;

    try {
      await supabase.client.from('service').update({'status': 'FINALIZADO'}).eq(
          'id_service', openService!['id_service']);

      await supabase.client.from('client').update({'status': 'FINALIZADO'}).eq(
          'id_client', clientData!['id_client']); // Campo corrigido

      await supabase.client.from('maintenance').update({'status': 'FINALIZADO'}).eq(
          'id_maintenance', maintenanceProfile!['id_maintenance']);

      setState(() {
        openService = null;
        clientData = null;
      });
    } catch (e) {
      setState(() => debugMessage = 'Erro ao finalizar serviço: $e');
    }
  }

  Widget _buildProfileCompletionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Cadastro de técnico não encontrado'),
            const SizedBox(height: 16),
            if (debugMessage != null)
              Text(
                debugMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Completar cadastro'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _initialize,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard() {
    if (clientData == null || openService == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Nenhum serviço em aberto'),
              if (debugMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    debugMessage!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${clientData!['contact'] ?? 'Não informado'}'),
            Text('Endereço: ${clientData!['address'] ?? 'Não informado'}'),
            Text('Problema: ${clientData!['problem'] ?? 'Não informado'}'),
            Text('Descrição: ${clientData!['problem_dass'] ?? 'Não informado'}'), // Campo corrigido
            const SizedBox(height: 16),
            if (openService!['status'] == 'EM ABERTO')
              ElevatedButton(
                onPressed: _acceptService,
                child: const Text('Aceitar Serviço'),
              ),
            if (openService!['status'] == 'CONCERTANDO')
              ElevatedButton(
                onPressed: _finishService,
                child: const Text('Finalizar Serviço'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TechControl - Técnico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              if (context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    );
                  },
                );
              }
              await context.read<SignOutViewModel>().signOut(SignOutModel());
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (maintenanceProfile == null) _buildProfileCompletionCard(),
            if (maintenanceProfile != null) ...[
              const SizedBox(height: 8),
              _buildServiceCard(),
            ],
          ],
        ),
      ),
    );
  }
}