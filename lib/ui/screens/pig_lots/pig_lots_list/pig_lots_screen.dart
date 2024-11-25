import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_pig_lots_services.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:porc_app/ui/screens/pig_lots/pig_lots_list/pig_lots_viewmodel.dart';
import 'package:porc_app/ui/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PigLotsScreen extends StatelessWidget {
  const PigLotsScreen({super.key, this.inversorSelected});
  final UserModel? inversorSelected;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    final now = DateTime.now();

    return ChangeNotifierProvider(
      create: (context) =>
          PigLotsViewmodel(DatabasePigLotsService(), inversorSelected!),
      child: Consumer<PigLotsViewmodel>(builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Lotes de ${inversorSelected!.name}"),
          ),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 10.h),
            child: Column(
              children: [
                20.verticalSpace,
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Lotes de ${inversorSelected?.name}", style: h)),
                20.verticalSpace,
                CustomTextfield(
                  isSearch: true,
                  hintText: "Nombre...",
                  titleText: "Buscar lote",
                  onChanged: model.search,
                ),
                10.verticalSpace,
                model.state == ViewState.loading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : model.pigLots.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text("No tiene lotes"),
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              itemCount: model.filteredPigLots.length,
                              separatorBuilder: (context, index) =>
                                  8.verticalSpace,
                              itemBuilder: (context, index) {
                                final pigLot = model.filteredPigLots[index];
                                return Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: buildPigLotCard(context, pigLot, inversorSelected ?? currentUser!, now),
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

  Widget buildPigLotCard(BuildContext context, PigLotsModel pigLot, UserModel inversorSelected, DateTime now) {
    final duration = now.difference(pigLot.weaningDate!);
    final months = (duration.inDays / 30).floor();
    final days = duration.inDays % 30;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Información del lote
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lote: ${pigLot.loteName ?? 'No Name'}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Tiempo de ceba: $months meses y $days días",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Cantidad: ${pigLot.females! + pigLot.males!}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        // Íconos de acciones
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.info, color: Colors.blue),
              onPressed: () {
                // Acción para ver más detalles
                Navigator.pushNamed(context, 
                pigLotDetail,
                    arguments: {
                  'pigLot': pigLot, // Objeto PigLotsModel
                  'inversorOwner': inversorSelected, // Objeto UserModel
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.food_bank, color: Colors.green),
              onPressed: () {
                // Acción para ingresar alimento
                Navigator.pushNamed(context, 
                feedHistory,
                    arguments: {
                  'pigLot': pigLot, // Objeto PigLotsModel
                  'inversor': inversorSelected
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.vaccines, color: Colors.red),
              onPressed: () {
                // Acción para ingresar vacunas
                //Navigator.pushNamed(context, 'vaccineEntryScreen',
                //    arguments: pigLot);
                // Acción para ingresar alimento
                /*Navigator.pushNamed(context, 
                feedHistory,
                    arguments: {
                  'pigLot': pigLot, // Objeto PigLotsModel
                  'inversor': inversorSelected
                });*/
              },
            ),
          ],
        )
      ],
    );
  }
}
