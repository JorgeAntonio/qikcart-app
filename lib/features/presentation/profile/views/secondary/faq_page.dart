import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FAQ',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faq['question']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      faq['answer']!,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
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
