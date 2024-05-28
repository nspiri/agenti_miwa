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
import 'package:mexalorder/views/ui/Lista/lista_controller.dart';
import 'package:mexalorder/views/ui/lista_storico_articolo.dart';
import 'package:mexalorder/views/ui/modal_list_art.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<ListaScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late ListaController controller;

  @override
  void initState() {
    controller = Get.put(ListaController(context: context));
    if (Get.arguments != null) {
      mostraNote();
    }
    controller.getData(clienteSelezionato!);
    super.initState();
  }

  mostraNote() async {
    String note = LocalStorage.getNote();
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
                codCliente: clienteSelezionato?.codCliFattA == ""
                    ? clienteSelezionato?.codiceCliente ?? ""
                    : clienteSelezionato?.codCliFattA ?? "",
                articoliSelezionati: controller.carrello,
                articoliCancellati: controller.articoliCancellati,
              )),
        );
      },
    ).then((value) {
      controller.articoliCancellati = [];
      List<Articolo> articoli = value as List<Articolo>;
      controller.aggiungiArticoli(articoli);
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
                codCliente: clienteSelezionato?.codCliFattA == ""
                    ? clienteSelezionato?.codiceCliente ?? ""
                    : clienteSelezionato?.codCliFattA ?? "",
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
                          "Lista ordine",
                          fontSize: 18,
                          fontWeight: 600,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (!controller.isOffline)
                          MyButton.rounded(
                            onPressed: () {
                              controller.convertiOrdine();
                            },
                            elevation: 0,
                            padding: MySpacing.xy(20, 16),
                            backgroundColor: contentTheme.primary,
                            child: MyText.bodyMedium(
                              'Converti in ordine',
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
                            ? screenMT.isMobile
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
            child: data.loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: contentTheme.primary,
                      strokeWidth: 3,
                    ),
                  )
                : Row(
                    children: [
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
            child: data.loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: contentTheme.primary,
                      strokeWidth: 3,
                    ),
                  )
                : Column(
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
                            listino.descrizione,
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
                  MyText.bodyMedium(
                    "${data.descrizione} (${Utils.formatStringDecimal((data.qtaArt), data.numDecArt ?? 2)} ${data.um1})",
                    fontWeight: 600,
                    maxLines: 2,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: MyText.bodySmall(
                  "Codice: ${data.codArt}",
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
                                              listino.descrizione,
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
                  ],
                ),
              ),
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
        //MySpacing.height(4),
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
            // MySpacing.height(4),
            MyText.bodySmall(
              " Iva ${data.iva?.trim()}%",
            ),
          ],
        ),
        //MySpacing.height(4),
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
                  ],
                ),
              ),
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
              '€ ${Utils.formatStringDecimal(controller.totale, 2)}',
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
                      'Cancella lista',
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
                  controller.salvaLista();
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
                      'Salva lista',
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
