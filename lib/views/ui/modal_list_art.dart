// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foody/helpers/theme/app_style.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_button.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_responsiv.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/views/ui/modal_list_art_controller.dart';
import 'package:foody/widgets/custom_pop_menu.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ModalListaArticoli extends StatefulWidget {
  final String codCliente;
  final List<Articolo> articoliSelezionati, articoliCancellati;
  const ModalListaArticoli(
      {super.key,
      required this.codCliente,
      required this.articoliSelezionati,
      required this.articoliCancellati});

  @override
  State<ModalListaArticoli> createState() => _ModalListaArticoliState();
}

class _ModalListaArticoliState extends State<ModalListaArticoli>
    with SingleTickerProviderStateMixin, UIMixin {
  late ModalListaArtController controller;

  @override
  void initState() {
    controller = Get.put(ModalListaArtController(
        context: context,
        articoliSelezionati: widget.articoliSelezionati,
        articoliCancellati: widget.articoliCancellati));
    controller.tuttiGliArticoli(
        widget.articoliSelezionati, widget.articoliCancellati);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: MyResponsive(builder: (BuildContext context, _, screenMT) {
        return GetBuilder(
          init: controller,
          builder: (controller) {
            return screenMT.isMobile ? mobile() : desktop();
          },
        );
      })),
    );
  }

  Widget desktop() {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: controller.focusNode,
      onKey: controller.handleKeyEvent,
      child: SingleChildScrollView(
        controller: controller.controllerScroll,
        child: Column(
          children: [
            Padding(
              padding: MySpacing.xy(flexSpacing, flexSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText.titleMedium(
                    "Articoli",
                    fontSize: 18,
                    fontWeight: 600,
                  ),
                  Row(
                    children: [
                      MyContainer(
                        onTap: () {
                          controller.promo();
                        },
                        paddingAll: 8,
                        color: controller.isPromo
                            ? contentTheme.success
                            : contentTheme.primary,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.euro,
                              size: 20,
                              color: contentTheme.onPrimary,
                            ),
                            MySpacing.width(8),
                            MyText.bodyMedium(
                              "Promo",
                              color: contentTheme.onPrimary,
                            )
                          ],
                        ),
                      ),
                      MySpacing.width(8),
                      MyContainer(
                        onTap: () {
                          controller.top10(widget.codCliente);
                        },
                        paddingAll: 8,
                        color: controller.isTop10
                            ? contentTheme.success
                            : contentTheme.primary,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.listFilter,
                              size: 20,
                              color: contentTheme.onPrimary,
                            ),
                            MySpacing.width(8),
                            MyText.bodyMedium(
                              "Top 70",
                              color: contentTheme.onPrimary,
                            )
                          ],
                        ),
                      ),
                      MySpacing.width(8),
                      MyContainer(
                        onTap: () {
                          controller.tuttiGliArticoli(
                              controller.articoliSelezionati,
                              controller.articoliCancellati);
                        },
                        paddingAll: 8,
                        color: controller.isAll
                            ? contentTheme.success
                            : contentTheme.primary,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.listPlus,
                              size: 20,
                              color: contentTheme.onPrimary,
                            ),
                            MySpacing.width(8),
                            MyText.bodyMedium(
                              "Tutti gli Articoli",
                              color: contentTheme.onPrimary,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: MySpacing.x(flexSpacing / 2),
              child: MyFlex(
                children: [
                  MyFlexItem(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        !controller.loading
                            ? SizedBox(
                                width: double.infinity,
                                child: PaginatedDataTable(
                                  dataRowMaxHeight: 48,
                                  columnSpacing: 10,
                                  header: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      /* Padding(
                                        padding: MySpacing.top(24),
                                        child: SizedBox(
                                          width: 250,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                ),
                                                prefixIcon: Icon(
                                                    LucideIcons.search,
                                                    size: 20),
                                                hintText: 'Cerca',
                                                contentPadding:
                                                    MySpacing.xy(12, 4)),
                                            onChanged: (value) {
                                              controller.filterByName(value);
                                            },
                                          ),
                                        ),
                                      ),*/
                                      Row(
                                        children: [
                                          if (controller.isTop10)
                                            MyContainer(
                                              onTap: () {
                                                controller.orderUltimaVendita();
                                              },
                                              paddingAll: 8,
                                              color: controller.isAll
                                                  ? contentTheme.success
                                                  : contentTheme.primary,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    controller.isUltimaVendita ==
                                                            null
                                                        ? LucideIcons.filter
                                                        : controller.isUltimaVendita ==
                                                                true
                                                            ? Icons
                                                                .arrow_drop_down_outlined
                                                            : Icons
                                                                .arrow_drop_up_outlined,
                                                    size: 20,
                                                    color:
                                                        contentTheme.onPrimary,
                                                  ),
                                                  MySpacing.width(8),
                                                  MyText.bodyMedium(
                                                    "Ultima vendita",
                                                    color:
                                                        contentTheme.onPrimary,
                                                  )
                                                ],
                                              ),
                                            ),
                                          MySpacing.width(8),
                                          if (controller.isTop10)
                                            MyContainer(
                                              onTap: () {
                                                controller.orderNrVendite();
                                              },
                                              paddingAll: 8,
                                              color: controller.isAll
                                                  ? contentTheme.success
                                                  : contentTheme.primary,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    controller.isNrVendite ==
                                                            null
                                                        ? LucideIcons.filter
                                                        : controller.isNrVendite ==
                                                                true
                                                            ? Icons
                                                                .arrow_drop_down_outlined
                                                            : Icons
                                                                .arrow_drop_up_outlined,
                                                    size: 20,
                                                    color:
                                                        contentTheme.onPrimary,
                                                  ),
                                                  MySpacing.width(8),
                                                  MyText.bodyMedium(
                                                    "Numero vendite",
                                                    color:
                                                        contentTheme.onPrimary,
                                                  )
                                                ],
                                              ),
                                            ),
                                          MySpacing.width(8),
                                          MyContainer(
                                            onTap: () {
                                              Navigator.pop(
                                                  context,
                                                  controller
                                                      .articoliSelezionati);
                                            },
                                            paddingAll: 8,
                                            color: contentTheme.primary,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  LucideIcons.plus,
                                                  size: 20,
                                                  color: contentTheme.onPrimary,
                                                ),
                                                MySpacing.width(8),
                                                MyText.bodyMedium(
                                                  "Aggiungi",
                                                  color: contentTheme.onPrimary,
                                                ),
                                              ],
                                            ),
                                          ),
                                          MySpacing.width(8),
                                          MyContainer.bordered(
                                            paddingAll: 8,
                                            onTap: () {
                                              Navigator.pop(
                                                  context,
                                                  controller
                                                      .articoliSelezionati);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(LucideIcons.x, size: 20),
                                                MySpacing.width(8),
                                                MyText.bodyMedium(
                                                  "Chiudi",
                                                  fontWeight: 600,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  showCheckboxColumn: false,
                                  columns: [
                                    DataColumn(
                                        onSort: (columnIndex, ascending) {
                                          controller.orderByCodArt();
                                        },
                                        label: ordinamento(
                                            "Codice",
                                            controller.sortCodArt,
                                            controller.codice,
                                            true)),
                                    DataColumn(
                                        onSort: (columnIndex, ascending) {
                                          controller.orderByDesc();
                                        },
                                        label: ordinamento(
                                            "Descrizione",
                                            controller.sortDesc,
                                            controller.desc,
                                            true)),
                                    DataColumn(
                                        onSort: (columnIndex, ascending) {
                                          controller.orderByCodAlt();
                                        },
                                        label: ordinamento(
                                            "Cod. Alt.",
                                            controller.sortCodAlt,
                                            controller.codAlt,
                                            true)),
                                    /* DataColumn(
                                                  label: MyText.bodyMedium(
                                                'Um',
                                              )),*/
                                    DataColumn(
                                        onSort: (columnIndex, ascending) {
                                          controller.orderByConf();
                                        },
                                        label: ordinamento("Confezione",
                                            controller.sortConf, null, false)),
                                    DataColumn(
                                        numeric: true,
                                        label: ordinamento(
                                            "Q.ta", null, null, false)),
                                    DataColumn(
                                        numeric: true,
                                        onSort: (columnIndex, ascending) {
                                          controller.orderByPrezzo1();
                                        },
                                        label: ordinamento(
                                            controller
                                                    .listini?[0].descrizione ??
                                                "",
                                            //"Prz. Listino 1",
                                            controller.sortPrezzo1,
                                            null,
                                            false)),
                                    DataColumn(
                                        numeric: true,
                                        onSort: (columnIndex, ascending) {
                                          controller.isPromo
                                              ? controller.orderByPrezzo2()
                                              : controller.orderByPrezzo3();
                                        },
                                        label: ordinamento(
                                            controller.isPromo
                                                ? (controller.listini?[1]
                                                        .descrizione ??
                                                    "")
                                                : controller.listini?[2]
                                                        .descrizione ??
                                                    "",
                                            controller.isPromo
                                                ? controller.sortPrezzo2
                                                : controller.sortPrezzo3,
                                            null,
                                            false)),
                                    DataColumn(
                                        numeric: true,
                                        onSort: (columnIndex, ascending) {
                                          controller.orderByDispo();
                                        },
                                        label: ordinamento('Disp',
                                            controller.sortDisp, null, false)),
                                    DataColumn(
                                        label: ordinamento("Nota Magazzino",
                                            null, null, false)),
                                    DataColumn(
                                        onSort: (columnIndex, ascending) {
                                          controller.orderByCatArt();
                                        },
                                        label: ordinamento(
                                            "Categoria Articolo",
                                            controller.sortCat,
                                            controller.cat,
                                            true)),
                                  ],
                                  showEmptyRows: false,
                                  source: controller.data!,
                                  horizontalMargin: 20,
                                  rowsPerPage: controller.data!.rowCount > 20
                                      ? 20
                                      : controller.data!.rowCount == 0
                                          ? 1
                                          : controller.data!.rowCount,
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: contentTheme.primary,
                                  strokeWidth: 3,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mobile() {
    return Column(
      children: [
        Padding(
          padding: MySpacing.xy(flexSpacing / 2, flexSpacing / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText.titleMedium(
                    "Articoli",
                    fontSize: 18,
                    fontWeight: 600,
                  ),
                  Row(
                    children: [
                      MyContainer(
                        onTap: () {
                          Navigator.pop(
                              context, controller.articoliSelezionati);
                        },
                        paddingAll: 12,
                        color: contentTheme.primary,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.plus,
                              size: 15,
                              color: contentTheme.onPrimary,
                            ),
                            MySpacing.width(8),
                            MyText.bodySmall(
                              "Aggiungi",
                              color: contentTheme.onPrimary,
                            )
                          ],
                        ),
                      ),
                      MySpacing.width(8),
                      MyContainer.bordered(
                        paddingAll: 8,
                        onTap: () {
                          Navigator.pop(
                              context, controller.articoliSelezionati);
                        },
                        child: Icon(LucideIcons.x, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              MySpacing.height(8),
              MyContainer(
                paddingAll: 0,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: MyText.titleMedium("Filtri"),
                    childrenPadding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    children: [
                      pulsantiMobile(),
                      if (controller.isTop10) filtriMobile(),
                      ...textInputFiltri()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: !controller.loading
              ? Padding(
                  padding: MySpacing.xy(flexSpacing / 2, flexSpacing / 2),
                  child: ListView.separated(
                    controller: controller.scrollController,
                    //physics: const NeverScrollableScrollPhysics(),
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.articoliMobile.length,
                    itemBuilder: (context, index) {
                      Articolo data = controller.articoliMobile[index];
                      TextEditingController textController =
                          TextEditingController();
                      textController.text =
                          controller.articoliMobile[index].conf == null
                              ? "0"
                              : Utils.formatStringDecimal(
                                  controller.articoliMobile[index].conf, 0);
                      textController.text =
                          controller.articoliMobile[index].conf == null
                              ? "0"
                              : Utils.formatStringDecimal(
                                  controller.articoliMobile[index].conf, 0);
                      textController.selection = TextSelection.fromPosition(
                          TextPosition(offset: textController.text.length));
                      var prz1 = data.prezzoListini
                          ?.where((element) => element.listino == 1)
                          .first
                          .valore;
                      var prz2 = controller.isPromo
                          ? data.prezzoListini
                              ?.where((element) => element.listino == 2)
                              .first
                              .valore
                          : data.prezzoListini
                              ?.where((element) => element.listino == 3)
                              .first
                              .valore;
                      return Column(
                        children: [
                          MyContainer(
                              width: double.infinity,
                              // height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: MyText.bodyMedium(
                                        fontWeight: 700,
                                        color: data.disponibile! /
                                                    (1 * (data.qtaArt ?? 1)) <
                                                1
                                            ? Colors.red
                                            : null,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        "${data.descrizione} (${Utils.formatStringDecimal(data.qtaArt, data.numDecArt ?? 2)} ${data.um1})"),
                                  ),
                                  MySpacing.height(6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildProfileDetail(
                                          "Cod. Art.",
                                          data.codArt ?? "",
                                          CrossAxisAlignment.start,
                                          data.disponibile! /
                                                      (1 * (data.qtaArt ?? 1)) <
                                                  1
                                              ? Colors.red
                                              : null),
                                      buildProfileDetail(
                                          "Cod. Alt.",
                                          data.codAlt ?? "",
                                          CrossAxisAlignment.end,
                                          data.disponibile! /
                                                      (1 * (data.qtaArt ?? 1)) <
                                                  1
                                              ? Colors.red
                                              : null),
                                    ],
                                  ),
                                  MySpacing.height(6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildProfileDetail(
                                          "Cat. Stat.",
                                          data.catStatistica ?? "",
                                          CrossAxisAlignment.start,
                                          data.disponibile! /
                                                      (1 * (data.qtaArt ?? 1)) <
                                                  1
                                              ? Colors.red
                                              : null),
                                      buildProfileDetail(
                                          "Disponibile",
                                          "${data.disponibile}",
                                          CrossAxisAlignment.end,
                                          data.disponibile! /
                                                      (1 * (data.qtaArt ?? 1)) <
                                                  1
                                              ? Colors.red
                                              : null),
                                    ],
                                  ),
                                  MySpacing.height(6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildProfileDetail(
                                          controller.listini?[0].descrizione ??
                                              "",
                                          "€ ${Utils.formatStringDecimal(prz1, 3)}",
                                          CrossAxisAlignment.start,
                                          data.disponibile! /
                                                      (1 * (data.qtaArt ?? 1)) <
                                                  1
                                              ? Colors.red
                                              : null),
                                      buildProfileDetail(
                                          controller.isPromo
                                              ? (controller.listini?[1]
                                                      .descrizione ??
                                                  "")
                                              : controller.listini?[2]
                                                      .descrizione ??
                                                  "",
                                          "€ ${Utils.formatStringDecimal(prz2, 3)}",
                                          CrossAxisAlignment.end,
                                          data.disponibile! /
                                                      (1 * (data.qtaArt ?? 1)) <
                                                  1
                                              ? Colors.red
                                              : null),
                                    ],
                                  ),
                                  MySpacing.height(6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: buildProfileDetail(
                                            "Nota Magazzino",
                                            "${data.notaArt}",
                                            CrossAxisAlignment.start,
                                            data.disponibile! /
                                                        (1 *
                                                            (data.qtaArt ??
                                                                1)) <
                                                    1
                                                ? Colors.red
                                                : null),
                                      ),
                                      MySpacing.width(8),
                                      Expanded(
                                          flex: 1,
                                          child: confPickerMobile(
                                              data, textController))
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: contentTheme.primary,
                    strokeWidth: 3,
                  ),
                ),
        ),
      ],
    );
  }

  Widget confPickerMobile(Articolo data, TextEditingController textController) {
    return Row(
      children: [
        data.disponibile! / (1 * (data.qtaArt ?? 1)) < 1
            ? Container()
            : MyContainer.roundBordered(
                onTap: () {
                  if ((data.conf! - 1 >= 0)) {
                    data.conf = data.conf! - 1;
                    textController.text =
                        Utils.formatStringDecimal(data.conf, 0);
                    controller.modificaArticolo(data);
                  }
                },
                paddingAll: 4,
                borderRadiusAll: 2,
                child: Icon(
                  LucideIcons.minus,
                  size: 18,
                ),
              ),
        MySpacing.width(10),
        data.disponibile! / (1 * (data.qtaArt ?? 1)) < 1
            ? Container()
            : Flexible(
                child: TextField(
                  controller: textController,
                  style: MyTextStyle.titleMedium(
                    fontWeight: 800,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  decoration: new InputDecoration.collapsed(hintText: ''),
                  onTap: () => textController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: textController.value.text.length),
                  onChanged: (value) {
                    if (value != "" && value != " ") {
                      if ((int.parse(value) * (data.qtaArt ?? 1)) >
                          data.disponibile!) {
                        var qta =
                            data.disponibile!.toDouble() / (data.qtaArt ?? 1);
                        var qtaArr = qta.floor().toString();
                        data.conf = double.parse(
                            qtaArr); /*(articolo.disponibile!.toDouble() /
                                (articolo.qtaArt ?? 1).toInt());*/
                        textController.text =
                            Utils.formatStringDecimal(double.parse(qtaArr), 0);
                        controller.modificaArticolo(data);
                      } else {
                        data.conf = double.parse(value);
                        controller.modificaArticolo(data);
                      }
                    }
                  },
                ),
              ),
        MySpacing.width(10),
        data.disponibile! / (1 * (data.qtaArt ?? 1)) < 1
            ? Container()
            : MyContainer.roundBordered(
                onTap: () {
                  if (((data.conf! + 1) * (data.qtaArt ?? 1)) <=
                      data.disponibile!) {
                    data.conf = data.conf! + 1;
                    textController.text =
                        Utils.formatStringDecimal(data.conf, 0);
                    controller.modificaArticolo(data);
                  }
                },
                paddingAll: 4,
                borderRadiusAll: 2,
                child: Icon(
                  LucideIcons.plus,
                  size: 18,
                ),
              ),
      ],
    );
  }

  Widget buildProfileDetail(String title, String subTitle,
      CrossAxisAlignment aligment, Color? color) {
    return Column(
      crossAxisAlignment: aligment,
      children: [
        MyText.bodySmall(
          title,
          //  color: Colors.grey,
        ),
        MyText.bodyMedium(
          subTitle,
          fontWeight: 700,
          color: color,
        ),
      ],
    );
  }

  Widget filtriMobile() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (controller.isTop10)
              Expanded(
                child: MyContainer(
                  onTap: () {
                    controller.orderUltimaVendita();
                  },
                  paddingAll: 8,
                  color: controller.isAll
                      ? contentTheme.success
                      : contentTheme.primary,
                  child: Row(
                    children: [
                      Icon(
                        controller.isUltimaVendita == null
                            ? LucideIcons.filter
                            : controller.isUltimaVendita == true
                                ? Icons.arrow_drop_down_outlined
                                : Icons.arrow_drop_up_outlined,
                        size: 20,
                        color: contentTheme.onPrimary,
                      ),
                      MySpacing.width(8),
                      MyText.bodyMedium(
                        "Ultima vendita",
                        color: contentTheme.onPrimary,
                      )
                    ],
                  ),
                ),
              ),
            MySpacing.width(4),
            if (controller.isTop10)
              Expanded(
                child: MyContainer(
                  onTap: () {
                    controller.orderNrVendite();
                  },
                  paddingAll: 8,
                  color: controller.isAll
                      ? contentTheme.success
                      : contentTheme.primary,
                  child: Row(
                    children: [
                      Icon(
                        controller.isNrVendite == null
                            ? LucideIcons.filter
                            : controller.isNrVendite == true
                                ? Icons.arrow_drop_down_outlined
                                : Icons.arrow_drop_up_outlined,
                        size: 20,
                        color: contentTheme.onPrimary,
                      ),
                      MySpacing.width(8),
                      MyText.bodyMedium(
                        "Numero vendite",
                        color: contentTheme.onPrimary,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget pulsantiMobile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 0,
          child: MyContainer(
            onTap: () {
              controller.promo();
            },
            paddingAll: 8,
            color: controller.isPromo
                ? contentTheme.success
                : contentTheme.primary,
            child: Row(
              children: [
                Icon(
                  LucideIcons.euro,
                  size: 20,
                  color: contentTheme.onPrimary,
                ),
                MySpacing.width(8),
                MyText.bodyMedium(
                  "Promo",
                  color: contentTheme.onPrimary,
                )
              ],
            ),
          ),
        ),
        MySpacing.width(4),
        Flexible(
          flex: 0,
          child: MyContainer(
            onTap: () {
              controller.top10(widget.codCliente);
              controller.caricaArticoli();
            },
            paddingAll: 8,
            color: controller.isTop10
                ? contentTheme.success
                : contentTheme.primary,
            child: Row(
              children: [
                Icon(
                  LucideIcons.listFilter,
                  size: 20,
                  color: contentTheme.onPrimary,
                ),
                MySpacing.width(8),
                MyText.bodyMedium(
                  "Top 70",
                  color: contentTheme.onPrimary,
                )
              ],
            ),
          ),
        ),
        MySpacing.width(4),
        Flexible(
          flex: 1,
          child: MyContainer(
            onTap: () {
              controller.tuttiGliArticoli(controller.articoliSelezionati,
                  controller.articoliCancellati);
            },
            paddingAll: 8,
            color:
                controller.isAll ? contentTheme.success : contentTheme.primary,
            child: Row(
              children: [
                Icon(
                  LucideIcons.listPlus,
                  size: 20,
                  color: contentTheme.onPrimary,
                ),
                MySpacing.width(8),
                MyText.bodyMedium(
                  "Tutti gli Articoli",
                  color: contentTheme.onPrimary,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  textInputFiltri() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextFormField(
          controller: controller.codice,
          onChanged: (value) {
            controller.filtro();
          },
          decoration: InputDecoration(
            counterStyle: TextStyle(
              height: double.minPositive,
            ),
            counterText: "",
            hintText: "Filtra per codice",
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(10),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextFormField(
          controller: controller.desc,
          onChanged: (value) {
            controller.filtro();
          },
          decoration: InputDecoration(
            counterStyle: TextStyle(
              height: double.minPositive,
            ),
            counterText: "",
            hintText: "Filtra per descrizione",
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(10),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextFormField(
          controller: controller.codAlt,
          onChanged: (value) {
            controller.filtro();
          },
          decoration: InputDecoration(
            counterStyle: TextStyle(
              height: double.minPositive,
            ),
            counterText: "",
            hintText: "Filtra per Cod. Alt.",
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(10),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextFormField(
          controller: controller.cat,
          onChanged: (value) {
            controller.filtro();
          },
          decoration: InputDecoration(
            counterStyle: TextStyle(
              height: double.minPositive,
            ),
            counterText: "",
            hintText: "Filtra per categoria",
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(10),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      )
    ];
  }
  /* Widget ordinamento(String titolo, bool? valore) {
    return Row(
      children: [
        MyText.bodyMedium(titolo, fontWeight: 600),
        valore == null
            ? Text("")
            : valore
                ? Icon(Icons.arrow_drop_down_outlined)
                : Icon(Icons.arrow_drop_up_outlined)
      ],
    );
  }*/

  Widget ordinamento(String titolo, bool? valore,
      TextEditingController? controller, bool visible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MyText.bodyMedium(titolo, fontWeight: 600),
            valore == null
                ? Text("")
                : valore
                    ? Icon(Icons.arrow_drop_down_outlined)
                    : Icon(Icons.arrow_drop_up_outlined)
          ],
        ),
        MySpacing.height(3),
        Visibility(
          visible: visible,
          child: Container(
            width: 100,
            child: TextFormField(
              controller: controller,
              /*keyboardType: keyboaardType,
                maxLength: maxLength,
                enabled: enabled,
                controller: controller,
                validator: validator,*/
              onChanged: (value) {
                this.controller.filtro();
              },
              decoration: InputDecoration(
                counterStyle:
                    TextStyle(height: double.minPositive, fontSize: 10),
                counterText: "",
                hintStyle: MyTextStyle.bodySmall(xMuted: true),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: focusedInputBorder,
                contentPadding: MySpacing.all(4),
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyDataListArtModal extends DataTableSource with UIMixin {
  List<Articolo> orderList = [];
  BuildContext context;
  ModalListaArtController controller;

  MyDataListArtModal(this.orderList, this.context, this.controller);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    Articolo articolo = orderList[index];
    TextEditingController textController = TextEditingController();
    textController.text = orderList[index].conf == null
        ? "0"
        : Utils.formatStringDecimal(orderList[index].conf, 0);

    var prz1 = articolo.prezzoListini
        ?.where((element) => element.listino == 1)
        .first
        .valore;
    var prz2 = controller.isPromo
        ? articolo.prezzoListini
            ?.where((element) => element.listino == 2)
            .first
            .valore
        : articolo.prezzoListini
            ?.where((element) => element.listino == 3)
            .first
            .valore;

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (articolo.conf != null && articolo.conf! > 0) {
          return contentTheme.success;
        }
        /* if (articolo.disponibile! <= 0) {
          return Colors.red.shade200;
        }*/
        return null; // Use the default value.
      }),
      cells: [
        DataCell(MyText.bodySmall(
          articolo.codArt ?? "",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.descrizione}",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.codAlt}",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        //DataCell(MyText.bodySmall("${articolo.um1}")),
        DataCell(Row(
          children: [
            articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
                ? Container()
                : MyContainer.roundBordered(
                    onTap: () {
                      if ((articolo.conf! - 1 >= 0)) {
                        articolo.conf = articolo.conf! - 1;
                        textController.text =
                            Utils.formatStringDecimal(articolo.conf, 0);
                        controller.modificaArticolo(articolo);
                      }
                    },
                    paddingAll: 4,
                    borderRadiusAll: 2,
                    child: Icon(
                      LucideIcons.minus,
                      size: 18,
                    ),
                  ),
            MySpacing.width(10),
            articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
                ? Container()
                : Flexible(
                    child: TextField(
                      controller: textController,
                      style: MyTextStyle.titleMedium(
                        fontWeight: 800,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration.collapsed(hintText: ''),
                      onTap: () => textController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: textController.value.text.length),
                      onChanged: (value) {
                        if (value != "" && value != " ") {
                          if ((int.parse(value) * (articolo.qtaArt ?? 1)) >
                              articolo.disponibile!) {
                            var qta = articolo.disponibile!.toDouble() /
                                (articolo.qtaArt ?? 1);
                            var qtaArr = qta.floor().toString();
                            articolo.conf = double.parse(
                                qtaArr); /*(articolo.disponibile!.toDouble() /
                                (articolo.qtaArt ?? 1).toInt());*/
                            textController.text = Utils.formatStringDecimal(
                                double.parse(qtaArr), 0);
                            controller.modificaArticolo(articolo);
                          } else {
                            articolo.conf = double.parse(value);
                            controller.modificaArticolo(articolo);
                          }
                        }
                      },
                    ),
                  ),
            MySpacing.width(10),
            articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
                ? Container()
                : MyContainer.roundBordered(
                    onTap: () {
                      if (((articolo.conf! + 1) * (articolo.qtaArt ?? 1)) <=
                          articolo.disponibile!) {
                        articolo.conf = articolo.conf! + 1;
                        textController.text =
                            Utils.formatStringDecimal(articolo.conf, 0);
                        controller.modificaArticolo(articolo);
                      }
                    },
                    paddingAll: 4,
                    borderRadiusAll: 2,
                    child: Icon(
                      LucideIcons.plus,
                      size: 18,
                    ),
                  ),
          ],
        )),
        DataCell(MyText.bodySmall(
          "${Utils.formatStringDecimal(articolo.qtaArt, articolo.numDecArt ?? 2)} ${articolo.um1}",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(prz1, 3)}",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(prz2, 3)}",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        DataCell(MyText.bodySmall(
          Utils.formatStringDecimal(
              articolo.disponibile, articolo.numDecArt ?? 2),
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.notaArt}",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.catStatistica}",
          color: articolo.disponibile! / (1 * (articolo.qtaArt ?? 1)) < 1
              ? Colors.red
              : null,
        )),
      ],
    );
  }
}
