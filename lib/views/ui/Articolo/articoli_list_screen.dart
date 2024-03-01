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
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
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
                    MyText.titleMedium(
                      "Lista Articoli",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Articoli'),
                        MyBreadcrumbItem(name: 'Lista Articoli', active: true),
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
                                        ),
                                      ],
                                    ),
                                    showCheckboxColumn: false,
                                    columns: [
                                      DataColumn(
                                          label: MyText.bodyMedium(
                                        'Cod. Art',
                                      )),
                                      DataColumn(
                                          onSort: (columnIndex, ascending) {
                                            controller.orderByDesc();
                                          },
                                          label: MyText.bodyMedium(
                                            'Descrizione',
                                          )),
                                      DataColumn(
                                          onSort: (columnIndex, ascending) {
                                            controller.orderByCodAlt();
                                          },
                                          label: MyText.bodyMedium(
                                            'Cod. Alternativo',
                                          )),
                                      DataColumn(
                                          label: MyText.bodyMedium(
                                        'Um',
                                      )),
                                      DataColumn(
                                          numeric: true,
                                          label: MyText.bodyMedium(
                                            'Q.tà',
                                          )),
                                      DataColumn(
                                          numeric: true,
                                          onSort: (columnIndex, ascending) {
                                            controller.orderByPrezzo();
                                          },
                                          label: MyText.bodyMedium(
                                            'Prezzo Listino',
                                          )),
                                      DataColumn(
                                          numeric: true,
                                          onSort: (columnIndex, ascending) {
                                            controller.orderByDispo();
                                          },
                                          label: MyText.bodyMedium(
                                            'Disp',
                                          )),
                                      DataColumn(
                                          label: MyText.bodyMedium(
                                        'Nota Magazzino',
                                      )),
                                      DataColumn(
                                          onSort: (columnIndex, ascending) {
                                            controller.orderByCatArt();
                                          },
                                          label: MyText.bodyMedium(
                                            'Categoria Articolo',
                                          )),
                                    ],
                                    source: controller.data!,
                                    horizontalMargin: 20,
                                    rowsPerPage: controller.data!.rowCount < 20
                                        ? controller.data!.rowCount
                                        : 20,
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
        },
      ),
    );
  }
}

class MyData extends DataTableSource with UIMixin {
  List<Articolo> orderList = [];
  BuildContext context;

  MyData(this.orderList, this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    Articolo articolo = orderList[index];

    return DataRow(
      cells: [
        DataCell(MyText.bodySmall(articolo.codArt ?? "")),
        DataCell(MyText.bodySmall("${articolo.descrizione}")),
        DataCell(MyText.bodySmall("${articolo.codAlt}")),
        DataCell(MyText.bodySmall("${articolo.um1}")),
        DataCell(MyText.bodySmall("${articolo.qtaArt}")),
        DataCell(MyText.bodySmall(
            "€ ${Utils.formatStringDecimal(articolo.prezzoListini?[0].valore, 2)}")),
        DataCell(MyText.bodySmall("${articolo.disponibile}")),
        DataCell(MyText.bodySmall("${articolo.notaArt}")),
        DataCell(MyText.bodySmall("${articolo.catStatistica}")),
      ],
      onSelectChanged: (value) async {
        String img = "";
        r.Response res = await DoRequest.doHttpRequest(
            nomeCollage: "colsrart",
            etichettaCollage: "ARTICOLO",
            dati: {"magazzino": 1, "articolo": articolo.codArt});

        if (res.code == 200) {
          var result = res.result as List<dynamic>;
          if (result.isNotEmpty) {
            if (result[0]["arime"] != null) {
              for (var element in result[0]["arime"]) {
                img += element;
              }
              await showDialog(
                  context: context,
                  builder: (_) => Dialog(
                        child: Stack(
                          children: [
                            Image.memory(
                              base64.decode(img
                                  .replaceAll(RegExp(r'\s+'), '')
                                  .replaceAll("[", "")),
                              //base64Decode(img),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  alignment: Alignment.topRight,
                                ))
                          ],
                        ),
                      ));
            } else {
              showErrorMessage(context, "Nessuna immagine", "");
            }
          }
        } else {
          showErrorMessage(context, "Nessuna immagine", "");
        }
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
