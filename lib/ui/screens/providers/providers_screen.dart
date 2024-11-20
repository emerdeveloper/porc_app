import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/services/database_providers_service.dart';
import 'package:porc_app/ui/screens/providers/providers_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProvidersScreen extends StatelessWidget {
  const ProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProvidersViewmodel(DatabaseProvidersService()),
      child: Consumer<ProvidersViewmodel>(builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Proveedores de alimentos"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: model.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : model.providers.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay proveedores disponibles",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : SingleChildScrollView(
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            model.toggleExpanded(index);
                          },
                          elevation: 1, 
                          children: model.providers.map<ExpansionPanel>((provider) {
                            final index = model.providers.indexOf(provider);
                            return ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return Card(
                                  elevation: 0,
                                  child: ListTile(
                                    title: Text(provider.name,  style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(provider.owner),
                                  ),
                                );
                              },
                              body: Column(
                                children: provider.pigFeed
                                    .map((feed) => ListTile(
                                          leading: const Icon(Icons.food_bank),
                                          title: Text(feed.name),
                                          subtitle: Text("Cantidad: ${feed.price}"),
                                        ))
                                    .toList(),
                              ),
                              isExpanded: model.expanded[index],
                            );
                          }).toList(),
                        ),
                      ),
          ),
        );
      }),
    );
  }
}