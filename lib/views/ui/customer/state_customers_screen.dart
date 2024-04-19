import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/state_customers_controller.dart';
import 'package:foody/helpers/theme/app_themes.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_responsiv.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomerStateScreen extends StatefulWidget {
  const CustomerStateScreen({super.key});

  @override
  State<CustomerStateScreen> createState() => _CustomerStateScreenState();
}

class _CustomerStateScreenState extends State<CustomerStateScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late CustomerStateController controller;
  @override
  void initState() {
    controller = Get.put(CustomerStateController(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MyResponsive(builder: (BuildContext context, _, screenMT) {
        return GetBuilder(
          init: controller,
          builder: (controller) {
            return /*screenMT.isMobile ? mobile() : */ desktop();
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
                "Stato Clienti",
                fontSize: 18,
                fontWeight: 600,
              ),
              MyContainer(
                onTap: () {
                  controller.salva();
                },
                paddingAll: 8,
                color: contentTheme.primary,
                child: Row(
                  children: [
                    controller.loading
                        ? SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              strokeWidth: 1.2,
                            ),
                          )
                        : Container(),
                    if (controller.loading) MySpacing.width(16),
                    if (!controller.loading)
                      Icon(
                        LucideIcons.saveAll,
                        color: contentTheme.onPrimary,
                      ),
                    if (!controller.loading) MySpacing.width(16),
                    MyText.bodyMedium(
                      'Salva',
                      color: contentTheme.onPrimary,
                    ),
                  ],
                ),
              )
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
                    !controller.loadingTable
                        ? SizedBox(
                            width: double.infinity,
                            child: controller.data!.rowCount == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: MyText.titleMedium(
                                        "Non ci sono clienti da gestire"),
                                  )
                                : PaginatedDataTable(
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
                                                controller.filterByName(value);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    showEmptyRows: false,
                                    source: controller.data!,
                                    columns: [
                                      /*DataColumn(
                                    onSort: (columnIndex, ascending) =>
                                        controller.orderByCod(),
                                    label: ordinamento(
                                        "Codice", controller.codice)),*/
                                      DataColumn(
                                          onSort: (columnIndex, ascending) =>
                                              controller.orderByRagSoc(),
                                          label: ordinamento("Ragione Sociale",
                                              controller.ragSoc)),
                                      DataColumn(
                                          onSort: (columnIndex, ascending) =>
                                              controller
                                                  .orderByUltimaConsegna(),
                                          label: ordinamento("Data Stato",
                                              controller.ultCons)),
                                      DataColumn(
                                          onSort: (columnIndex, ascending) =>
                                              controller
                                                  .orderByUltimaConsegna(),
                                          label: ordinamento("Nota", null)),
                                      DataColumn(
                                        numeric: true,
                                        label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MyText.bodyMedium('Parcheggiato /',
                                                fontWeight: 600),
                                            MySpacing.width(12),
                                            MyText.bodyMedium('Riprovare /',
                                                fontWeight: 600),
                                            MySpacing.width(8),
                                            MyText.bodyMedium(
                                                'Chiuso per ferie',
                                                fontWeight: 600),
                                          ],
                                        ),
                                      ),
                                      /*  DataColumn(
                                    numeric: true,
                                    label: MyText.bodyMedium('Riprovare',
                                        fontWeight: 600)),
                                DataColumn(
                                    numeric: true,
                                    label: MyText.bodyMedium('Chiuso per ferie',
                                        fontWeight: 600)),*/
                                    ],
                                    columnSpacing: 10,
                                    horizontalMargin: 20,
                                    rowsPerPage: /*controller.data!.rowCount > 20
                                  ? 20
                                  : controller.data!.rowCount == 0
                                      ? 1
                                      :*/
                                        controller.data!.rowCount,
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
                                StatoCliente data =
                                    controller.filterCustomers[index];
                                return Column(
                                  children: [
                                    MyContainer(
                                        /*onTap: () => controller
                                            .goToDetail(data.codice ?? ""),*/
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
                                                  data.pcdes ?? ""),
                                            ),
                                            Flexible(
                                              child: MyText.bodySmall(
                                                  // fontWeight: 600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "${data.pccod}"),
                                            ),
                                            Flexible(
                                              child: MyText.bodySmall(
                                                  // fontWeight: 600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "Ultima consegna: ${Utils.getFormattedDate(data.data ?? "")}"),
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

class MyDataState extends DataTableSource with UIMixin {
  List<StatoCliente> orderList = [];
  CustomerStateController controller;

  MyDataState(this.orderList, this.controller);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    StatoCliente customer = orderList[index];

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (customer.gestito == false) {
          return Colors.red.shade400 /*contentTheme.dangerLight*/;
        }
        return null;
      }),
      cells: [
        DataCell(MyText.bodySmall(
          customer.pcdes ?? "",
          color: customer.gestito == null
              ? null
              : customer.gestito == false
                  ? contentTheme.onDanger
                  : null,
        )),
        DataCell(
          MyText.bodySmall(
            Utils.getFormattedDate(customer.data ?? ""),
          ),
        ),
        DataCell(
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: TextField(
                maxLength: 100,
                controller: customer.controller,
                decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    contentPadding: MySpacing.xy(12, 4)),
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                  value: customer.parcheggiare,
                  onChanged: (value) {
                    controller.onChangeStateP(index, value!);
                  }
                  /*customer.parcheggiare == true &&
                        customer.editable == false
                    ? null
                    : (customer.riprovare == true || customer.ferie == true) &&
                            customer.editable == false
                        ? null
                        : (value) {
                            controller.onChangeStateP(index, value!);
                          },*/
                  ),
              MySpacing.width(80),
              Checkbox(
                value: customer.riprovare,
                onChanged: (customer.parcheggiare == true &&
                        customer.editable == false)
                    ? null
                    : customer.editable == false
                        ? null
                        : (value) => controller.onChangeStateR(index, value!),

                /*  customer.parcheggiare == true && customer.editable == false
                        ? null
                        : (value) => controller.onChangeStateR(index, value!),*/
              ),
              MySpacing.width(80),
              Checkbox(
                value: customer.ferie,
                onChanged: (customer.parcheggiare == true &&
                        customer.editable == false)
                    ? null
                    : customer.editable == false
                        ? null
                        : (value) => controller.onChangeStateC(index, value!),
                /* customer.parcheggiare == true && customer.editable == false
                        ? null
                        : (value) => controller.onChangeStateC(index, value!),*/
              ),
              MySpacing.width(40),
            ],
          ),
        ),
      ],
    );
  }
}
