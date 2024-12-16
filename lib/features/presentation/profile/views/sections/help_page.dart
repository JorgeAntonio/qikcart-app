import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayuda',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acerca de QikCart',
                      style: textStyle.titleMedium!.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    gap8,
                    Text(
                      '''QikCart es una aplicación de punto de venta diseñada para facilitar la gestión de productos, ventas y transacciones en pequeños y medianos negocios. Es intuitiva, rápida y optimizada para ofrecer la mejor experiencia al usuario.''',
                      style: textStyle.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            gap16,
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contacto del desarrollador',
                      style: textStyle.titleMedium!.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    gap8,
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: colorScheme.tertiary,
                          size: 16,
                        ),
                        space8,
                        Text('Jorge Antonio', style: textStyle.bodyMedium),
                      ],
                    ),
                    gap8,
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: colorScheme.tertiary,
                          size: 16,
                        ),
                        space8,
                        Text(
                          'jorge.antonio@example.com',
                          style: textStyle.bodyMedium,
                        ),
                      ],
                    ),
                    gap8,
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: colorScheme.tertiary,
                          size: 16,
                        ),
                        space8,
                        Text(
                          '+51 987 654 321',
                          style: textStyle.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            gap16,
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información de versión',
                      style: textStyle.titleMedium!.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    gap8,
                    Text(
                      'Versión: 1.0',
                      style: textStyle.bodyMedium,
                    ),
                    gap8,
                    Text(
                      'Última Update: Diciembre 2024',
                      style: textStyle.bodyMedium,
                    ),
                    gap8,
                    Text(
                      'www.qikcart.com',
                      style: textStyle.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
