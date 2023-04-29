import 'package:flutter/material.dart';

import 'model/user.dart';

class ContactListView extends StatelessWidget {
  const ContactListView({
    super.key,
    required this.users,
    this.onEditContact,
  });

  final List<UserModel> users;
  final void Function(UserModel user, int position)? onEditContact;

  Future<void> deleteUser(UserModel user) async {
    user.delete();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        // SE PASSAR O AVATAR MOSTRA, SENAO MOSTRA UM AVATAR PADRAO !!!

        final avatar = users[index].avatarUrl.isEmpty
            ? const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
              )
            : CircleAvatar(
                child: Image(
                  image: NetworkImage(users[index].avatarUrl),
                ),
              );
        return Card(
          child: ExpansionTile(
            leading: avatar,
            title: Text(
              '${users[index].user_id} - ${users[index].email}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(users[index].user_name),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      //ARRUMADO O EDITAR (SEM DELETAR USUARIO) !!!

                      onEditContact!(users[index], index);
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.amber,
                    ),
                    label: const Text(
                      'Editar',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => deleteUser(users[index]),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Excluir",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
