import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/core.dart';
import 'secondary/edit_profile.dart';
import 'secondary/faq_page.dart';
import 'secondary/help_page.dart';
import 'secondary/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
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
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Get.toNamed(Routes.login.name); // Llama al método de logout
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Encabezado del perfil
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
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
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jorginho',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'jorginho20@gmail.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Get.to(EditProfilePage());
                        // Acción para editar el perfil
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Opciones en cards redondeados
              _buildMenuCard(
                context,
                icon: Icons.help_outline,
                text: 'Ayuda',
                onTap: () {
                  Get.to(HelpPage());
                  // Acción para esta opción
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.question_answer,
                text: 'FAQ',
                onTap: () {
                  Get.to(FAQPage());
                  // Acción para esta opción
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.settings,
                text: 'Configuraciones',
                onTap: () {
                  Get.to(SettingsPage());
                  // Acción para esta opción
                },
              ),
              _buildMenuCard(
                context,
                icon: Icons.logout,
                text: 'Cerrar sesión',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  _showLogoutDialog(context); // Acción para cerrar sesión
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
      Color textColor = Colors.black,
      Color iconColor = Colors.blue,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
