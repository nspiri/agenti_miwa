import 'package:flutter/material.dart';
import 'package:foody/controller/ui/Attrezzature/attrezzature_controller.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AttrezzatureCondScreen extends StatefulWidget {
  const AttrezzatureCondScreen({super.key});

  @override
  State<AttrezzatureCondScreen> createState() => _AttrezzatureCondScreenState();
}

class _AttrezzatureCondScreenState extends State<AttrezzatureCondScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late AttrezzatureCondController controller;
  List<Attrezzatura> attrezzature = [];

  @override
  void initState() {
    attrezzature = Get.arguments;
    controller = Get.put(AttrezzatureCondController());
    controller.setAttrezzature(attrezzature);
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
                      "Stato Attrezzature",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyContainer(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      paddingAll: 8,
                      color: contentTheme.primary,
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.doorClosed,
                            size: 20,
                            color: contentTheme.onPrimary,
                          ),
                          MySpacing.width(8),
                          MyText.bodyMedium(
                            "Chiudi",
                            color: contentTheme.onPrimary,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        controller.attrezzature.isNotEmpty
                            ? SizedBox(
                                width: double.infinity,
                                child: PaginatedDataTable(
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
                                                    MySpacing.xy(12, 8)),
                                            onChanged: (value) {
                                              controller.filterByName(value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  sortAscending: true,
                                  onSelectAll: (_) => {},
                                  dataRowMaxHeight: 52,
                                  //columnSpacing: 170,
                                  showFirstLastButtons: true,
                                  showCheckboxColumn: true,
                                  columns: [
                                    DataColumn(
                                        label: MyText.labelLarge(
                                      'Rag. Sociale',
                                    )),
                                    DataColumn(
                                        /* onSort: (columnIndex, ascending) =>
                                            controller.orderByData(),*/
                                        label: MyText.labelLarge(
                                      'Data inizio',
                                    )),
                                    DataColumn(
                                        label: MyText.labelLarge(
                                      'Attrezzatura',
                                    )),
                                    DataColumn(
                                        label: MyText.labelLarge(
                                      'Natura',
                                    )),
                                    DataColumn(
                                        numeric: true,
                                        label: MyText.labelLarge(
                                          'Qta. Min',
                                        )),
                                    DataColumn(
                                        label: MyText.labelLarge(
                                      'Periodo',
                                    )),
                                    DataColumn(
                                        numeric: true,
                                        label: MyText.labelLarge(
                                          'Qta. Periodo',
                                        )),
                                    DataColumn(
                                        numeric: true,
                                        label: MyText.labelLarge(
                                          'Val. Periodo',
                                        )),
                                  ],
                                  showEmptyRows: false,
                                  source: controller.data!,
                                  rowsPerPage: controller.data!.rowCount > 20
                                      ? 20
                                      : controller.data!.rowCount == 0
                                          ? 1
                                          : controller.data!.rowCount,
                                ),
                              )
                            : Container(
                                child: Column(children: [
                                  MyText.titleMedium(
                                    "Non ci sono attrezzature per questo cliente",
                                    fontWeight: 600,
                                  )
                                ]),
                              ),
                      ],
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

class MyDataDetailAttrezzatureCond extends DataTableSource with UIMixin {
  List<Attrezzatura> listaScadenziario = [];

  MyDataDetailAttrezzatureCond(this.listaScadenziario);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listaScadenziario.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    Attrezzatura scadenza = listaScadenziario[index];

    return DataRow(
      cells: [
        DataCell(MyText.bodySmall(
          "${scadenza.descrizione}",
        )),
        DataCell(MyText.bodySmall(
          Utils.getFormattedDate(scadenza.dataInizio!),
        )),
        DataCell(MyText.bodySmall(
          "${scadenza.attrezzatura}",
        )),
        DataCell(MyText.bodySmall(
          "${scadenza.natura}",
        )),
        DataCell(MyText.bodySmall(
          "${scadenza.quantitaMin}",
        )),
        DataCell(MyText.bodySmall(
          "${scadenza.tempoGg} gg",
        )),
        DataCell(MyText.bodySmall(
          Utils.formatStringDecimal(scadenza.qtaPeriodo, 2),
        )),
        DataCell(MyText.bodySmall(
          Utils.formatStringDecimal(scadenza.valPeriodo, 2),
        )),
      ],
    );
  }

  void gotoEdit(String clientId) {
    Get.toNamed('/admin/customers/edit', arguments: clientId);
  }

  void gotoDetail(String clientId) {
    Get.toNamed('/admin/customers/detail', arguments: clientId);
  }
}
