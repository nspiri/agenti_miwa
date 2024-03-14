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
import 'package:foody/helpers/widgets/my_responsiv.dart';
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
    controller = Get.put(CustomerListController(context: context));
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MyResponsive(builder: (BuildContext context, _, screenMT) {
        return GetBuilder(
          init: controller,
          builder: (controller) {
            return screenMT.isMobile ? mobile() : desktop();
          },
        );
      }),
    );
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
                "Clienti",
                fontSize: 18,
                fontWeight: 600,
              ),
              MyBreadcrumb(
                children: [
                  MyBreadcrumbItem(name: 'Clienti', active: true),
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
                                          "Nuovo cliente",
                                          color: contentTheme.onPrimary,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              source: controller.data!,
                              columns: [
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByName(),
                                    label: ordinamento(
                                        "Ragione Sociale", controller.ragSoc)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByLocalita(),
                                    label: ordinamento(
                                        "Località", controller.localita)),
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByProvincia(),
                                    label: ordinamento(
                                        "Provincia", controller.provincia)),
                                /* DataColumn(
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
                                                  fontWeight: 600)),*/
                                DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByUltimaConsegna(),
                                    label: ordinamento(
                                        "Ultima Consegna", controller.ultCons)),
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
          padding: MySpacing.x(flexSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText.titleMedium(
                "Clienti",
                fontSize: 18,
                fontWeight: 600,
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
                      "Nuovo cliente",
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
          child: SizedBox(
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  prefixIcon: Icon(LucideIcons.search, size: 20),
                  hintText: 'Cerca',
                  contentPadding: MySpacing.xy(12, 8)),
              onChanged: (value) {
                controller.filterByName(value);
              },
            ),
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
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.filterCustomers.length,
                              itemBuilder: (context, index) {
                                CustomersList data =
                                    controller.filterCustomers[index];
                                return Column(
                                  children: [
                                    MyContainer(
                                        onTap: () => controller
                                            .goToDetail(data.codice ?? ""),
                                        width: double.infinity,
                                        // height: 200,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: MyText.bodyMedium(
                                                  fontWeight: 600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  data.descrizione ?? ""),
                                            ),
                                            Flexible(
                                              child: MyText.bodySmall(
                                                  // fontWeight: 600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "${data.localita} (${data.provincia})"),
                                            ),
                                            Flexible(
                                              child: MyText.bodySmall(
                                                  // fontWeight: 600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "Ultima consegna: ${Utils.getFormattedDate(data.dataUltimaConsegna ?? "")}"),
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
                            ))
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
  List<CustomersList> orderList = [];
  CustomerListController controller;

  MyData(this.orderList, this.controller);

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
          MyText.bodySmall("${customer.descrizione}"),
        ),
        DataCell(MyText.bodySmall(customer.localita ?? "")),
        DataCell(MyText.bodySmall(customer.provincia ?? "")),
        /*DataCell(Row(
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
        DataCell(MyText.bodySmall(customer.pIva ?? "")),*/
        DataCell(
          MyText.bodySmall(
            Utils.getFormattedDate(customer.dataUltimaConsegna ?? ""),
          ),
        ),
      ],
      onSelectChanged: (value) {
        gotoDetail(customer.codice ?? "");
      },
      onLongPress: () {
        gotoOrder(customer.codice ?? "");
      },
    );
  }

  void gotoOrder(String clientId) {
    controller.goToOrder(clientId);
  }

  void gotoDetail(String clientId) {
    controller.goToDetail(clientId);
  }
}
