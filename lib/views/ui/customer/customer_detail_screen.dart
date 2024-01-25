import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/customer_detail_controller.dart';
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
import 'package:foody/model/order_detail.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key});
  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late CustomerDetailController controller;
  late dynamic codCliente;

  @override
  void initState() {
    codCliente = Get.arguments;
    codCliente ??= codClienteSelezionato;
    controller =
        Get.put(CustomerDetailController(codCliente: codCliente ?? ""));
    controller.getData(codCliente ?? "");
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
                      "Dettaglio Cliente",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Admin'),
                        MyBreadcrumbItem(
                            name: 'Dettaglio Cliente', active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: MyFlex(children: [
                  MyFlexItem(
                      sizes: 'lg-3 md-6',
                      child: MyFlex(contentPadding: false, children: [
                        MyFlexItem(
                            child: MyContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MyContainer.rounded(
                                    paddingAll: 0,
                                    height: 60,
                                    width: 60,
                                    child: Icon(
                                      LucideIcons.userCircle2,
                                      size: 50,
                                      color: contentTheme.primary,
                                    ), /*Image.asset(
                                      Images.avatars[0],
                                      fit: BoxFit.cover,
                                    )*/
                                  ),
                                  MySpacing.width(12),
                                  Expanded(
                                    child: MyText.bodyLarge(
                                        controller.dettaglio?.ragioneSociale ??
                                            "-",
                                        fontWeight: 600,
                                        maxLines: 2),
                                  ),
                                ],
                              ),
                              Divider(height: 40),
                              buildProfileDetail(
                                  'E-mail', controller.dettaglio?.email ?? "-"),
                              MySpacing.height(20),
                              buildProfileDetail('Telefono',
                                  controller.dettaglio?.telefono ?? "-"),
                              MySpacing.height(20),
                              buildProfileDetail('Codice Fiscale',
                                  controller.dettaglio?.codiceFiscale ?? "-"),
                              MySpacing.height(20),
                              buildProfileDetail('Partita Iva',
                                  controller.dettaglio?.partitaIva ?? "-"),
                              MySpacing.height(20),
                              buildProfileDetail('Località',
                                  controller.dettaglio?.localita ?? "-"),
                              MySpacing.height(20),
                              buildProfileDetail('Provincia',
                                  controller.dettaglio?.provincia ?? "-"),
                              MySpacing.height(20),
                              buildProfileDetail('Sito internet',
                                  controller.dettaglio?.sitoInternet ?? "-"),
                            ],
                          ),
                        )),
                      ])),
                  MyFlexItem(
                    sizes: 'lg-9 md-6',
                    child: MyFlex(
                      contentPadding: false,
                      children: [
                        MyFlexItem(
                          sizes: 'lg-4',
                          child: buildProfileOverView(
                              contentTheme.primary,
                              LucideIcons.star,
                              "Total Point",
                              "350",
                              "Point Used: 150",
                              "Outstanding: 200"),
                        ),
                        MyFlexItem(
                          sizes: 'lg-4',
                          child: buildProfileOverView(
                              contentTheme.success,
                              LucideIcons.checkCircle2,
                              "Ordini Totali",
                              controller.dettaglio?.valoreOrdini ?? "-",
                              "Data Ultimo Documento: ${controller.dettaglio?.dataUltimaConsegna ?? "-"}",
                              "Avg Order Value: 200"),
                        ),
                        MyFlexItem(
                            sizes: 'lg-4',
                            child: MyContainer(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      MyContainer.rounded(
                                        paddingAll: 8,
                                        color: contentTheme.danger,
                                        child: Icon(LucideIcons.eye,
                                            size: 20,
                                            color: contentTheme.onPrimary),
                                      ),
                                      MySpacing.width(12),
                                      MyText.bodyMedium('Total Visit',
                                          fontWeight: 600),
                                      Spacer(),
                                      MyText.bodyLarge('180', fontWeight: 600),
                                    ],
                                  ),
                                  MySpacing.height(8),
                                  Divider(),
                                  MySpacing.height(20),
                                  MyText.bodyMedium("Last Visit: 24 Aug 2022",
                                      fontWeight: 600, xMuted: true),
                                ],
                              ),
                            )),
                        MyFlexItem(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (controller.data != null)
                                    SizedBox(
                                      width: double.infinity,
                                      child: PaginatedDataTable(
                                          header: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText.bodyLarge(
                                                        "Storico",
                                                        fontWeight: 600,
                                                      ),
                                                    ]),
                                              ],
                                            ),
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
                                              'Name',
                                            )),
                                            DataColumn(
                                                label: MyText.labelLarge(
                                              'Order No',
                                            )),
                                            DataColumn(
                                                label: MyText.labelLarge(
                                              'Transaction',
                                            )),
                                            DataColumn(
                                                label: MyText.labelLarge(
                                              'Delivery Status',
                                            )),
                                            DataColumn(
                                                label: MyText.labelLarge(
                                              'Time',
                                            )),
                                          ],
                                          source: controller.data!),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildProfileDetail(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.bodyMedium(title, fontWeight: 600),
        MyText.bodyMedium(subTitle, fontWeight: 600, xMuted: true),
      ],
    );
  }

  Widget buildProfileOverView(Color color, IconData icon, String title,
      String subTitle, String text1, String text2) {
    return MyContainer(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: color,
                child: Icon(icon, size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              MyText.bodyMedium(title, fontWeight: 600),
              Spacer(),
              MyText.bodyLarge(subTitle, fontWeight: 600),
            ],
          ),
          Divider(),
          MyText.bodyMedium(text1, fontWeight: 600, xMuted: true),
          MyText.bodyMedium(text2, fontWeight: 600, xMuted: true),
        ],
      ),
    );
  }
}

class MyDataDetailOrder extends DataTableSource with UIMixin {
  List<OrderDetail> orderList = [];

  MyDataDetailOrder(this.orderList);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    OrderDetail order = orderList[index];

    return DataRow(
      cells: [
        DataCell(MyText.bodyMedium(
          order.name,
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "# ${order.orderNo}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          order.transaction,
          fontWeight: 600,
        )),
        DataCell(MyContainer(
          padding: MySpacing.xy(12, 4),
          color: order.deliveryStatus == "On The Way"
              ? contentTheme.primary.withAlpha(36)
              : order.deliveryStatus == "Delivered"
                  ? contentTheme.success.withAlpha(36)
                  : order.deliveryStatus == "Pending"
                      ? contentTheme.danger.withAlpha(36)
                      : null,
          child: MyText.bodyMedium(
            order.deliveryStatus,
            color: order.deliveryStatus == "On The Way"
                ? contentTheme.primary
                : order.deliveryStatus == "Delivered"
                    ? contentTheme.success
                    : order.deliveryStatus == "Pending"
                        ? contentTheme.danger
                        : null,
            fontWeight: 600,
          ),
        )),
        DataCell(MyText.bodyMedium(
          Utils.getTimeStringFromDateTime(order.time),
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
