import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/storico_customer_controller.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/storico.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EditCustomerScreen extends StatefulWidget {
  const EditCustomerScreen({super.key});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late EditCustomerController controller;
  late CustomerDetail? cliente;

  @override
  void initState() {
    cliente = Get.arguments;
    cliente ??= clienteSelezionato;
    controller = Get.put(
        EditCustomerController(codCliente: cliente?.codiceCliente ?? ""));
    controller.getData(cliente?.codiceCliente ?? "");
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
                      "Storico",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Clienti'),
                        MyBreadcrumbItem(name: 'Storico', active: true),
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
                          if (controller.data != null)
                            SizedBox(
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
                                                borderRadius: BorderRadius.all(
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
                                source: controller.data!,
                                columns: [
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByData(),
                                      label: MyText.bodyMedium('Data',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByDoc(),
                                      label: MyText.bodyMedium('Doc.',
                                          fontWeight: 600)),
                                  DataColumn(
                                      label: MyText.bodyMedium('Numero',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByCodArt(),
                                      label: MyText.bodyMedium('Codice Art.',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByDesc(),
                                      label: MyText.bodyMedium('Descrizione',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByUm(),
                                      label: MyText.bodyMedium('Um',
                                          fontWeight: 600)),
                                  DataColumn(
                                      label: MyText.bodyMedium('Q.ta',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByPrezzo(),
                                      label: MyText.bodyMedium('Prezzo',
                                          fontWeight: 600)),
                                  DataColumn(
                                      label: MyText.bodyMedium('Sconti',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByImporto(),
                                      label: MyText.bodyMedium('Importo',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByIva(),
                                      label: MyText.bodyMedium('Iva',
                                          fontWeight: 600)),
                                ],
                                columnSpacing: 10,
                                horizontalMargin: 20,
                                rowsPerPage: controller.data!.rowCount > 20
                                    ? 20
                                    : controller.data!.rowCount == 0
                                        ? 1
                                        : controller.data!.rowCount,
                                dataRowMaxHeight: 48,
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

  buildTextField(
      String fieldTitle, String hintText, TextEditingController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelMedium(
          fieldTitle,
        ),
        MySpacing.height(8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            contentPadding: MySpacing.all(16),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }
}

class MyDataDetailStorico extends DataTableSource with UIMixin {
  List<Storico> listaStorico = [];

  MyDataDetailStorico(this.listaStorico);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listaStorico.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    Storico storico = listaStorico[index];

    return DataRow(
      cells: [
        DataCell(MyText.bodyMedium(
          Utils.getFormattedDate(storico.data!),
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.documento}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.serie}/${storico.numero}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.codArt}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.desc}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.um}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.colli}*${storico.qta}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "€ ${Utils.formatStringDecimal(storico.prezzo, 2)}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.sconto}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "€ ${Utils.formatStringDecimal(storico.importo, 2)}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${storico.iva}",
          fontWeight: 600,
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