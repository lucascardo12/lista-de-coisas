import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/listas_controller.dart';
import 'package:listadecoisa/model/check_list.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/borda_padrao.dart';

class ListaCheck extends GetView {
  final gb = Get.find<Global>();
  final bool isComp;
  final ListasController ct;
  ListaCheck({
    super.key,
    required this.isComp,
    required this.ct,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !isComp
            ? CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: gb.getPrimary(),
                  ),
                  onPressed: () {
                    ct.coisas.checklist!.add(
                      Checklist(feito: false, item: ''),
                    );
                    ct.update();
                  },
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 5),
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
                padding: const EdgeInsets.all(4),
                shrinkWrap: true,
                itemCount: ct.coisas.checklist!.length,
                itemBuilder: (BuildContext context, int i) {
                  Checklist item = ct.coisas.checklist![i];
                  return item.feito != null
                      ? Row(
                          children: [
                            !isComp
                                ? Checkbox(
                                    fillColor: MaterialStateProperty.all(Colors.white),
                                    checkColor: gb.getPrimary(),
                                    onChanged: (bool? value) {
                                      ct.coisas.checklist![i].feito = value;
                                      ct.update();
                                    },
                                    value: ct.coisas.checklist![i].feito ?? false,
                                  )
                                : const SizedBox(
                                    width: 20,
                                  ),
                            Expanded(
                                child: TextFormField(
                              readOnly: isComp,
                              onEditingComplete: () => ct.node.nextFocus(),
                              validator: (value) {
                                ct.coisas.checklist![i].item = value;
                                if (value!.isEmpty) return "Conteudo não pode ser vazio";
                                return null;
                              },
                              onChanged: (v) => ct.coisas.checklist![i].item = v,
                              autofocus: ct.coisas.checklist![i].item.isEmpty ? true : false,
                              initialValue: ct.coisas.checklist![i].item,
                              cursorColor: Colors.white,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                decoration: ct.coisas.checklist![i].feito ? TextDecoration.lineThrough : null,
                                decorationThickness: 2.85,
                                decorationColor: Colors.red,
                              ),
                              textAlign: TextAlign.center,
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
                            !isComp
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      ct.coisas.checklist![i] = Checklist(feito: null);
                                      ct.update();
                                    },
                                  )
                                : const SizedBox(
                                    width: 20,
                                  )
                          ],
                        )
                      : Container();
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}