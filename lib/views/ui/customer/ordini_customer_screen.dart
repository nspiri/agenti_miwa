import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foody/controller/ui/customer/ordini_customer_controller.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/ordine.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrdiniListCustomerScreen extends StatefulWidget {
  const OrdiniListCustomerScreen({super.key});

  @override
  State<OrdiniListCustomerScreen> createState() =>
      _OrdiniListCustomerScreenState();
}

class _OrdiniListCustomerScreenState extends State<OrdiniListCustomerScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late OrdiniListCustomerController controller;
  late CustomerDetail? cliente;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
    });
    cliente = Get.arguments;
    cliente ??= clienteSelezionato;
    controller = Get.put(OrdiniListCustomerController());
    controller.isLoading = true;
    controller.getOrdini(cliente!);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: MyText.titleMedium(
                        "Ordini: ${cliente?.ragioneSociale}",
                        fontSize: 18,
                        fontWeight: 600,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(
                          name: 'Ordini',
                          active: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing / 2),
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        !controller.isLoading
                            ? controller.ordini.isNotEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    child: PaginatedDataTable(
                                      showCheckboxColumn: false,
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
                                                  controller
                                                      .filterByName(value);
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
                                      columns: [
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
                                            onSort: (columnIndex, ascending) =>
                                                controller.orderByRagSoc(),
                                            label: ordinamento("Rag. Sociale",
                                                controller.ragSoc)),
                                        DataColumn(
                                            onSort: (columnIndex, ascending) =>
                                                controller.orderByLocalita(),
                                            label: ordinamento("Località",
                                                controller.localita)),
                                        DataColumn(
                                            onSort: (columnIndex, ascending) =>
                                                controller.orderByTot(),
                                            numeric: true,
                                            label: ordinamento(
                                                "Totale", controller.totale)),
                                      ],
                                      showEmptyRows: false,
                                      source: controller.data!,
                                      rowsPerPage:
                                          controller.data!.rowCount > 20
                                              ? 20
                                              : controller.data!.rowCount == 0
                                                  ? 1
                                                  : controller.data!.rowCount,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: MyText.titleMedium(
                                      "Non ci sono ordini in corso per questo cliente",
                                      //fontWeight: 600,
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

class MyDataDetailOrdiniCustomer extends DataTableSource with UIMixin {
  List<Ordine> listaScadenziario = [];
  OrdiniListCustomerController controller;

  MyDataDetailOrdiniCustomer(this.listaScadenziario, this.controller);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listaScadenziario.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    Ordine ordine = listaScadenziario[index];

    return DataRow(
      cells: [
        DataCell(MyText.bodySmall(
          "${ordine.ocsig} ${ordine.ocser}/${ordine.ocnum}",
        )),
        DataCell(MyText.bodySmall(
          Utils.getFormattedDate(ordine.ocdat!),
        )),
        /*DataCell(MyText.bodyMedium(
          "${scadenza.documento}",
          fontWeight: 600,
        )),*/
        DataCell(MyText.bodySmall(
          "${ordine.occliDesc}",
        )),
        DataCell(MyText.bodySmall(
          "${ordine.occliLoc}",
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(ordine.octdp, 2)}",
        )),
      ],
      onSelectChanged: (value) => controller.goToDettaglio(ordine),
    );
  }
}
