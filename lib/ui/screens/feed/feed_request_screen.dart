


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/extension/widget_extension.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/providers_model.dart';
import 'package:porc_app/core/services/database_feed_service.dart';
import 'package:porc_app/core/services/database_providers_service.dart';
import 'package:porc_app/ui/screens/feed/feed_request_viewmodel.dart';
import 'package:porc_app/ui/screens/providers/providers_viewmodel.dart';
import 'package:porc_app/ui/widgets/button_widget.dart';
import 'package:porc_app/ui/widgets/dropdown_widget.dart';
import 'package:porc_app/ui/widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

class FeedRequestScreen extends StatelessWidget {
  const FeedRequestScreen({super.key, required this.pigLot});
  final PigLotsModel pigLot;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FeedRequestViewmodel>(
          create: (context) => FeedRequestViewmodel(DatabaseFeedService()),
        ),
        ChangeNotifierProvider<ProvidersViewmodel>(
          create: (context) => ProvidersViewmodel(DatabaseProvidersService()),
        ),
      ],
      child: Consumer2<FeedRequestViewmodel, ProvidersViewmodel>(
          builder: (context, feedRequestModel, providersModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Alimento"),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 16.h),
            child: providersModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : providersModel.providers.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay proveedores disponibles",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    :  SingleChildScrollView(
              child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Solicitar alimento", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      5.verticalSpace,
                      const Text(
                        "Ingrese la información del pedido",
                        style: TextStyle(color: Colors.grey),
                      ),
                      30.verticalSpace,
                      CustomTextfield(
                        initialValue: pigLot.loteName,
                        titleText: "Lote",
                        isEnable: false,
                        onChanged: feedRequestModel.setName,
                      ),
                      15.verticalSpace,
                      CustomDropdown(
                        titleText: "Selecciona el proveedor",
                        items: providersModel.providersName,
                        value: providersModel.providersName.isNotEmpty ? providersModel.providersName.first : null, // Valor inicial
                        onChanged: (value) {
                          providersModel.selectProvider(value); // Actualiza el proveedor seleccionado
                          print("Seleccionaste: $value");

                        },
                        hintText: "Selecciona un proveedor",
                        isEnable: true, // Cambia a false para deshabilitar
                      ),
                      15.verticalSpace,
                      CustomDropdown(
                        titleText: "Selecciona el tipo de alimento",
                        items: providersModel.pigFeeds, // Lista de alimentos filtrados
                        value: providersModel.pigFeeds.isNotEmpty ? providersModel.pigFeeds.first : null, // Valor inicial
                        onChanged: (value) {
                          providersModel.selectPigFeed(value);
                          print("Seleccionaste: $value");
                        },
                        hintText: "Selecciona un alimento",
                        isEnable: providersModel.pigFeeds.isNotEmpty, // Habilita solo si hay alimentos
                      ),
                      15.verticalSpace,
                      CustomTextfield(
                        hintText: "Cantidad de bultos",
                        titleText: "Cantidad",
                        keyboardType: TextInputType.number,
                        //onChanged: feedRequestModel.setQuantity,
                      ),
                      30.verticalSpace,
                      CustomButton(
                        loading: feedRequestModel.state == ViewState.loading,
                        onPressed: feedRequestModel.state == ViewState.loading
                            ? null
                            : () async {
                                try {
                                  await feedRequestModel.save(pigLot, providersModel.selectedPigFeed!);
                                  context.showSnackbar("Solicitud guardada con éxito");
                                  Navigator.pop(context);
                                } catch (e) {
                                  context.showSnackbar(e.toString());
                                }
                              },
                        text: "Solicitar alimento",
                      ),
                    ],
                  )
            ),
          ),
        );
      }),
    );
  }
}
