import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/customer_list_controller.dart';
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
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late CustomerListController controller;

  @override
  void initState() {
    controller = Get.put(CustomerListController());
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
                      "Lista clienti",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Admin'),
                        MyBreadcrumbItem(name: 'Lista clienti', active: true),
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
                                    MyContainer(
                                      onTap: () => controller.gotoCustomerAdd(),
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
                                            "Aggiungi nuovo cliente",
                                            color: contentTheme.onPrimary,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                /*rows: controller.customers
                                          .mapIndexed((index, data) =>
                                              row(controller.customers[index]))
                                          .toList(),*/

                                source: controller.data!,
                                columns: [
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByName(),
                                      label: MyText.bodyMedium(
                                          'Ragione Sociale',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByLocalita(),
                                      label: MyText.bodyMedium('Località',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByProvincia(),
                                      label: MyText.bodyMedium('Prov.',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByIndirizzo(),
                                      label: MyText.bodyMedium('Indirizzo',
                                          fontWeight: 600)),
                                  DataColumn(
                                      label: MyText.bodyMedium('Telefono',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByEmail(),
                                      label: MyText.bodyMedium('E-mail',
                                          fontWeight: 600)),
                                  DataColumn(
                                      label: MyText.bodyMedium('Part. Iva',
                                          fontWeight: 600)),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) =>
                                          controller.orderByUltimaConsegna(),
                                      label: MyText.bodyMedium('Ult. Cons.',
                                          fontWeight: 600)),
                                ],
                                columnSpacing: 10,
                                horizontalMargin: 20,
                                rowsPerPage: 20,
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
}

class MyData extends DataTableSource with UIMixin {
  List<CustomersList> orderList = [];

  MyData(this.orderList);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    CustomersList customer = orderList[index];

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              /*MyContainer.rounded(
              paddingAll: 0,
              height: 40,
              width: 40,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(Images.avatars[index % Images.avatars.length]),
            ),*/
              MySpacing.width(0),
              Visibility(
                visible: customer.descrizione!.length > 40,
                child: Tooltip(
                    message: customer.descrizione ?? "",
                    child: MyText.bodySmall(
                        "${customer.descrizione?.substring(0, customer.descrizione!.length > 40 ? 40 : customer.descrizione?.length) ?? ''} ${customer.descrizione!.length > 40 ? '...' : ''}")),
              ),
              Visibility(
                visible: customer.descrizione!.length <= 40,
                child: MyText.bodySmall("${customer.descrizione}"),
              ),
            ],
          ),
        ),
        DataCell(MyText.bodySmall(customer.localita ?? "")),
        DataCell(MyText.bodySmall(customer.provincia ?? "")),
        DataCell(Row(
          children: [
            /*MyContainer.rounded(
              paddingAll: 0,
              height: 40,
              width: 40,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(Images.avatars[index % Images.avatars.length]),
            ),*/
            MySpacing.width(0),
            Visibility(
              visible: customer.indirizzo!.length > 20,
              child: Tooltip(
                  message: customer.indirizzo ?? "",
                  child: MyText.bodySmall(
                      "${customer.indirizzo?.substring(0, customer.indirizzo!.length > 20 ? 20 : customer.indirizzo?.length) ?? ''} ${customer.indirizzo!.length > 20 ? '...' : ''}")),
            ),
            Visibility(
              visible: customer.indirizzo!.length <= 20,
              child: MyText.bodySmall("${customer.indirizzo}"),
            ),
          ],
        )),
        DataCell(MyText.bodySmall(customer.telefono ?? "")),
        DataCell(Row(
          children: [
            Visibility(
              visible: customer.email!.length > 20,
              child: Tooltip(
                  message: customer.email ?? "",
                  child: MyText.bodySmall(
                      "${customer.email?.substring(0, customer.email!.length > 20 ? 20 : customer.email?.length) ?? ''} ${customer.email!.length > 20 ? '...' : ''}")),
            ),
            Visibility(
              visible: customer.email!.length <= 20,
              child: MyText.bodySmall("${customer.email}"),
            ),
          ],
        )),
        DataCell(MyText.bodySmall(customer.pIva ?? "")),
        DataCell(
          MyText.bodySmall(
            Utils.getFormattedDate(customer.dataUltimaConsegna ?? ""),
          ),
        ),
      ],
      onSelectChanged: (value) {
        gotoDetail(customer.codice ?? "");
      },
    );
  }

  void gotoEdit(String clientId) {
    codClienteSelezionato = clientId;
    Get.toNamed('/admin/customers/edit', arguments: clientId);
  }

  void gotoDetail(String clientId) {
    codClienteSelezionato = clientId;
    Get.toNamed('/admin/customers/detail', arguments: clientId);
  }
}
