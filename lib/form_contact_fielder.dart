import 'package:flutter/material.dart';

class FormContactFielder extends StatelessWidget {
  final TextEditingController controller;
  final String hintTextName;
  final IconData iconData;
  final TextInputType textInputType;

  const FormContactFielder(
      {super.key,
      required this.controller,
      required this.hintTextName,
      required this.iconData,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(iconData),
        hintText: hintTextName,
        filled: true,
      ),
      keyboardType: textInputType,
      validator: (value) {
        // VALIDAÇAO DOS CAMPOS (MENOS O DO AVATAR)!!!

        if ((value == null || value.trim().isEmpty) &&
            hintTextName != 'Imagem (link)') {
          return 'Campo $hintTextName não pode ser vazio!';
        } else if (hintTextName == 'Nome' &&
            (!validateName(value!) || value.length < 3)) {
          return 'Insira um nome válido!';
        } else if (hintTextName == 'Email' &&
            (!validateEmail(value!) || value.length < 3)) {
          return 'Insira um e-mail válido!';
        }
        return null;
      },
    );
  }
}

// ADICIONADOS OS REGEX DE NOME E EMAIL !!!

validateName(String nome) {
  final reg = RegExp(r'(^\s*[A-Za-z]{3}[^\n\d]*$)');
  return reg.hasMatch(nome);
}

validateEmail(String email) {
  final reg = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return reg.hasMatch(email);
}
