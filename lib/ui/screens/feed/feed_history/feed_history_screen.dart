import 'package:intl/intl.dart';
import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_feed_service.dart';
import 'package:porc_app/core/utils/utilities.dart';
import 'package:porc_app/ui/screens/feed/feed_history/feed_history_viewmodel.dart';
import 'package:porc_app/ui/screens/others/preview_payment_provider.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:porc_app/ui/widgets/preview_payment_widget.dart';
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
      child: Consumer<FeedHistoryViewmodel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Lote de ${inversorSelected!.name}"),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 1.sw * 0.05, vertical: 10.h),
                  child: Column(
                    children: [
                      20.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Alimentación de lote ${pigLot.loteName}",
                          style: h,
                        ),
                      ),
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
                                    child:
                                        Text("No hay pedidos de alimentos aún"),
                                  ),
                                )
                              : buildPigLotResumePanelList(context, model),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          itemCount: model.feedHistory.length,
                          separatorBuilder: (context, index) => 8.verticalSpace,
                          itemBuilder: (context, index) {
                            final pigLot = model.feedHistory[index];
                            final isSelected = model.selectedIndex == index;
                            return GestureDetector(
                              onTap: (context.read<PreviewPaymentProvider>().sharedFiles == null) ? 
                              () {} : 
                              () => model.selectFeed(index),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.1)
                                    : null, // Cambia el color si está seleccionado
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                              buildPigLotCard(context, pigLot)),
                                      if (isSelected)
                                        const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: primary,
                                          child: Icon(Icons.check,
                                              size: 16, color: white),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Agregar PreviewPayment con otro Consumer
                Consumer<PreviewPaymentProvider>(
                  builder: (context, previewProvider, _) {
                    if (previewProvider.sharedFiles == null) return SizedBox();

                    final isSelected = context.read<FeedHistoryViewmodel>().selectedIndex != null;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: PreviewPayment(
                        sharedFiles: previewProvider.sharedFiles!,
                        isSelected: isSelected,
                        onPressed: () => {},
                      ),
                    );
                  },
                ),
              ],
            ),
            floatingActionButton: Consumer<PreviewPaymentProvider>(
              builder: (context, previewProvider, _) {
                return previewProvider.sharedFiles == null
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            feedRequest,
                            arguments: {'pigLot': pigLot},
                          );
                        },
                        backgroundColor: primary,
                        tooltip: "Agregar nuevo alimento",
                        child: Icon(
                          Icons.add,
                          size: 28,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : const SizedBox
                        .shrink(); // Widget vacío cuando no se muestra el FAB
              },
            ),
          );
        },
      ),
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
              const SizedBox(width: 10),
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
    final List<int> _data = generateItems(2);

    int index = 0;

    return ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        model.toggleExpanded(panelIndex);
      },
      elevation: 1,
      children: _data.map<ExpansionPanel>((entry) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return entry == 0 ? headerDetail() : headerFeed(model);
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: entry == 0 ? bodyDetail() : bodyFeed(groupedFeedHistory),
          ),
          isExpanded: model.expanded[index++], // Usa el índice incremental
        );
      }).toList(),
    );
  }

  Column bodyDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Información de talladada del lote:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text("Propietario: ${inversorOwner.name!}"),
              Text("Cantidad cerdos: ${pigLot.females! + pigLot.males!}"),
              Text("${pigLot.males} machos / ${pigLot.females} hembras"),
              //Text("Fecha destete: ${Utilities.formatDate(pigLot.weaningDate!)}"),
              const Divider(),
              Text("Valor lechón: ${pigLot.pigletPrice!}"),
              Text(
                  "Valor total del lote: ${pigLot.pigletPrice! * (pigLot.males! + pigLot.females!)}"),
              Row(children: [
                Text(
                  "Estado del Pago: ${pigLot.isPaymentDone! ? 'Hecho el ${pigLot.paymentDate != null ? Utilities.formatDate(pigLot.paymentDate!) : ''}' : 'Pendiente'}",
                  //style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Icon(pigLot.isPaymentDone! ? Icons.check_circle : Icons.error,
                    color: pigLot.isPaymentDone! ? Colors.green : Colors.red,
                    size: 20)
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Column bodyFeed(Map<String, List<FeedModel>> groupedFeedHistory) {
    return Column(
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
            (sum, feed) => sum + (feed.pigFeedPrice * feed.numberPackages),
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
                        Text("Valor: \$${feedTotalPrice.toStringAsFixed(2)}"),
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
    );
  }

  Card headerFeed(FeedHistoryViewmodel model) {
    final totalPackages = model.totalPackages;
    final totalPrice = model.totalPrice;
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
  }

  Card headerDetail() {
    final now = DateTime.now();
    final duration = now.difference(pigLot.weaningDate!);
    final months = (duration.inDays / 30).floor();
    final days = duration.inDays % 30;
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text("Detalle del lote ${pigLot.loteName!}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha destete: ${Utilities.formatDate(pigLot.weaningDate!)}"),
            Text("Tiempo de ceba: $months meses y $days días"),
          ],
        ),
      ),
    );
  }

  List<int> generateItems(int numberOfItems) {
    return List<int>.generate(numberOfItems, (int index) {
      return index;
    });
  }
}
