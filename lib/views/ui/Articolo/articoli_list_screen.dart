// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foody/controller/ui/Articolo/articoli_list_controller.dart';
import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_responsiv.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:foody/model/request.dart' as r;
import 'package:lucide_icons/lucide_icons.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late FoodController controller;

  @override
  void initState() {
    controller = Get.put(FoodController(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        isScroll: true,
        child: MyResponsive(builder: (BuildContext context, _, screenMT) {
          return GetBuilder(
            init: controller,
            builder: (controller) {
              return screenMT.isMobile ? mobile() : desktop();
            },
          );
        }));
  }

  Widget desktop() {
    return Column(
      children: [
        Padding(
          padding: MySpacing.x(flexSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText.titleMedium(
                "Articoli",
                fontSize: 18,
                fontWeight: 600,
              ),
              MyBreadcrumb(
                children: [
                  MyBreadcrumbItem(name: 'Articoli', active: true),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: MySpacing.top(24),
                                    child: SizedBox(
                                      width: 250,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                            prefixIcon: Icon(LucideIcons.search,
                                                size: 20),
                                            hintText: 'Cerca',
                                            contentPadding:
                                                MySpacing.xy(12, 4)),
                                        onChanged: (value) {
                                          controller.filterByName(value);
                                        },
                                      ),
                                    ),
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
                                          controller.tuttiGliArticoli();
                                        },
                                        paddingAll: 8,
                                        color: !controller.isPromo
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
                                        "Codice", controller.sortCodArt)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) {
                                      controller.orderByDesc();
                                    },
                                    label: ordinamento(
                                        "Descrizione", controller.sortDesc)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) {
                                      controller.orderByCodAlt();
                                    },
                                    label: ordinamento(
                                        "Cod. Alt.", controller.sortCodAlt)),
                                DataColumn(
                                    numeric: true,
                                    label: MyText.bodyMedium('Q.tà',
                                        fontWeight: 600)),
                                DataColumn(
                                    numeric: true,
                                    onSort: (columnIndex, ascending) {
                                      controller.orderByPrezzo1();
                                    },
                                    label: ordinamento(
                                        controller.listini?[0].descrizione ??
                                            "",
                                        //"Prz. Listino 1",
                                        controller.sortPrezzo1)),
                                DataColumn(
                                    numeric: true,
                                    onSort: (columnIndex, ascending) {
                                      controller.isPromo
                                          ? controller.orderByPrezzo2()
                                          : controller.orderByPrezzo3();
                                    },
                                    label: ordinamento(
                                        controller.isPromo
                                            ? (controller
                                                    .listini?[1].descrizione ??
                                                "")
                                            : controller
                                                    .listini?[2].descrizione ??
                                                "",
                                        controller.isPromo
                                            ? controller.sortPrezzo2
                                            : controller.sortPrezzo3)),
                                DataColumn(
                                    numeric: true,
                                    onSort: (columnIndex, ascending) {
                                      controller.orderByDispo();
                                    },
                                    label: ordinamento(
                                        'Disp', controller.sortDisp)),
                                DataColumn(
                                    label: MyText.bodyMedium('Nota Magazzino',
                                        fontWeight: 600)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) {
                                      controller.orderByCatArt();
                                    },
                                    label: ordinamento("Categoria Articolo",
                                        controller.sortCat)),
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
                  pulsantiMobile(),
                ],
              ),
              MySpacing.height(12),
              SizedBox(
                //width: 250,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      prefixIcon: Icon(LucideIcons.search, size: 20),
                      hintText: 'Cerca',
                      contentPadding: MySpacing.xy(12, 4)),
                  onChanged: (value) {
                    controller.filterByName(value);
                  },
                ),
              ),
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
                              onTap: () => controller.mostraImmagine(data),
                              width: double.infinity,
                              // height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: MyText.bodyMedium(
                                        fontWeight: 700,
                                        color: data.disponibile! <= 0
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
                                          data.disponibile! <= 0
                                              ? Colors.red
                                              : null),
                                      buildProfileDetail(
                                          "Cod. Alt.",
                                          data.codAlt ?? "",
                                          CrossAxisAlignment.end,
                                          data.disponibile! <= 0
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
                                          data.disponibile! <= 0
                                              ? Colors.red
                                              : null),
                                      buildProfileDetail(
                                          "Disponibile",
                                          "${data.disponibile}",
                                          CrossAxisAlignment.end,
                                          data.disponibile! <= 0
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
                                          data.disponibile! <= 0
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
                                          data.disponibile! <= 0
                                              ? Colors.red
                                              : null),
                                    ],
                                  ),
                                  MySpacing.height(6),
                                  buildProfileDetail(
                                      "Nota Magazzino",
                                      "${data.notaArt}",
                                      CrossAxisAlignment.start,
                                      data.disponibile! <= 0
                                          ? Colors.red
                                          : null),
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

  Widget pulsantiMobile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MyContainer(
          onTap: () {
            controller.promo();
          },
          paddingAll: 8,
          color:
              controller.isPromo ? contentTheme.success : contentTheme.primary,
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
            controller.tuttiGliArticoli();
          },
          paddingAll: 8,
          color:
              !controller.isPromo ? contentTheme.success : contentTheme.primary,
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
    );
  }

  Widget ordinamento(String titolo, bool? valore) {
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
  }
}

class MyData extends DataTableSource with UIMixin {
  List<Articolo> orderList = [];
  BuildContext context;
  FoodController controller;

  MyData(this.orderList, this.context, this.controller);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    Articolo articolo = controller.articoliFiltrati[index];
    TextEditingController textController = TextEditingController();
    textController.text = controller.articoliFiltrati[index].conf == null
        ? "0"
        : Utils.formatStringDecimal(controller.articoliFiltrati[index].conf, 0);

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
      cells: [
        DataCell(MyText.bodySmall(
          articolo.codArt ?? "",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.descrizione}",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.codAlt}",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        //DataCell(MyText.bodySmall("${articolo.um1}")),
        DataCell(MyText.bodySmall(
          "${Utils.formatStringDecimal(articolo.qtaArt, articolo.numDecArt ?? 2)} ${articolo.um1}",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(prz1, 3)}",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(prz2, 3)}",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        DataCell(MyText.bodySmall(
          Utils.formatStringDecimal(
              articolo.disponibile, articolo.numDecArt ?? 2),
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.notaArt}",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
        DataCell(MyText.bodySmall(
          "${articolo.catStatistica}",
          color: articolo.disponibile! <= 0 ? Colors.red : null,
        )),
      ],
      onSelectChanged: (value) async {
        controller.mostraImmagine(articolo);
      },
    );
  }

  /* void gotoEdit(String clientId) {
    codClienteSelezionato = clientId;
    Get.toNamed('/admin/customers/edit', arguments: clientId);
  }

  void gotoDetail(String clientId) {
    codClienteSelezionato = clientId;
    Get.toNamed('/admin/customers/detail', arguments: clientId);
  }*/
}
