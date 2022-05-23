import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/listas_controller.dart';
import 'package:listadecoisa/model/ckeck_compras.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/borda_padrao.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class ListaCompras extends GetView {
  final gb = Get.find<Global>();
  final ListasController ct;
  final bool isComp;

  ListaCompras({
    super.key,
    required this.ct,
    required this.isComp,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: gb.getPrimary(),
            ),
            onPressed: () {
              ct.coisas.checkCompras!.add(
                CheckCompras(
                  feito: false,
                  item: '',
                  quant: 1,
                ),
              );
              ct.update();
            },
          ),
        ),
        const Divider(
          color: Colors.white,
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Scrollbar(
              interactive: false,
              thickness: 5,
              thumbVisibility: true,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 15),
                shrinkWrap: true,
                itemCount: ct.coisas.checkCompras!.length,
                itemBuilder: (BuildContext context, int i) {
                  CheckCompras item = ct.coisas.checkCompras![i];
                  return item.feito != null
                      ? Row(
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.all(Colors.white),
                              checkColor: gb.getPrimary(),
                              onChanged: (bool? value) {
                                ct.coisas.checkCompras![i].feito = value;
                                ct.update();
                              },
                              value: ct.coisas.checkCompras![i].feito ?? false,
                            ),
                            Expanded(
                                flex: 7,
                                child: TextFormField(
                                  readOnly: isComp,
                                  onEditingComplete: () => ct.node.nextFocus(),
                                  validator: (value) {
                                    ct.coisas.checkCompras![i].item = value;
                                    if (value!.isEmpty) return "Conteudo não pode ser vazio";
                                    return null;
                                  },
                                  autofocus: ct.coisas.checkCompras![i].item.isEmpty ? true : false,
                                  initialValue: ct.coisas.checkCompras![i].item,
                                  cursorColor: Colors.white,
                                  onChanged: (v) => ct.coisas.checkCompras![i].item = v,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                  minLines: 1,
                                  maxLines: 2,
                                  maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: BordaPadrao.check(),
                                    enabledBorder: BordaPadrao.check(),
                                    focusedBorder: BordaPadrao.check(),
                                    hintStyle: const TextStyle(color: Colors.white),
                                    alignLabelWithHint: true,
                                    hintText: "",
                                    labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: TextFormField(
                                  readOnly: isComp,
                                  onEditingComplete: () => ct.node.nextFocus(),
                                  validator: (value) {
                                    if (value!.isEmpty) return "Conteudo não pode ser vazio";
                                    return null;
                                  },
                                  onChanged: (v) {
                                    ct.coisas.checkCompras![i].quant = int.tryParse(v) ?? 0;
                                    ct.update();
                                  },
                                  autofocus: ct.coisas.checkCompras![i].quant == null ? true : false,
                                  initialValue: ct.coisas.checkCompras![i].quant.toString(),
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "Qts",
                                    border: BordaPadrao.check(),
                                    enabledBorder: BordaPadrao.check(),
                                    focusedBorder: BordaPadrao.check(),
                                    hintStyle: const TextStyle(color: Colors.white),
                                    alignLabelWithHint: true,
                                    labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: TextFormField(
                                  readOnly: isComp,
                                  keyboardType: TextInputType.number,
                                  onEditingComplete: () => ct.node.nextFocus(),
                                  validator: (value) {
                                    if (value!.isEmpty) return "Conteudo não pode ser vazio";
                                    return null;
                                  },
                                  onChanged: (v) {
                                    ct.coisas.checkCompras![i].valor =
                                        double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
                                    ct.update();
                                  },
                                  autofocus: ct.coisas.checkCompras![i].valor == null ? true : false,
                                  initialValue: ct.coisas.checkCompras![i].valor == null
                                      ? ''
                                      : ct.coisas.checkCompras![i].valor.toString(),
                                  cursorColor: Colors.white,
                                  style: const TextStyle(color: Colors.white),
                                  inputFormatters: [
                                    CurrencyTextInputFormatter(decimalDigits: 2, symbol: '', locale: 'pt-br'),
                                  ],
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "R\u0024",
                                    border: BordaPadrao.check(),
                                    enabledBorder: BordaPadrao.check(),
                                    focusedBorder: BordaPadrao.check(),
                                    hintStyle: const TextStyle(color: Colors.white),
                                    alignLabelWithHint: true,
                                    labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                )),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                ct.coisas.checkCompras![i] = CheckCompras(feito: null);
                                ct.update();
                              },
                            )
                          ],
                        )
                      : Container();
                },
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.white,
        ),
        SizedBox(
          height: 40,
          child: Text(
            "Valor total da compra R\u0024: ${ct.retornaTotal(ct.coisas.checkCompras!)}",
            style: Get.theme.textTheme.headline6!.copyWith(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}