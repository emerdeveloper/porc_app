import 'package:porc_app/core/constants/colors.dart';
import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/constants/styles.dart';
import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_service.dart';
import 'package:porc_app/ui/screens/pig_lots/pig_lots_viewmodel.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:porc_app/ui/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PigLotsScreen extends StatelessWidget {
  const PigLotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return ChangeNotifierProvider(
      create: (context) => PigLotsViewmodel(DatabaseService(), currentUser),
      child: Consumer<PigLotsViewmodel>(builder: (context, model, _) {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 1.sw * 0.05, vertical: 10.h),
          child: Column(
            children: [
              30.verticalSpace,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Chats", style: h)),
              20.verticalSpace,
              CustomTextfield(
                isSearch: true,
                hintText: "Search here...",
                titleText: "buscar",
                onChanged: model.search,
              ),
              10.verticalSpace,
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            itemCount: model.filteredUsers.length,
                            separatorBuilder: (context, index) =>
                                8.verticalSpace,
                            itemBuilder: (context, index) {
                              final user = model.filteredUsers[index];
                              return buildWidget(context, user);
                              /*return ChatTile(
                                user: user,
                                onTap: () => Navigator.pushNamed(
                                    context, chatRoom,
                                    arguments: user),
                              );*/
                            },
                          ),
                        )
            ],
          ),
        );
      }),
    );
  }

  Widget buildWidget(context, user) => ListTile(
  leading: CircleAvatar(
    backgroundImage: user.imageUrl != null
        ? NetworkImage(user.imageUrl!)
        : Image.asset(profileIcon) as ImageProvider,
    radius: 25,
  ),
  title: Text(
    user.name ?? 'No Name',
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        user.lastMessage?['content'] ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      if (user.unreadCounter != null && user.unreadCounter! > 0)
        Text(
          'Unread: ${user.unreadCounter}',
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
    ],
  ),
  onTap: () => Navigator.pushNamed(
    context,
    chatRoom,
    arguments: user,
  ),
);

}