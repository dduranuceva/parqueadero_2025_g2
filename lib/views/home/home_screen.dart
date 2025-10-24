import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final _authService = AuthService();

  // Datos de SharedPreferences (NO sensibles)
  String? userName;
  String? userEmail;
  int? userId;

  // Datos de FlutterSecureStorage (SENSIBLES)
  String? token;
  String? tokenType;
  String? expiresIn;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    // Cargar datos de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('user_name');
    userEmail = prefs.getString('user_email');
    userId = prefs.getInt('user_id');

    // Cargar datos de FlutterSecureStorage
    token = await _secureStorage.read(key: 'token');
    tokenType = await _secureStorage.read(key: 'token_type');
    expiresIn = await _secureStorage.read(key: 'expires_in');

    setState(() => isLoading = false);
  }

  Future<void> _logout() async {
    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Realizar logout
      await _authService.logout();

      // Mostrar mensaje de confirmación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión cerrada exitosamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navegar al login
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Recargar datos',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bienvenida
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Bienvenido!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  userName ?? 'Usuario',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SharedPreferences
                  _buildSectionTitle(
                    'SharedPreferences',
                    'Datos NO sensibles (sin encriptar)',
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _buildDataCard(
                    icon: Icons.badge,
                    label: 'ID de Usuario',
                    value: userId?.toString() ?? 'No disponible',
                    color: Colors.orange,
                  ),
                  _buildDataCard(
                    icon: Icons.person,
                    label: 'Nombre',
                    value: userName ?? 'No disponible',
                    color: Colors.orange,
                  ),
                  _buildDataCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: userEmail ?? 'No disponible',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 24),

                  // FlutterSecureStorage
                  _buildSectionTitle(
                    'FlutterSecureStorage',
                    'Datos SENSIBLES (encriptados)',
                    Colors.green,
                  ),
                  const SizedBox(height: 8),
                  _buildDataCard(
                    icon: Icons.security,
                    label: 'Token JWT',
                    value: token != null
                        ? '${token!.substring(0, 30)}...'
                        : 'No disponible',
                    color: Colors.green,
                    isSecret: true,
                  ),
                  _buildDataCard(
                    icon: Icons.category,
                    label: 'Tipo de Token',
                    value: tokenType ?? 'No disponible',
                    color: Colors.green,
                  ),
                  _buildDataCard(
                    icon: Icons.timer,
                    label: 'Expira en',
                    value: expiresIn != null
                        ? '$expiresIn segundos'
                        : 'No disponible',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),

                  // Información educativa
                  _buildInfoCard(),
                  const SizedBox(height: 24),

                  // Botón de logout
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    MaterialColor color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color.shade700,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildDataCard({
    required IconData icon,
    required String label,
    required String value,
    required MaterialColor color,
    bool isSecret = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.shade100,
          child: Icon(icon, color: color.shade700),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          value,
          style: TextStyle(
            fontFamily: isSecret ? 'monospace' : null,
            fontSize: isSecret ? 12 : null,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  'Diferencias Clave',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'SharedPreferences',
              'Datos guardados en texto plano. Ideal para preferencias, configuraciones y datos no críticos.',
            ),
            const SizedBox(height: 8),
            _buildInfoItem(
              'FlutterSecureStorage',
              'Datos encriptados. Usa Keychain (iOS) y Keystore (Android). Ideal para tokens, contraseñas y datos sensibles.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
