import 'package:intl/intl.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_feed_service.dart';
import 'package:porc_app/core/utils/utilities.dart';
import 'package:porc_app/ui/screens/feed/feed_history/feed_history_viewmodel.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeedHistoryScreen extends StatelessWidget {
  const FeedHistoryScreen({super.key, required this.pigLot, this.inversor});
  final PigLotsModel pigLot;
  final UserModel? inversor;

  @override
  Widget build(BuildContext context) {
    final inversorSelected =
        inversor ?? Provider.of<UserProvider>(context).user;

    return ChangeNotifierProvider(
      create: (context) => FeedHistoryViewmodel(DatabaseFeedService(), pigLot),
      child: Consumer<FeedHistoryViewmodel>(builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Lote de ${inversorSelected!.name}"),
          ),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 10.h),
            child: Column(
              children: [
                20.verticalSpace,
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Alimentación de lote ${pigLot.loteName}",
                        style: h)),
                20.verticalSpace,
                model.state == ViewState.loading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : model.feedHistory.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text("No hay pedidos de alimentos aún"),
                            ),
                          )
                        : buildPigLotResumePanelList(context, model),
                Expanded(
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    itemCount: model.feedHistory.length,
                    separatorBuilder: (context, index) => 8.verticalSpace,
                    itemBuilder: (context, index) {
                      final pigLot = model.feedHistory[index];
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: buildPigLotCard(context, pigLot),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 
                feedRequest,
                    arguments: {
                  'pigLot': pigLot, // Objeto PigLotsModel
                });
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add, size: 28), // Ícono intuitivo
            tooltip: "Agregar nuevo alimento", // Accesibilidad y descripción de la acción
          ),
        );
      }),
    );
  }

  Widget buildPigLotCard(BuildContext context, FeedModel feed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Información del lote
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feed.pigFeedName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Bultos: ${feed.numberPackages}",
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              "Fecha del pedido: ${Utilities.formatDate(feed.date)}",
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              "Valor: \$${(feed.pigFeedPrice * feed.numberPackages).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 13),
            ),
            Row(children: [
              Text(
                "Estado del Pago: ${feed.isPaymentDone! ? 'Hecho el ${feed.paymentDate != null ? DateFormat.yMMMd().format(pigLot.paymentDate!) : ''}' : 'Pendiente'}",
                style: const TextStyle(fontSize: 13),
              ),
              SizedBox(width: 10),
              Icon(pigLot.isPaymentDone! ? Icons.check_circle : Icons.error,
                  color: pigLot.isPaymentDone! ? Colors.green : Colors.red,
                  size: 20)
            ])
          ],
        ),
      ],
    );
  }

  Widget buildPigLotResumePanelList(
      BuildContext context, FeedHistoryViewmodel model) {
    final groupedFeedHistory = model.groupedByFeedName;
    final List<String> _data = generateItems(1);
    final totalPackages = model.totalPackages;
    final totalPrice = model.totalPrice;

    int index = 0;

    return ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        model.toggleExpanded(panelIndex);
      },
      elevation: 1,
      children: _data.map<ExpansionPanel>((entry) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return Card(
              elevation: 0,
              child: ListTile(
                title: const Text("Resumen de alimentación",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total de Bultos Consumidos: $totalPackages"),
                    Text("Valor Total: \$${totalPrice.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detalles por Tipo de Alimento:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                ...groupedFeedHistory.entries.map((entry) {
                  final feedName = entry.key;
                  final feeds = entry.value;

                  final feedTotalPackages = feeds.fold<int>(
                    0,
                    (sum, feed) => sum + feed.numberPackages,
                  );

                  final feedTotalPrice = feeds.fold<double>(
                    0.0,
                    (sum, feed) =>
                        sum + (feed.pigFeedPrice * feed.numberPackages),
                  );

                  final isLastItem =
                      groupedFeedHistory.entries.toList().last.key == entry.key;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(feedName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Bultos: $feedTotalPackages"),
                                Text(
                                    "Valor: \$${feedTotalPrice.toStringAsFixed(2)}"),
                              ],
                            ),
                          ],
                        ),
                        if (!isLastItem)
                          const Divider(), // Agrega el Divider solo si no es el último
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          isExpanded: model.expanded[index++], // Usa el índice incremental
        );
      }).toList(),
    );
  }

  List<String> generateItems(int numberOfItems) {
    return List<String>.generate(numberOfItems, (int index) {
      return "";
    });
  }
}
