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

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final supabase = Supabase.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Map<String, dynamic>? maintenanceProfile;
  Map<String, dynamic>? openService;
  Map<String, dynamic>? clientData;
  bool isLoading = true;
  String? debugMessage;
  bool isAccepting = false;
  bool isRejecting = false;
  bool isFinishing = false;

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
        'token_notification': token,
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
      final response = await supabase.client
          .from('maintenance')
          .select()
          .eq('id_supabase', userId)
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
      // Busca serviços EM AGUARDE ou CONCERTANDO para este técnico
      final serviceResponse = await supabase.client
          .from('service')
          .select()
          .or('status.eq.EM AGUARDE,status.eq.CONCERTANDO')
          .eq('fk_id_maintenance', maintenanceProfile!['id_maintenance'])
          .maybeSingle();

      if (serviceResponse != null && serviceResponse.isNotEmpty) {
        setState(() => openService = serviceResponse);

        final clientResponse = await supabase.client
            .from('client')
            .select()
            .eq('id_client', serviceResponse['fk_id_client'])
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
    if (openService == null || maintenanceProfile == null || clientData == null) return;

    setState(() => isAccepting = true);
    
    try {
      // Atualiza o status do serviço para CONCERTANDO
      await supabase.client
          .from('service')
          .update({'status': 'CONCERTANDO'})
          .eq('id_service', openService!['id_service']);

      // Atualiza o status do técnico para EM MANUTENÇÃO
      await supabase.client
          .from('maintenance')
          .update({'status': 'EM MANUTENÇÃO'})
          .eq('id_maintenance', maintenanceProfile!['id_maintenance']);

      // Atualiza o status do cliente para EM MANUTENÇÃO
      await supabase.client
          .from('client')
          .update({'status': 'EM MANUTENÇÃO'})
          .eq('id_client', clientData!['id_client']);

      // Atualiza o serviço localmente
      setState(() {
        openService = {...openService!, 'status': 'CONCERTANDO'};
      });
    } catch (e) {
      setState(() => debugMessage = 'Erro ao aceitar serviço: $e');
    } finally {
      setState(() => isAccepting = false);
    }
  }

  Future<void> _rejectService() async {
    if (openService == null) return;

    setState(() => isRejecting = true);
    
    try {
      // Atualiza o status do serviço para RECUSADO
      await supabase.client
          .from('service')
          .update({'status': 'RECUSADO'})
          .eq('id_service', openService!['id_service']);

      // Recarrega os dados
      await _checkOpenServices();
    } catch (e) {
      setState(() => debugMessage = 'Erro ao recusar serviço: $e');
    } finally {
      setState(() => isRejecting = false);
    }
  }

  Future<void> _finishService() async {
    if (openService == null || maintenanceProfile == null || clientData == null) return;

    setState(() => isFinishing = true);

    try {
      await supabase.client.from('service').update({'status': 'FINALIZADO'}).eq(
          'id_service', openService!['id_service']);

      await supabase.client.from('client').update({'status': 'FINALIZADO'}).eq(
          'id_client', clientData!['id_client']);

      await supabase.client.from('maintenance').update({'status': 'ATIVO'}).eq(
          'id_maintenance', maintenanceProfile!['id_maintenance']);

      setState(() {
        openService = null;
        clientData = null;
      });
    } catch (e) {
      setState(() => debugMessage = 'Erro ao finalizar serviço: $e');
    } finally {
      setState(() => isFinishing = false);
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
            Text('Descrição: ${clientData!['problem_desc'] ?? 'Não informado'}'),
            const SizedBox(height: 16),
            
            // Se o serviço estiver EM AGUARDE, mostra botões de Aceitar/Recusar
            if (openService!['status'] == 'EM AGUARDE')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isRejecting ? null : _rejectService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: isRejecting 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Recusar Serviço'),
                  ),
                  ElevatedButton(
                    onPressed: isAccepting ? null : _acceptService,
                    child: isAccepting 
                        ? const CircularProgressIndicator()
                        : const Text('Aceitar Serviço'),
                  ),
                ],
              ),
            
            // Se o serviço estiver CONCERTANDO, mostra botão de Finalizar
            if (openService!['status'] == 'CONCERTANDO')
              Center(
                child: ElevatedButton(
                  onPressed: isFinishing ? null : _finishService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                  ),
                  child: isFinishing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Finalizar Serviço', style: TextStyle(fontSize: 16)),
                ),
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