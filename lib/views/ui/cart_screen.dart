// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mexalorder/controller/ui/cart_controller.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/theme/app_themes.dart';
import 'package:mexalorder/helpers/utils/global.dart';
import 'package:mexalorder/helpers/utils/show_message_dialogs.dart';
import 'package:mexalorder/helpers/utils/ui_mixins.dart';
import 'package:mexalorder/helpers/utils/utils.dart';
import 'package:mexalorder/helpers/widgets/my_button.dart';
import 'package:mexalorder/helpers/widgets/my_container.dart';
import 'package:mexalorder/helpers/widgets/my_flex.dart';
import 'package:mexalorder/helpers/widgets/my_flex_item.dart';
import 'package:mexalorder/helpers/widgets/my_responsiv.dart';
import 'package:mexalorder/helpers/widgets/my_spacing.dart';
import 'package:mexalorder/helpers/widgets/my_text.dart';
import 'package:mexalorder/helpers/widgets/my_text_style.dart';
import 'package:mexalorder/helpers/widgets/responsive.dart';
import 'package:mexalorder/images.dart';
import 'package:mexalorder/model/articolo.dart';
import 'package:mexalorder/model/customer_detail.dart';
import 'package:mexalorder/views/layout/layout.dart';
import 'package:mexalorder/views/ui/lista_storico_articolo.dart';
import 'package:mexalorder/views/ui/modal_list_art.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late CartController controller;
  late PassaggioDatiOrdine? dati;
  late CustomerDetail? cliente;

  @override
  void initState() {
    dati = Get.arguments;
    clienteSelezionato = LocalStorage.getDettCli();
    cliente = dati?.cliente;
    cliente ??= clienteSelezionato;
    controller = Get.put(CartController(context: context));
    controller.getData(cliente!);
    if (dati?.carrello != [] && dati?.carrello != null) {
      /*for (var element in dati!.carrello!) {
        element.loading = true;
      }*/
      controller.carrello = dati!.carrello!;
      controller.loading = true;
      controller.aggiungiArticoli2(dati?.carrello ?? []);
      controller.notaIncasso.text = LocalStorage.getNotaIncasso() ?? "";
      controller.notaConsegna.text = LocalStorage.getNotaConsegna() ?? "";
    } else {
      var a = LocalStorage.getCarrello();
      if ((LocalStorage.getCarrello() ?? []).length > 0) {
        carrelloGlobale = LocalStorage.getCarrello() ?? [];
        /* for (var element in carrelloGlobale) {
          element.loading = true;
        }*/
        controller.carrello = carrelloGlobale;
        controller.loading = true;
        controller.aggiungiArticoli2(carrelloGlobale);
        controller.notaIncasso.text = LocalStorage.getNotaIncasso() ?? "";
        controller.notaConsegna.text = LocalStorage.getNotaConsegna() ?? "";
      } else {
        if ((LocalStorage.getCarrelloGlobale() ?? []).length > 0) {
          carrelloGlobale = LocalStorage.getCarrelloGlobale() ?? [];
          controller.carrello = carrelloGlobale;
          controller.loading = true;
          controller.aggiungiArticoli2(carrelloGlobale);
        } else {
          controller.loading = true;
          controller.aggiungiArticoli2([]);
        }
      }
    }
    if (cliente != null) {
      mostraNote();
    }
    super.initState();
  }

  mostraNote() async {
    String note = await controller.getNoteCliente(cliente?.codiceCliente ?? "");
    if (note != "") {
      showAlertMessage(context, "Note cliente", note);
    }
  }

  _displayDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: ModalListaArticoli(
                codCliente: cliente?.codCliFattA == ""
                    ? cliente?.codiceCliente ?? ""
                    : cliente?.codCliFattA ?? "",
                articoliSelezionati: controller.carrello,
                articoliCancellati: controller.articoliCancellati,
              )),
        );
      },
    ).then((value) {
      controller.articoliCancellati = [];
      List<Articolo> articoli = value as List<Articolo>;
      controller.loading = true;
      controller.update();
      controller.aggiungiArticoli2(articoli);
    });
  }

  _displayStoricoArticolo(BuildContext context, Articolo art) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: ModalListaStoricoArticolo(
                codCliente: cliente?.codCliFattA == ""
                    ? cliente?.codiceCliente ?? ""
                    : cliente?.codCliFattA ?? "",
                articolo: art,
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        child: MyResponsive(builder: (BuildContext context, _, screenMT) {
      return GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /*IconButton(
                            onPressed: () {
                              //controller.gotoExplore()
                              controller.loading = true;
                              controller.update();
                              _displayDialog(context);
                            },
                            icon: Icon(
                              LucideIcons.list,
                              color: contentTheme.primary,
                            )),*/
                        //MySpacing.width(8),
                        MyText.titleMedium(
                          "Nuovo ordine",
                          fontSize: 18,
                          fontWeight: 600,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        MyButton.rounded(
                          onPressed: () {
                            controller.preventivo();
                          },
                          elevation: 0,
                          padding: MySpacing.xy(20, 16),
                          backgroundColor: contentTheme.primary,
                          child: MyText.bodyMedium(
                            'Preventivo',
                            color: contentTheme.onPrimary,
                          ),
                        ),
                        MySpacing.width(8),
                        MyButton.rounded(
                          onPressed: () {
                            controller.loading = true;
                            controller.update();
                            _displayDialog(context);
                          },
                          elevation: 0,
                          padding: MySpacing.xy(20, 16),
                          backgroundColor: contentTheme.primary,
                          child: MyText.bodyMedium(
                            'Articoli',
                            color: contentTheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: MyFlex(
                  children: [
                    MyFlexItem(
                        sizes: 'lg-7',
                        child: controller.carrello.isNotEmpty
                            ? controller.loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: contentTheme.primary,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : screenMT.isMobile
                                    ? listaCarrelloMobile()
                                    : listaCarrello()
                            : Column(
                                children: [
                                  MyText.titleLarge(
                                    "Nessun articolo in lista...",
                                    fontWeight: 600,
                                  ),
                                  /* MySpacing.height(24),
                                  controller.loading
                                      ? CircularProgressIndicator(
                                          color: contentTheme.primary,
                                          strokeWidth: 3,
                                        )
                                      : Text(""),*/
                                ],
                              )),
                    MyFlexItem(
                        sizes: 'lg-5',
                        child: MyContainer(
                          child: buildCard(),
                        )),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }));
  }

  Widget listaCarrello() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.carrello.length,
      itemBuilder: (context, index) {
        Articolo data = controller.carrello[index];
        return MyContainer(
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: immagine(data),
                ),
                Expanded(
                  child: descrizione(data),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: quantita(data),
                ),
              ],
            ));
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 12,
        );
      },
    );
  }

  Widget listaCarrelloMobile() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.carrello.length,
      itemBuilder: (context, index) {
        Articolo data = controller.carrello[index];
        return MyContainer(
            width: double.infinity,
            child: Column(
              children: [
                descrizioneMobile(data),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: quantitaMobile(data),
                ),
              ],
            ));
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 12,
        );
      },
    );
  }

  Widget immagine(Articolo data) {
    return MyContainer(
      height: 100,
      width: 100,
      paddingAll: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: data.icona != null
          ? Image.memory(
              data.icona!,
              fit: BoxFit.cover,
            )
          : Image(
              image: ExactAssetImage(Images.noImage),
              fit: BoxFit.cover,
            ),
    );
  }

  Widget descrizioneMobile(Articolo data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MyText.bodySmall(
                "${data.descrizione} (${Utils.formatStringDecimal((data.qtaArt), data.numDecArt ?? 2)} ${data.um1})",
                fontWeight: 600,
                maxLines: 2,
              ),
            ),
            MySpacing.width(8),
            InkWell(
              onTap: () {
                _displayStoricoArticolo(context, data);
              },
              child: Icon(
                LucideIcons.history,
                size: 34,
                color: contentTheme.primary,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: MyText.bodySmall(
            "Codice: ${data.codArt}",
          ),
        ),
        if (data.prezzoArticolo?.omaggio != null &&
            data.listinoSelezionato?.listino == 1)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CheckboxListTile(
              enabled: data.conf! >= data.prezzoArticolo!.omaggio!.qtaPresa!,
              controlAffinity: ListTileControlAffinity.leading,
              title: MyText.bodySmall(
                "Applica omaggio prendi ${data.prezzoArticolo?.omaggio?.qtaPresa} paghi ${data.prezzoArticolo?.omaggio?.qtaPagata}",
              ),
              onChanged: (value) {
                controller.onChangeApplicaOmaggio(data, value);
              },
              value: data.applicaOmaggio,
              fillColor: MaterialStatePropertyAll(Colors.white),
              activeColor: theme.colorScheme.primary,
              checkColor: contentTheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: getCompactDensity,
            ),
          ),
        MySpacing.height(8),
        Visibility(
          visible: !data.applicaOmaggio && controller.isModificaPrezzo,
          child: dropdown<Arprz>(
            data.prezzoListini!
                .where((element) => element.valore != 0)
                .map(
                  (listino) => DropdownMenuItem<Arprz>(
                    value: listino,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText.labelMedium(
                            listino.descrizione ?? "",
                          ),
                          MyText.labelMedium(
                            "€ ${Utils.formatStringDecimal(listino.valore, 3)}",
                          ),
                        ]),
                  ),
                )
                .toList(),
            (value) {
              data.listinoSelezionato = value;
              data.textControllerListino.text =
                  "€ ${Utils.formatStringDecimal(value?.valore, 3)}";
              controller.aggiornaPrezzoArticolo(data);
            },
            "Prezzo",
            data.listinoSelezionato,
            (BuildContext context) {
              return data.prezzoListini!
                  .where((element) => element.valore != 0)
                  .map<Widget>((item) {
                return Container(
                  alignment: Alignment.centerRight,
                  child: MyText.labelLarge(
                    textAlign: TextAlign.right,
                    "€ ${Utils.formatStringDecimal(item.valore, 3)}",
                  ),
                );
              }).toList();
            },
          ),
        ),
        MySpacing.height(8),
        Visibility(
            visible: (data.listinoSelezionato?.listino == 1 &&
                    !data.applicaOmaggio) &&
                controller.isModificaSconto,
            child: /*dropDownSconti(data)*/
                data.prezzoArticolo?.scalaSconti != null
                    ? dropdown<ScalaSconti>(
                        data.prezzoArticolo!.scalaSconti!
                            .map(
                              (sconto) => DropdownMenuItem<ScalaSconti>(
                                value: sconto,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText.labelMedium(
                                            sconto.sconto == ""
                                                ? "Nessuno sconto"
                                                : "${sconto.sconto}%",
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText.labelMedium(
                                            "€ ${Utils.formatStringDecimal(sconto.prezzo, 3)}",
                                          ),
                                          MyText.labelMedium(
                                            "Prov: ${sconto.provvigione}%",
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            )
                            .toList(),
                        (value) {
                          data.scontoSelezionato = value;
                          controller.update();
                          data.importo = data.scontoSelezionato?.prezzo ?? 0;
                          data.textControllerSconto.text = value?.sconto == ""
                              ? "Nessuno sconto"
                              : "${value?.sconto}%";
                          data.prezzoArticolo?.provvigione =
                              data.scontoSelezionato?.provvigione;
                          controller.getTotali(data);
                        },
                        "Sconto applicato",
                        data.scontoSelezionato,
                        (BuildContext context) {
                          return data.prezzoArticolo!.scalaSconti!
                              .map<Widget>((item) {
                            return Container(
                              alignment: Alignment.centerRight,
                              child: MyText.labelLarge(
                                textAlign: TextAlign.right,
                                item.sconto == ""
                                    ? "Nessuno sconto"
                                    : "${item.sconto}%",
                              ),
                            );
                          }).toList();
                        },
                      )
                    : Text("")),
      ],
    );
  }

  Widget descrizione(Articolo data) {
    return MyFlex(
      wrapCrossAlignment: WrapCrossAlignment.center,
      children: [
        MyFlexItem(
          sizes: "md-12 lg-12 sm-12",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  /*InkWell(
                    onTap: () {
                      _displayStoricoArticolo(context, data);
                    },
                    child: Icon(
                      LucideIcons.history,
                      size: 26,
                      color: contentTheme.primary,
                    ),
                  ),
                  MySpacing.width(8),*/
                  MyText.bodyMedium(
                    "${data.descrizione} (${Utils.formatStringDecimal((data.qtaArt), data.numDecArt ?? 2)} ${data.um1})",
                    fontWeight: 600,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: MyText.bodySmall(
                  "Codice: ${data.codArt}",
                ),
              ),
              if (data.prezzoArticolo?.omaggio != null &&
                  data.listinoSelezionato?.listino == 1)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: CheckboxListTile(
                    enabled:
                        data.conf! >= data.prezzoArticolo!.omaggio!.qtaPresa!,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: MyText.bodySmall(
                      "Applica omaggio prendi ${data.prezzoArticolo?.omaggio?.qtaPresa} paghi ${data.prezzoArticolo?.omaggio?.qtaPagata}",
                    ),
                    onChanged: (value) {
                      controller.onChangeApplicaOmaggio(data, value);
                    },
                    value: data.applicaOmaggio,
                    fillColor: MaterialStatePropertyAll(Colors.white),
                    activeColor: theme.colorScheme.primary,
                    checkColor: contentTheme.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: getCompactDensity,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        onTap: () {
                          _displayStoricoArticolo(context, data);
                        },
                        child: Icon(
                          LucideIcons.history,
                          size: 34,
                          color: contentTheme.primary,
                        ),
                      ),
                    ),
                    MySpacing.width(8),
                    Expanded(
                      child: Visibility(
                        visible:
                            !data.applicaOmaggio && controller.isModificaPrezzo,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: dropdown<Arprz>(
                              data.prezzoListini!
                                  .where((element) => element.valore != 0)
                                  .map(
                                    (listino) => DropdownMenuItem<Arprz>(
                                      value: listino,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText.labelMedium(
                                              listino.descrizione ?? "",
                                            ),
                                            MyText.labelMedium(
                                              "€ ${Utils.formatStringDecimal(listino.valore, 3)}",
                                            ),
                                          ]),
                                    ),
                                  )
                                  .toList(),
                              (value) {
                                data.listinoSelezionato = value;
                                data.textControllerListino.text =
                                    "€ ${Utils.formatStringDecimal(value?.valore, 3)}";
                                controller.aggiornaPrezzoArticolo(data);
                              },
                              "Prezzo",
                              data.listinoSelezionato,
                              (BuildContext context) {
                                return data.prezzoListini!
                                    .where((element) => element.valore != 0)
                                    .map<Widget>((item) {
                                  return Container(
                                    alignment: Alignment.centerRight,
                                    child: MyText.labelLarge(
                                      textAlign: TextAlign.right,
                                      "€ ${Utils.formatStringDecimal(item.valore, 3)}",
                                    ),
                                  );
                                }).toList();
                              },
                            )
                            //dropDownListini(data),
                            ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Visibility(
                            visible: (data.listinoSelezionato?.listino == 1 &&
                                    !data.applicaOmaggio) &&
                                controller.isModificaSconto,
                            child: /*dropDownSconti(data)*/
                                data.prezzoArticolo?.scalaSconti != null
                                    ? dropdown<ScalaSconti>(
                                        data.prezzoArticolo!.scalaSconti!
                                            .map(
                                              (sconto) =>
                                                  DropdownMenuItem<ScalaSconti>(
                                                value: sconto,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          MyText.labelMedium(
                                                            sconto.sconto == ""
                                                                ? "Nessuno sconto"
                                                                : "${sconto.sconto}%",
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          MyText.labelMedium(
                                                            "€ ${Utils.formatStringDecimal(sconto.prezzo, 3)}",
                                                          ),
                                                          MyText.labelMedium(
                                                            "Prov: ${sconto.provvigione}%",
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            )
                                            .toList(),
                                        (value) {
                                          data.scontoSelezionato = value;
                                          controller.update();
                                          data.importo =
                                              data.scontoSelezionato?.prezzo ??
                                                  0;
                                          data.textControllerSconto.text =
                                              value?.sconto == ""
                                                  ? "Nessuno sconto"
                                                  : "${value?.sconto}%";
                                          data.prezzoArticolo?.provvigione =
                                              data.scontoSelezionato
                                                  ?.provvigione;
                                          controller.getTotali(data);
                                        },
                                        "Sconto applicato",
                                        data.scontoSelezionato,
                                        (BuildContext context) {
                                          return data
                                              .prezzoArticolo!.scalaSconti!
                                              .map<Widget>((item) {
                                            return Container(
                                              alignment: Alignment.centerRight,
                                              child: MyText.labelLarge(
                                                textAlign: TextAlign.right,
                                                item.sconto == ""
                                                    ? "Nessuno sconto"
                                                    : "${item.sconto}%",
                                              ),
                                            );
                                          }).toList();
                                        },
                                      )
                                    : Text("")),
                      ),
                    )
                  ],
                ),
              ),
              /*MyText.bodyMedium(
                                                            "Prezzo: € ${Utils.formatStringDecimal(data.importo, 2)}",
                                                            fontWeight: 600,
                                                          ),*/
            ],
          ),
        ),
      ],
    );
  }

  Widget quantitaMobile(Articolo data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyContainer.rounded(
                  onTap: () => controller.delete(data),
                  child: Icon(
                    LucideIcons.trash,
                    size: 20,
                    color: contentTheme.danger,
                  ),
                ),
                MyContainer.roundBordered(
                  onTap: () {
                    controller.decrement(data);
                  },
                  paddingAll: 4,
                  borderRadiusAll: 2,
                  child: Icon(
                    LucideIcons.minus,
                    size: 18,
                  ),
                ),
                MySpacing.width(10),
                SizedBox(
                  width: 30,
                  child: MyText.titleMedium(
                    Utils.formatStringDecimal(data.conf, 0),
                    fontWeight: 800,
                    textAlign: TextAlign.center,
                  ),
                ),
                MySpacing.width(10),
                MyContainer.roundBordered(
                  onTap: () {
                    controller.increment(data);
                  },
                  paddingAll: 4,
                  borderRadiusAll: 2,
                  child: Icon(
                    LucideIcons.plus,
                    size: 18,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                data.loadingPrezzo
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: contentTheme.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : MyText.bodyLarge(
                        "€ ${Utils.formatStringDecimal((data.importoTotale), 2)}",
                        fontWeight: 800),
                MySpacing.height(4),
                MyText.bodySmall(
                  " Iva ${data.iva?.trim()}%",
                ),
              ],
            ),
          ],
        ),
        /* Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: MyText.bodySmall(
                "Prov: ",
                //fontWeight: 600,
              ),
            ),
            MyText.bodySmall(
              "${data.prezzoArticolo?.provvigione}%",
              //fontWeight: 600,
            ),
          ],
        ),*/
      ],
    );
  }

  Widget quantita(Articolo data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyContainer.rounded(
              onTap: () => controller.delete(data),
              child: Icon(
                LucideIcons.trash,
                size: 20,
                color: contentTheme.danger,
              ),
            ),
            MyContainer.roundBordered(
              onTap: () {
                controller.decrement(data);
              },
              paddingAll: 4,
              borderRadiusAll: 2,
              child: Icon(
                LucideIcons.minus,
                size: 18,
              ),
            ),
            MySpacing.width(10),
            SizedBox(
              width: 30,
              child: MyText.titleMedium(
                Utils.formatStringDecimal(data.conf, 0),
                fontWeight: 800,
                textAlign: TextAlign.center,
              ),
            ),
            MySpacing.width(10),
            MyContainer.roundBordered(
              onTap: () {
                controller.increment(data);
              },
              paddingAll: 4,
              borderRadiusAll: 2,
              child: Icon(
                LucideIcons.plus,
                size: 18,
              ),
            ),
          ],
        ),
        MySpacing.height(4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            data.loadingPrezzo
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: contentTheme.primary,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : MyText.bodyLarge(
                    "€ ${Utils.formatStringDecimal((data.importoTotale), 2)}",
                    fontWeight: 800),
            MySpacing.height(4),
            MyText.bodySmall(
              " Iva ${data.iva?.trim()}%",
            ),
          ],
        ),
        MySpacing.height(4),
        /* Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: MyText.bodySmall(
                "Prov: ",
                //fontWeight: 600,
              ),
            ),
            MyText.bodySmall(
              "${data.prezzoArticolo?.provvigione}%",
              //fontWeight: 600,
            ),
          ],
        ),*/
      ],
    );
  }

  dropdown<T>(
      List<DropdownMenuItem<T>> items,
      Function(T? value) onChanged,
      String title,
      T? valoreSelezionato,
      List<Widget> Function(BuildContext)? selectedBuilder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelMedium(
          title,
        ),
        MySpacing.height(4),
        DropdownButtonFormField<T>(
          dropdownColor: contentTheme.background,
          isDense: true,
          items: items,
          icon: Icon(
            LucideIcons.chevronDown,
            size: 20,
          ),
          decoration: InputDecoration(
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(8),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          //validator: controller.basicValidator.getValidation(validation),
          value: valoreSelezionato,
          selectedItemBuilder: selectedBuilder,
          onChanged: (value) {
            onChanged(value);
          },
        )
      ],
    );
  }

  Widget buildCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controller.loadingCliente
            ? Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: contentTheme.primary,
                      strokeWidth: 3,
                    ),
                    Divider(),
                    MySpacing.height(20)
                  ],
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText.bodyLarge(
                      'Cliente',
                      fontWeight: 600,
                    ),
                    MySpacing.height(20),
                    MyText.bodyMedium(
                      controller.fattA != null
                          ? controller.fattA?.ragioneSociale ?? ""
                          : controller.destinazione?.ragioneSociale ?? "",
                      fontWeight: 600,
                      muted: true,
                    ),
                    MySpacing.height(12),
                    MyText.bodyMedium(
                      controller.fattA != null
                          ? controller.fattA?.indirizzo ?? ""
                          : controller.destinazione?.indirizzo ?? "",
                      fontWeight: 600,
                      muted: true,
                    ),
                    MySpacing.height(12),
                    MyText.bodyMedium(
                      controller.fattA != null
                          ? "${controller.fattA?.localita} (${controller.fattA?.provincia})"
                          : "${controller.destinazione?.localita} (${controller.destinazione?.provincia})",
                      fontWeight: 600,
                      muted: true,
                    ),
                    MySpacing.height(12),
                    Divider(),
                    if (controller.fattA != null)
                      MyText.bodyLarge(
                        'Destinazione',
                        fontWeight: 600,
                      ),
                    if (controller.fattA != null) MySpacing.height(20),
                    if (controller.fattA != null)
                      MyText.bodyMedium(
                        controller.destinazione?.ragioneSociale ?? "",
                        fontWeight: 600,
                        muted: true,
                      ),
                    if (controller.fattA != null) MySpacing.height(12),
                    if (controller.fattA != null)
                      MyText.bodyMedium(
                        controller.destinazione?.indirizzo ?? "",
                        fontWeight: 600,
                        muted: true,
                      ),
                    if (controller.fattA != null) MySpacing.height(12),
                    if (controller.fattA != null)
                      MyText.bodyMedium(
                        "${controller.destinazione?.localita} (${controller.destinazione?.provincia})",
                        fontWeight: 600,
                        muted: true,
                      ),
                    if (controller.fattA != null) MySpacing.height(12),
                    if (controller.fattA != null) Divider(),
                    MySpacing.height(8),
                    MyText.bodyLarge(
                      'Pagamento',
                      fontWeight: 600,
                    ),
                    MyText.bodyMedium(
                      controller.fattA != null
                          ? "${controller.fattA?.descPagamento}"
                          : "${controller.destinazione?.descPagamento}",
                      fontWeight: 600,
                      muted: true,
                    ),
                    MySpacing.height(8),
                    Divider(),
                    MySpacing.height(8),
                    MyText.bodyLarge(
                      'Giorni di consegna',
                      fontWeight: 600,
                    ),
                    MySpacing.height(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText.bodyMedium("Giorno", fontWeight: 600),
                        MyText.bodyMedium("Giro", fontWeight: 600),
                        MyText.bodyMedium("Chiusura", fontWeight: 600)
                      ],
                    ),
                    MySpacing.height(8),
                    for (var i = 0;
                        i <
                            (controller.destinazione?.giorniConsegne?.length ??
                                0);
                        i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText.bodyMedium(
                              "${controller.destinazione?.giorniConsegne?[i].giorno}"),
                          MyText.bodyMedium(
                              "${controller.destinazione?.giorniConsegne?[i].giro}"),
                          MyText.bodyMedium(
                              "${controller.destinazione?.giorniConsegne?[i].chiusuraOrdini}")
                        ],
                      ),
                    MySpacing.height(8),
                    Divider(),
                  ],
                ),
              ),
        if (controller.fattA != null) Divider(),
        MyText.bodyLarge(
          'Totale carrello',
          fontWeight: 600,
        ),
        MySpacing.height(20),
        buildCardDetail('  Totale merce lordo',
            '€ ${Utils.formatStringDecimal(controller.allTot.totaleMerceLordo, 2)}'),
        MySpacing.height(12),
        buildCardDetail('- Sconto pagamento',
            '€ ${Utils.formatStringDecimal(controller.allTot.scontoPagamento, 2)}'),
        MySpacing.height(12),
        buildCardDetail('= Totale merce netto',
            '€ ${Utils.formatStringDecimal(controller.allTot.totaleMerceNetto, 2)}'),
        MySpacing.height(12),
        buildCardDetail('+ Totale iva',
            '€ ${Utils.formatStringDecimal(controller.allTot.totaleIva, 2)}'),
        MySpacing.height(12),
        buildCardDetail('= Totale documento',
            '€ ${Utils.formatStringDecimal(controller.allTot.totaleDocumento, 2)}'),
        MySpacing.height(12),
        buildCardDetail('- Sconto abbuono',
            '€ ${Utils.formatStringDecimal(controller.allTot.scontoAbbuono, 2)}'),
        MySpacing.height(12),
        buildCardDetail('= Totale da pagare',
            '€ ${Utils.formatStringDecimal(controller.allTot.totaleDaPagare, 2)}'),
        MySpacing.height(12),
        Divider(),
        MySpacing.height(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText.bodyLarge(
              "Totale da pagare",
              fontWeight: 600,
            ),
            MyText.bodyLarge(
              '€ ${Utils.formatStringDecimal(controller.allTot.totaleDaPagare, 2)}',
              fontWeight: 600,
            )
          ],
        ),
        MySpacing.height(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText.labelMedium(
              "Nota incasso",
            ),
            MySpacing.height(4),
            TextFormField(
              maxLength: 50,
              controller: controller.notaIncasso,
              decoration: InputDecoration(
                counterText: "",
                hintStyle: MyTextStyle.bodySmall(xMuted: true),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: focusedInputBorder,
                contentPadding: MySpacing.all(12),
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ],
        ),
        MySpacing.height(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText.labelMedium(
              "Nota consegna",
            ),
            MySpacing.height(4),
            TextFormField(
              maxLength: 50,
              controller: controller.notaConsegna,
              decoration: InputDecoration(
                counterText: "",
                hintStyle: MyTextStyle.bodySmall(xMuted: true),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: focusedInputBorder,
                contentPadding: MySpacing.all(12),
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ],
        ),
        MySpacing.height(12),
        Row(
          children: [
            Flexible(
              child: MyContainer.bordered(
                onTap: () {
                  controller.cancellaOrdine();
                },
                width: double.infinity,
                borderRadiusAll: 30,
                paddingAll: 12,
                // color: contentTheme.,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.inviaLoading
                        ? SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              strokeWidth: 1.2,
                            ),
                          )
                        : Container(),
                    if (controller.inviaLoading) MySpacing.width(16),
                    MyText.bodySmall(
                      'Annulla Ordine',
                      color: contentTheme.dark,
                    ),
                  ],
                ),
              ),
            ),
            MySpacing.width(12),
            Flexible(
              child: MyContainer(
                onTap: () {
                  controller.inviaOrdine();
                },
                width: double.infinity,
                borderRadiusAll: 30,
                paddingAll: 12,
                color: contentTheme.primary,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.inviaLoading
                        ? SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              strokeWidth: 1.2,
                            ),
                          )
                        : Container(),
                    if (controller.inviaLoading) MySpacing.width(16),
                    MyText.bodySmall(
                      'Invia Ordine',
                      color: contentTheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCardDetail(String title, String subTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText.bodyMedium(
          title,
          fontWeight: 600,
          muted: true,
        ),
        MyText.bodyMedium(
          subTitle,
          fontWeight: 600,
          muted: true,
        )
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
