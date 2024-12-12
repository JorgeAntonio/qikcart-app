import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': '¿Qué es QikCart?',
      'answer':
          'Es una aplicación de punto de venta diseñada para pequeños y medianos negocios, que facilita la gestión de productos, ventas y clientes.'
    },
    {
      'question': '¿Cómo configuro mi negocio en QikCart?',
      'answer':
          'Puedes registrar tu negocio desde la configuración inicial y agregar productos y categorías desde el panel principal.'
    },
    {
      'question': '¿QikCart es compatible con varios dispositivos?',
      'answer':
          'Sí, es compatible con dispositivos Android desde la versión 6.0 en adelante.'
    },
    {
      'question': '¿Cómo puedo contactar al soporte técnico?',
      'answer':
          'Puedes escribirnos al correo: soporte@qikcart.com o llamarnos al +51 987 654 321.'
    },
    {
      'question': '¿QikCart requiere conexión a internet?',
      'answer':
          'Sí, es necesario mantener una conexión constante a internet para utilizar todas las funciones.'
    },
  ];

  FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faq['question']!,
                      style: textStyle.titleSmall!.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    gap8,
                    Text(
                      faq['answer']!,
                      style: textStyle.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
