import 'package:flutter/material.dart';
import 'package:foody/controller/ui/restaurant/restaurants_list_controller.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/restaurant_data.dart';
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ScadenziarioListScreen extends StatefulWidget {
  const ScadenziarioListScreen({super.key});

  @override
  State<ScadenziarioListScreen> createState() => _ScadenziarioListScreenState();
}

class _ScadenziarioListScreenState extends State<ScadenziarioListScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late ScadenziarioListController controller;

  @override
  void initState() {
    controller = Get.put(ScadenziarioListController());
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
                      "Scadenziario",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(
                          name: 'Scadenziario',
                          active: true,
                        ),
                      ],
                    ),
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
                        if (controller.scadenziario.isNotEmpty)
                          SizedBox(
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
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                            prefixIcon: Icon(LucideIcons.search,
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
                                  Padding(
                                    padding: MySpacing.top(24),
                                    child: SizedBox(
                                        child: MyText.bodyLarge(
                                      "Totale: € ${controller.totale}",
                                      fontWeight: 600,
                                    )),
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
                                /* DataColumn(
                                    label: MyText.labelLarge('Cod. Cliente',
                                        fontWeight: 600)),*/
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByRagSoc(),
                                    label: ordinamento(
                                        "Rag. Sociale", controller.ragSoc)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByDoc(),
                                    label: ordinamento(
                                        "Documento", controller.doc)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByData(),
                                    label: ordinamento(
                                        "Data", controller.dataAsc)),
                                DataColumn(
                                    label: MyText.labelLarge('Tipo Pagamento',
                                        fontWeight: 600)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByDataScad(),
                                    label: ordinamento(
                                        "Scadenza", controller.dataScad)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByImporto(),
                                    numeric: true,
                                    label: ordinamento(
                                        "Importo", controller.importo)),
                              ],
                              source: controller.data!,
                              rowsPerPage: controller.data!.rowCount > 20
                                  ? 20
                                  : controller.data!.rowCount == 0
                                      ? 1
                                      : controller.data!.rowCount,
                            ),
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

class MyDataDetailScadenziario extends DataTableSource with UIMixin {
  List<ScadenziarioCliente> listaScadenziario = [];

  MyDataDetailScadenziario(this.listaScadenziario);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listaScadenziario.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    ScadenziarioCliente scadenza = listaScadenziario[index];

    return DataRow(
      cells: [
        /*   DataCell(MyText.bodyMedium(
          "${scadenza.codCliente}",
          fontWeight: 600,
        )),*/
        DataCell(MyText.bodySmall(
          "${scadenza.ragioneSociale}",
        )),
        /*DataCell(MyText.bodyMedium(
          "${scadenza.documento}",
          fontWeight: 600,
        )),*/
        DataCell(MyText.bodySmall(
          "${scadenza.documento} ${scadenza.serie}/${scadenza.numero}",
        )),
        DataCell(MyText.bodySmall(
          Utils.getFormattedDate(scadenza.data!),
        )),
        DataCell(MyText.bodySmall(
          "${scadenza.tipoPagamento}",
        )),
        DataCell(MyText.bodySmall(
          Utils.getFormattedDate(scadenza.dataScadenza!),
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(scadenza.importo, 2)}",
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
