import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_user_service.dart';
import 'package:porc_app/ui/screens/inversors/inversors_viewmodel.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:porc_app/ui/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InversorsScreen extends StatelessWidget {
  const InversorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    final inversorSelected = Provider.of<UserProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => InversorsViewmodel(DatabaseUserService(), currentUser),
      child: Consumer<InversorsViewmodel>(builder: (context, model, _) {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 10.h),
          child: Column(
            children: [
              30.verticalSpace,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Accionistas", style: h)),
              /*20.verticalSpace,
              CustomTextfield(
                isSearch: true,
                hintText: "Search here...",
                titleText: "buscar",
                onChanged: model.search,
              ),
              10.verticalSpace,*/
              model.state == ViewState.loading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : model.users.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text("No Users yet"),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                          itemCount: model.filteredUsers.length,
                          separatorBuilder: (context, index) => 8.verticalSpace,
                          itemBuilder: (context, index) {
                            final UserModel user = model.filteredUsers[index];
                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: buildWidget(context, user, inversorSelected),
                              ),
                            );
                          },
                        )
                        )
            ],
          ),
        );
      }),
    );
  }

  Widget buildWidget(context, UserModel user, UserProvider inversorSelected) => ListTile(
leading: CircleAvatar(
  backgroundColor: primary,//Colors.blue, // Cambia el color según desees
  radius: 25,
  child: Text(
    user.name!.isNotEmpty ? user.name![0].toUpperCase() : '',
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
),
  title: Text( "${user.name}",
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
  subtitle: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('sin mensajes',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey),
      ),
      /*if (user.unreadCounter != null && user.unreadCounter! > 0)
        Text(
          'Unread: ${user.unreadCounter}',
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),*/
    ],
  ),
  trailing: const Icon(
    Icons.arrow_forward_ios, // Icono de flecha
    size: 16,               // Tamaño del icono
    color: grey,     // Color del icono
  ),
  onTap: () =>  {
    //inversorSelected.inversorSelected(user),
    Navigator.pushNamed(
    context,
    pigLots,
    arguments: {
                  'inversor': user,
                },
  )
  },
);
}