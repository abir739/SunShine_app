import 'package:flutter/material.dart';
import 'package:zenify_app/features/Activites/domain/entites/activite.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart'
    as not;

class ListActivitesWidget extends StatelessWidget {
  final List<Activite> activites;
  ListActivitesWidget({super.key, required this.activites});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 5),
      itemBuilder: (context, index) {
        return ListTile(
            leading: Text(activites[index].name.toString()),
            title: Text(
              activites[index].childPrice.toString(),
            ));
      },
      itemCount: activites.length,
    );
  }
}
