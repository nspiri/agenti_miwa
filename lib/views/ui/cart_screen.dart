// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:foody/controller/ui/cart_controller.dart';
import 'package:foody/controller/ui/seller/add_seller_controller.dart';
import 'package:foody/helpers/theme/app_themes.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_button.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/images.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:foody/views/layout/left_bar.dart';
import 'package:foody/views/ui/lista_storico_articolo.dart';
import 'package:foody/views/ui/modal_list_art.dart';
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
  late CustomerDetail? cliente;

  @override
  void initState() {
    cliente = Get.arguments;
    cliente ??= clienteSelezionato; //TODO rimuovere codice
    controller = Get.put(CartController(context: context));
    mostraNote();
    controller.getData(cliente!);
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
                codCliente: cliente?.codiceCliente ?? "",
                articoliSelezionati: controller.carrello,
                articoliCancellati: controller.articoliCancellati,
              )),
        );
      },
    ).then((value) {
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
                codCliente: cliente?.codiceCliente ?? "",
                articolo: art,
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
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
                        'Lista Articoli',
                        color: contentTheme.onPrimary,
                      ),
                    )
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
                            ? listaCarrello()
                            : Column(
                                children: [
                                  MyText.titleLarge(
                                    controller.loading
                                        ? "Caricamento..."
                                        : "Nessun articolo in lista...",
                                    fontWeight: 600,
                                  ),
                                  MySpacing.height(24),
                                  controller.loading
                                      ? CircularProgressIndicator(
                                          color: contentTheme.primary,
                                          strokeWidth: 3,
                                        )
                                      : Text(""),
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
      ),
    );
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
                  InkWell(
                    onTap: () {
                      _displayStoricoArticolo(context, data);
                    },
                    child: Icon(
                      LucideIcons.history,
                      size: 26,
                      color: contentTheme.primary,
                    ),
                  ),
                  MySpacing.width(8),
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
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: dropdown<Arprz>(
                            data.prezzoListini!
                                .where((element) => element.valore != 0)
                                .map(
                                  (societa) => DropdownMenuItem<Arprz>(
                                    value: societa,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyText.labelMedium(
                                            societa.descrizione,
                                          ),
                                          MyText.labelMedium(
                                            "€ ${Utils.formatStringDecimal(societa.valore, data.numDecArt ?? 2)}",
                                          ),
                                        ]),
                                  ),
                                )
                                .toList(),
                            (value) {
                              data.listinoSelezionato = value;
                              controller.aggiornaPrezzoArticolo(data);
                              data.textControllerListino.text =
                                  "€ ${Utils.formatStringDecimal(value?.valore, data.numDecArt ?? 2)}";
                            },
                            "Prezzo",
                            data.listinoSelezionato,
                            (BuildContext context) {
                              return data.prezzoListini!.map<Widget>((item) {
                                return Container(
                                  alignment: Alignment.centerRight,
                                  child: MyText.labelLarge(
                                    textAlign: TextAlign.right,
                                    "€ ${Utils.formatStringDecimal(item.valore, data.numDecArt ?? 2)}",
                                  ),
                                );
                              }).toList();
                            },
                          )
                          //dropDownListini(data),
                          ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Visibility(
                            visible: data.listinoSelezionato?.listino == 1 &&
                                !data.applicaOmaggio,
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
                                                      MyText.labelMedium(
                                                        sconto.sconto == ""
                                                            ? "Nessuno sconto"
                                                            : sconto.sconto ??
                                                                "",
                                                      ),
                                                      MyText.labelMedium(
                                                        "€ ${Utils.formatStringDecimal(sconto.prezzo, data.numDecArt ?? 2)}",
                                                      ),
                                                    ]),
                                              ),
                                            )
                                            .toList(),
                                        (value) {
                                          data.scontoSelezionato = value;
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
                                          controller.getTotali();
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
            MyText.bodyLarge(
                "€ ${Utils.formatStringDecimal((data.importoTotale), 2)}",
                fontWeight: 800),
            MySpacing.height(4),
            MyText.bodySmall(
              " Iva ${data.iva?.trim()}%",
            ),
          ],
        ),
        MySpacing.height(4),
        Row(
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
        ),
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
                    MyText.bodyMedium(
                      controller.fattA != null
                          ? "Pagamento: ${controller.fattA?.descPagamento}"
                          : "Pagamento: ${controller.destinazione?.descPagamento}",
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText.labelMedium(
              "Nota incasso",
            ),
            MySpacing.height(4),
            TextFormField(
              controller: controller.notaIncasso,
              decoration: InputDecoration(
                hintStyle: MyTextStyle.bodySmall(xMuted: true),
                border: outlineInputBorder,
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
              controller: controller.notaConsegna,
              decoration: InputDecoration(
                hintStyle: MyTextStyle.bodySmall(xMuted: true),
                border: outlineInputBorder,
                contentPadding: MySpacing.all(12),
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ],
        ),
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
        MyContainer(
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
