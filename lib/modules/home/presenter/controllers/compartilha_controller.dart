import 'package:flutter/material.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';

class CompartilhaController extends IController {
  final Global gb;
  final BancoFire banco;
  late Coisas lista;
  late UserP user;

  CompartilhaController({required this.gb, required this.banco});

  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    gb.isLoading = true;
    getLista();
  }

  getLista() async {
    await banco.getCoisa(idLista: gb.codigoList!, idUser: gb.codigoUser!).then((value) {
      gb.isLoading = false;
      lista = Coisas.fromSnapshot(value);
    });
    await banco.getUser(idUser: gb.codigoUser!).then((value) {
      gb.isLoading = false;
      user = UserP.fromSnapshot(value);
    });
  }
}