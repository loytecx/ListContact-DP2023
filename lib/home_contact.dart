import 'package:contact_crud_hive/common/box_user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'contact_listview.dart';
import 'form_contact_fielder.dart';
import 'model/user.dart';

// ESSA CLASSE RENDERIZA A TELA PRINCIPAL

class HomeContact extends StatefulWidget {
  const HomeContact({super.key});

  @override
  State<HomeContact> createState() => _HomeContactState();
}

class _HomeContactState extends State<HomeContact> {
  final _formKey = GlobalKey<FormState>();

  final idUserControl = TextEditingController();
  final nameUserControl = TextEditingController();
  final emailUserControl = TextEditingController();
  final avatarUserControl = TextEditingController();

  // ADICIONADAS VARIAVEIS PARA EDITAR E LISTAR OS CONTATOS !!!

  bool isEditing = false;
  int position = -1;

  bool listando = false;

 //  DESCARTA TODOS OS RECURSOS
  @override
  void dispose() {
    idUserControl.dispose();
    nameUserControl.dispose();
    emailUserControl.dispose();
    avatarUserControl.dispose();
    Hive.close(); // fechar as boxes
    super.dispose();
  }


  // ADICIONA O CONTATO APÓS VALIDADO
  Future<void> addUser(
      String id, String name, String email, String avatar) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = UserModel()
        ..user_id = id
        ..user_name = name
        ..email = email
        ..avatarUrl = avatar;

      // pega a caixa aberta
      final box = UserBox.getUsers();
      if (isEditing) {
        box.putAt(position, user);
      } else {
        box.add(user);
      }
      _clearTextControllers();
    }
  }

  //ARRUMADO O EDITAR (SEM DELETAR USUARIO) !!!

  Future<void> editUser(UserModel user, int position) async {
    idUserControl.text = user.user_id;
    nameUserControl.text = user.user_name;
    emailUserControl.text = user.email;

    //ARRUMADO O EDITAR (SEM DELETAR USUARIO) !!!

    this.position = position;
    isEditing = true;
  }

  // QUANDO LIMPAR OS CAMPOS RESETA A VALIDAÇAO (NAO APARECE MAIS MSG DE ERRO)

  void _clearTextControllers() {
    idUserControl.clear();
    nameUserControl.clear();
    emailUserControl.clear();
    avatarUserControl.clear();
    _formKey.currentState?.reset();

    isEditing = false;
  }


  // A VIEW QUE EXIBE OS CAMPOS E BOTÕES NA TELA
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Contatos'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FormContactFielder(
                controller: idUserControl,
                iconData: Icons.contacts,
                hintTextName: 'ID',
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: nameUserControl,
                iconData: Icons.person_outline,
                hintTextName: 'Nome',
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: emailUserControl,
                iconData: Icons.email_outlined,
                textInputType: TextInputType.emailAddress,
                hintTextName: 'Email',
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: avatarUserControl,
                iconData: Icons.image_outlined,
                textInputType: TextInputType.text,
                hintTextName: 'Imagem (link)',
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          addUser(
                            idUserControl.text,
                            nameUserControl.text,
                            emailUserControl.text,
                            avatarUserControl.text,
                          );
                          _formKey.currentState?.save();
                        },
                        child: const Text('Adicionar'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _clearTextControllers,
                        child: const Text('Limpar Campos'),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // ADICIONADO BOTAO DE LISTAR CONTATOS !!!

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => setState(() {
                          listando = !listando;
                        }),
                        child: const Text("Listar Contatos"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: UserBox.getUsers().listenable(),
                builder: (BuildContext context, Box userBox, Widget? child) {
                  final users = userBox.values.toList().cast<UserModel>();
                  if (users.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Users Found',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return Center(
                      child: mostrarContatos(users),
                    );
                  }
                },
              ),
              //ContactListView(users: users)
            ],
          ),
        ),
      ),
    );
  }

  // RETORNA A LISTA DE CONTATOS SE LISTAR ESTIVER VERDADEIRO !!!

  ContactListView? mostrarContatos(List<UserModel> users) {
    if (listando) {
      return ContactListView(
        users: users,
        onEditContact: editUser,
      );
    }
    return null;
  }
}
