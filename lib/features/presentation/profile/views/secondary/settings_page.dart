import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qikcart/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationsEnabled = true; // Estado de las notificaciones
  bool isAutoSyncEnabled = true; // Estado de sincronización automática
  String selectedLanguage = 'Español'; // Idioma preferido

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find(); // Obtén el controlador del tema

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Configuraciones',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Opción de Modo Oscuro
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() => SwitchListTile(
                    title: Text(
                      'Modo oscuro',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    value: themeController.isDarkMode.value,
                    activeColor: Colors.orange,
                    onChanged: (value) {
                      themeController.toggleTheme(value);
                    },
                  )),
            ),
            SizedBox(height: 16),

            // Opción de Notificaciones
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SwitchListTile(
                title: Text(
                  'Notificaciones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                value: isNotificationsEnabled,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    isNotificationsEnabled = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),

            // Opción de Idioma Preferido
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  'Idioma preferido',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(selectedLanguage),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showLanguageDialog();
                },
              ),
            ),
            SizedBox(height: 16),

            // Opción de Sincronización Automática
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SwitchListTile(
                title: Text(
                  'Sincronización automática',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                value: isAutoSyncEnabled,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    isAutoSyncEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo para seleccionar idioma
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar Idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Español'),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'Español';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Inglés'),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'Inglés';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Portugués'),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'Portugués';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
