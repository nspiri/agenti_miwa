import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/storico_customer_controller.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
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
    var codCli = (cliente?.codCliFattA != ""
            ? cliente?.codCliFattA
            : cliente?.codiceCliente) ??
        "";
    controller = Get.put(EditCustomerController(codCliente: codCli));
    controller.getData(codCli);
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
                padding: MySpacing.x(flexSpacing / 2),
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
                        MyBreadcrumbItem(name: 'Storico', active: true),
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
                    //if (controller.data != null)
                    !controller.isLoading
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
                                ],
                              ),
                              source: controller.data!,
                              columns: [
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByData(),
                                    label: ordinamento(
                                        "Data", controller.dataAsc)),
                                /* DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByDoc(),
                                      label: MyText.bodyMedium('Doc.',
                                          fontWeight: 600)),*/
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByDoc(),
                                    label: ordinamento(
                                        "Documento", controller.doc)),
                                /* DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByCodArt(),
                                      label: MyText.bodyMedium('Codice Art.',
                                          fontWeight: 600)),*/
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByDesc(),
                                    label: ordinamento(
                                        "Descrizione", controller.desc)),
                                /* DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByUm(),
                                      label: MyText.bodyMedium('Um',
                                          fontWeight: 600)),*/
                                DataColumn(
                                    label: MyText.bodyMedium('Q.ta',
                                        fontWeight: 600)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByPrezzo(),
                                    label: ordinamento(
                                        "Prezzo", controller.prezzo)),
                                DataColumn(
                                    label: MyText.bodyMedium('Sconti',
                                        fontWeight: 600)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByImporto(),
                                    label: ordinamento(
                                        "Importo", controller.importo)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByIva(),
                                    label: MyText.bodyMedium('Iva',
                                        fontWeight: 600)),
                              ],
                              showEmptyRows: false,
                              columnSpacing: 10,
                              horizontalMargin: 20,
                              rowsPerPage: controller.data!.rowCount > 20
                                  ? 20
                                  : controller.data!.rowCount == 0
                                      ? 1
                                      : controller.data!.rowCount,
                              dataRowMaxHeight: 48,
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
        DataCell(MyText.bodySmall(
          Utils.getFormattedDate(storico.data!),
        )),
        /* DataCell(MyText.bodyMedium(
          "${storico.documento}",
          fontWeight: 600,
        )),*/
        DataCell(MyText.bodySmall(
          "${storico.documento} ${storico.serie}/${storico.numero}",
        )),
        /* DataCell(MyText.bodySmall(
          "${storico.codArt}",
        )),*/
        DataCell(MyText.bodySmall(
          "${storico.desc}",
        )),
        /* DataCell(MyText.bodyMedium(
          "${storico.um}",
          fontWeight: 600,
        )),*/
        DataCell(MyText.bodySmall(
          "${storico.colli}*${storico.qta} ${storico.um}",
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(storico.prezzo, 2)}",
        )),
        DataCell(MyText.bodySmall(
          "${storico.sconto}",
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(storico.importo, 2)}",
        )),
        DataCell(MyText.bodySmall(
          "${storico.iva}",
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
