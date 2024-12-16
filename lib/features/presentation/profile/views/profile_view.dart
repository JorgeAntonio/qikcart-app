import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/core.dart';
import 'sections/edit_profile.dart';
import 'sections/faq_page.dart';
import 'sections/help_page.dart';
import 'sections/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                'Cerrar sesión',
                style: TextStyle(color: colorTheme.error),
              ),
              onPressed: () {
                AuthProvider.logout();
                Get.toNamed(Routes.login.name);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorTheme.primaryContainer.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    space12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tara',
                            style: textTheme.titleMedium,
                          ),
                          Text(
                            'tara20@gmail.com',
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: colorTheme.tertiary,
                      ),
                      onPressed: () {
                        Get.to(EditProfilePage());
                      },
                    ),
                  ],
                ),
              ),
              gap20,
              _buildMenuCard(
                context,
                icon: Icons.help_outline,
                text: 'Ayuda',
                onTap: () {
                  Get.to(HelpPage());
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.question_answer,
                text: 'FAQ',
                onTap: () {
                  Get.to(FAQPage());
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.settings,
                text: 'Configuraciones',
                onTap: () {
                  Get.to(SettingsPage());
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.logout,
                text: 'Cerrar sesión',
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.tertiary),
        title: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
