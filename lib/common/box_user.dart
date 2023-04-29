import 'package:hive/hive.dart';

import '../model/user.dart';

// ONDE SERÁ ARMAZENADO OS CONTATOS

class UserBox {
  static Box<UserModel> getUsers() => Hive.box('users');
}
