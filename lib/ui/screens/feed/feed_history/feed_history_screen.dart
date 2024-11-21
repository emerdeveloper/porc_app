import 'package:intl/intl.dart';
import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_feed_service.dart';
import 'package:porc_app/core/services/database_pig_lots_services.dart';
import 'package:porc_app/core/utils/utilities.dart';
import 'package:porc_app/ui/screens/feed/feed_history/feed_history_viewmodel.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:porc_app/ui/screens/pig_lots/pig_lots_viewmodel.dart';
import 'package:porc_app/ui/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeedHistoryScreen extends StatelessWidget {
  const FeedHistoryScreen({super.key, required this.pigLot});
  final PigLotsModel pigLot;

  @override
  Widget build(BuildContext context) {
    final inversorSelected = Provider.of<UserProvider>(context).inversor;

    return ChangeNotifierProvider(
      create: (context) =>
          FeedHistoryViewmodel(DatabaseFeedService(), pigLot),
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
                    child: Text("Alimentación de lote ${pigLot.loteName}", style: h)),
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
                        : Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              itemCount: model.feedHistory.length,
                              separatorBuilder: (context, index) =>
                                  8.verticalSpace,
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
              "Valor: ${feed.pigFeedPrice * feed.numberPackages}",
              style: const TextStyle(fontSize: 13),
            ),
            Row(
                          children: [
                            Text(
                            "Estado del Pago: ${feed.isPaymentDone! ? 
                            'Hecho el ${feed.paymentDate != null ? DateFormat.yMMMd().format(pigLot.paymentDate!) : ''}' :
                            'Pendiente'}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            pigLot.isPaymentDone! ? Icons.check_circle : Icons.error, 
                          color: pigLot.isPaymentDone! ? Colors.green : Colors.red, 
                          size: 20)
                          ]
                        )
          ],
        ),
      ],
    );
  }
}
