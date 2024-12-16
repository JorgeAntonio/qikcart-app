import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/providers/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    var textStyle = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuraciones',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => SwitchListTile(
                    title: Text(
                      'Modo oscuro',
                      style: textStyle.bodyMedium,
                    ),
                    value: themeController.isDarkMode.value,
                    activeColor: colorScheme.secondary,
                    onChanged: (value) {
                      themeController.toggleTheme(value);
                    },
                  )),
            ),
            gap16,
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  'Idioma preferido',
                  style: textStyle.bodyMedium,
                ),
                subtitle: Text(selectedLanguage),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showLanguageDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              // ListTile(
              //   title: Text('Inglés'),
              //   onTap: () {
              //     setState(() {
              //       selectedLanguage = 'Inglés';
              //     });
              //     Navigator.pop(context);
              //   },
              // ),
              // ListTile(
              //   title: Text('Portugués'),
              //   onTap: () {
              //     setState(() {
              //       selectedLanguage = 'Portugués';
              //     });
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
