import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techcontrol/app/theme.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> with AutomaticKeepAliveClientMixin{
  final _future = Supabase.instance.client.from('client').select();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final services = snapshot.data!;
              final filteredServices =
                  services.where((service) {
                    final problem = service['problem'].toString().toLowerCase();
                    final desc = service['problem_desc'].toString().toLowerCase();
                    final query = _searchQuery.toLowerCase();
                    return problem.contains(query) || desc.contains(query);
                  }).toList();

              return Column(
                children: [
                  // 🔍 Campo de busca
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Text(
                      'Demanda em processo',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: ((context, index) {
                        final service = filteredServices[index];
                        return Card(
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(
                                    Icons.show_chart,
                                    color: AppTheme.lightTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  service['problem'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D2353),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Especificidade da demanda',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.lightTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Distância',
                                          style: TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '10km',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:  AppTheme.lightTheme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Média',
                                          style: TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '9 min',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0D2353),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Especificidade da demanda',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.lightTheme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Text(
                                    service['problem_desc'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 14, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
