import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/core.dart';
import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/presentation/clients/controllers/client_controller.dart';
import 'package:qikcart/features/presentation/pos/controllers/pos_controller.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';

class PosView extends HookWidget {
  const PosView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final posController = Get.find<PosController>();

    Future<Client?> showCustomerSelector(BuildContext context) {
      return showModalBottomSheet<Client>(
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.8,
          child: CustomerSelector(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Aun no hay productos en el carrito'),
                  gap16,
                  FilledButton.icon(
                    onPressed: () {
                      Get.offAll(IndexScreens());
                    },
                    label: Text(
                      'Agregar Productos',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: edgeInsets16,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartController.cartItems[index];
                      return Card(
                        margin: edgeInsetsV8,
                        child: ListTile(
                          title: Text(cartItem.item.nombre),
                          subtitle: Text(
                              's/. ${cartItem.item.valorUnitario.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  cartController.decrementItem(
                                    cartController.cartItems[index],
                                  );
                                },
                              ),
                              space4,
                              Obx(() {
                                // Asegurémonos de que la UI se actualice con el cambio en cantidad
                                return Text(
                                  '${cartItem.cantidad.value}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                );
                              }),
                              space4,
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  cartController.incrementItem(
                                    cartController.cartItems[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      title: Text('Seleccionar Cliente'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final selectedClient =
                            await showCustomerSelector(context);
                        if (selectedClient != null) {
                          cartController.selectedClient.value = selectedClient;
                        }
                      },
                    ),
                    Obx(() {
                      final client = cartController.selectedClient.value;
                      return client != null
                          ? ListTile(
                              title: Text('Cliente: ${client.nombreComercial}'),
                              subtitle:
                                  Text('Documento: ${client.numeroDocumento}'),
                            )
                          : SizedBox.shrink();
                    }),
                    Divider(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: TextStyle(fontSize: 16)),
                          Text(
                              's/. ${cartController.subtotal.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax (0%)'),
                          Text('s/. ${cartController.tax.toStringAsFixed(2)}'),
                        ],
                      ),
                      Divider(thickness: 1, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total'),
                          Text('s/. ${cartController.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Datos del comprobante
                      final comprobanteData = {
                        "serie": "F002",
                        "numeroComprobante": "001001",
                        "emisor": 1,
                        "adquiriente": 2,
                        "tipoComprobante": "03",
                        "tipoOperacion": "0101",
                        "tipoPago": 1,
                        "codigoMoneda": 1,
                      };

                      // Datos de la factura
                      final invoiceData = {
                        "emisor": 1,
                        "comprador": 2,
                        "items": cartController.cartItems.map((item) {
                          return {
                            "id": item.item.id,
                            "quantity": item.cantidad.value
                          };
                        }).toList(),
                        "payTerms": [
                          {"metodo": "contado"}
                        ],
                        "observaciones": "Factura generada desde el carrito",
                        "tipoPago": 3,
                        "tipo_pdf": "A4",
                      };

                      await posController.facturarCarrito(
                        comprobanteData: comprobanteData,
                        invoiceData: invoiceData,
                      );
                    },
                    child: Text('Generar Factura'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // Aquí podrías navegar a otra vista o realizar el checkout.
                    },
                    child: Text(
                      'Pagar',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomerSelector extends HookWidget {
  const CustomerSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final clientController = Get.find<ClientController>();
    final searchController = useTextEditingController();
    final isLoading = useState(false);

    useEffect(() {
      clientController.loadClients(nombreComercial: '', numeroDocumento: '');
      return null;
    }, []);

    Future<void> fetchClients(String query) async {
      isLoading.value = true;
      try {
        clientController.clients.value =
            await clientController.getFilteredClients(query);
      } catch (e) {
        Get.snackbar('Error', 'No se pudieron cargar los clientes');
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Selecciona un cliente para continuar'),
          gap16,
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: 'Buscar Cliente',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 16,
                    ),
                    onPressed: () {
                      searchController.clear();
                      fetchClients('');
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      fetchClients(searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
          gap16,
          isLoading.value
              ? CircularProgressIndicator()
              : Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: clientController.clients.length,
                      itemBuilder: (context, index) {
                        final client = clientController.clients[index];
                        return ListTile(
                          title: Text(client.nombreComercial),
                          subtitle: Text(client.numeroDocumento),
                          onTap: () {
                            // Devuelve el cliente seleccionado
                            Navigator.pop(context, client);
                          },
                        );
                      },
                    );
                  }),
                ),
        ],
      ),
    );
  }
}
