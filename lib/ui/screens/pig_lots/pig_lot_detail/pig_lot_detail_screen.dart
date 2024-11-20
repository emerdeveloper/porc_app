import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/utils/utilities.dart';

class PigLotDetailScreen extends StatelessWidget {
  const PigLotDetailScreen(
      {super.key, required this.pigLot, required this.inversorOwner});
  final PigLotsModel pigLot;
  final UserModel inversorOwner;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final duration = now.difference(pigLot.weaningDate!);
    final months = (duration.inDays / 30).floor();
    final days = duration.inDays % 30;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle del Lote"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), 
                child: SizedBox(
                  width: double.infinity, // Expande el Card horizontalmente
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lote ${pigLot.loteName!}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Tiempo de ceba: $months meses y $days días",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Propietario: ${inversorOwner.name!}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Cantidad cerdos: ${pigLot.females! + pigLot.males!}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "${pigLot.males} machos / ${pigLot.females} hembras",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Fecha destete: ${Utilities.formatDate(pigLot.weaningDate!)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                       /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                          "Cantidad: ${pigLot.females! + pigLot.males!}",
                          style: const TextStyle(fontSize: 16),
                        ),
                    Text(
                          "${pigLot.males} machos / ${pigLot.females} hembras",
                          style: const TextStyle(fontSize: 16),
                        ),
                  ],
                ),*/
                const Divider(),
                Text(
                          "Valor",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Valor lechón: ${pigLot.pigletPrice!}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Valor total del lote: ${pigLot.pigletPrice! * (pigLot.males! + pigLot.females!)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(
                            "Estado del Pago: ${pigLot.isPaymentDone! ? 
                            'Hecho el ${pigLot.paymentDate != null ? Utilities.formatDate(pigLot.paymentDate!) : ''}' :
                            'Pendiente'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            pigLot.isPaymentDone! ? Icons.check_circle : Icons.error, 
                          color: pigLot.isPaymentDone! ? Colors.green : Colors.red, 
                          size: 20)
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              30.verticalSpace,
//Alimentación
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), 
                child: SizedBox(
                  width: double.infinity, // Expande el Card horizontalmente
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alimentación ${pigLot.loteName!}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Tiempo de ceba: $months meses y $days días",
                          style: const TextStyle(fontSize: 16),
                        )
                      ]
                    )
                  )
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String content,
    required IconData icon,
    Color iconColor = Colors.blue,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
