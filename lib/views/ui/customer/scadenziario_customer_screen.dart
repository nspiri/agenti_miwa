import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mexalorder/controller/ui/customer/scadenziario_controller.dart';
import 'package:mexalorder/helpers/utils/global.dart';
import 'package:mexalorder/helpers/utils/ui_mixins.dart';
import 'package:mexalorder/helpers/utils/utils.dart';
import 'package:mexalorder/helpers/widgets/my_breadcrumb.dart';
import 'package:mexalorder/helpers/widgets/my_breadcrumb_item.dart';
import 'package:mexalorder/helpers/widgets/my_container.dart';
import 'package:mexalorder/helpers/widgets/my_responsiv.dart';
import 'package:mexalorder/helpers/widgets/my_spacing.dart';
import 'package:mexalorder/helpers/widgets/my_text.dart';
import 'package:mexalorder/helpers/widgets/responsive.dart';
import 'package:mexalorder/model/scadenziario_cliente.dart';
import 'package:mexalorder/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ScadenziarioScreen extends StatefulWidget {
  const ScadenziarioScreen({super.key});

  @override
  State<ScadenziarioScreen> createState() => _ScadenziarioScreenState();
}

class _ScadenziarioScreenState extends State<ScadenziarioScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late ScadenziarioController controller;

  @override
  void initState() {
    controller = Get.put(ScadenziarioController());
    controller.isLoading = true;
    // if (controller.codiceCliente != clienteSelezionato?.codiceCliente) {
    controller.getScadenziarioCliente();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        child: MyResponsive(builder: (BuildContext context, _, screenMT) {
      return GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: MyText.titleMedium(
                        "Scad: ${clienteSelezionato?.ragioneSociale}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: 600,
                      ),
                    ),
                    MySpacing.width(8),
                    if (screenMT.isMobile == true)
                      SizedBox(
                          child: MyText.bodyLarge(
                        "Totale: € ${controller.totale}",
                        fontWeight: 600,
                      )),
                    if (screenMT.isMobile == false)
                      MyBreadcrumb(
                        children: [
                          MyBreadcrumbItem(
                            name: 'Scadenzario',
                            active: true,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (screenMT.isMobile == true) MySpacing.height(flexSpacing / 2),
              if (screenMT.isMobile == true)
                Padding(
                  padding: MySpacing.x(flexSpacing / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: MyContainer(
                          onTap: () {
                            controller.getScadenziarioCliente();
                          },
                          paddingAll: 8,
                          color: controller.tutti
                              ? contentTheme.success
                              : contentTheme.primary,
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.listPlus,
                                size: 20,
                                color: contentTheme.onPrimary,
                              ),
                              MySpacing.width(8),
                              MyText.bodyMedium(
                                "Tutte le Scadenze",
                                color: contentTheme.onPrimary,
                              )
                            ],
                          ),
                        ),
                      ),
                      MySpacing.width(8),
                      Expanded(
                        child: MyContainer(
                          onTap: () {
                            controller.scadute();
                          },
                          paddingAll: 8,
                          color: controller.scaduti
                              ? contentTheme.success
                              : contentTheme.primary,
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.euro,
                                size: 20,
                                color: contentTheme.onPrimary,
                              ),
                              MySpacing.width(8),
                              MyText.bodyMedium(
                                "Scadute",
                                color: contentTheme.onPrimary,
                              )
                            ],
                          ),
                        ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //if (controller.scadenziario.isNotEmpty)
                        !controller.isLoading
                            ? SizedBox(
                                width: double.infinity,
                                child: PaginatedDataTable(
                                  header: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: MySpacing.top(24),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
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
                                            MySpacing.width(8),
                                            if (screenMT.isMobile == true)
                                              Visibility(
                                                visible: !controller.isOffline,
                                                child: IconButton(
                                                    onPressed: () {
                                                      for (var element in controller
                                                          .filterScadenziario) {
                                                        if (element.selected) {
                                                          controller
                                                              .generaPdf();
                                                          break;
                                                        }
                                                      }
                                                    },
                                                    icon: Icon(
                                                      LucideIcons.fileDown,
                                                      color:
                                                          contentTheme.primary,
                                                    )),
                                              )
                                          ],
                                        ),
                                      ),
                                      if (screenMT.isMobile == false)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MyContainer(
                                              onTap: () {
                                                controller
                                                    .getScadenziarioCliente();
                                              },
                                              paddingAll: 8,
                                              color: controller.tutti
                                                  ? contentTheme.success
                                                  : contentTheme.primary,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    LucideIcons.listPlus,
                                                    size: 20,
                                                    color:
                                                        contentTheme.onPrimary,
                                                  ),
                                                  MySpacing.width(8),
                                                  MyText.bodyMedium(
                                                    "Tutte le Scadenze",
                                                    color:
                                                        contentTheme.onPrimary,
                                                  )
                                                ],
                                              ),
                                            ),
                                            MySpacing.width(8),
                                            MyContainer(
                                              onTap: () {
                                                controller.scadute();
                                              },
                                              paddingAll: 8,
                                              color: controller.scaduti
                                                  ? contentTheme.success
                                                  : contentTheme.primary,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    LucideIcons.euro,
                                                    size: 20,
                                                    color:
                                                        contentTheme.onPrimary,
                                                  ),
                                                  MySpacing.width(8),
                                                  MyText.bodyMedium(
                                                    "Scadute",
                                                    color:
                                                        contentTheme.onPrimary,
                                                  )
                                                ],
                                              ),
                                            ),
                                            MySpacing.width(8),
                                            Padding(
                                              padding: MySpacing.top(0),
                                              child: SizedBox(
                                                  child: MyText.bodyLarge(
                                                "Totale: € ${controller.totale}",
                                                fontWeight: 600,
                                              )),
                                            ),
                                            MySpacing.width(8),
                                            Visibility(
                                              visible: !controller.isOffline,
                                              child: IconButton(
                                                  onPressed: () {
                                                    for (var element in controller
                                                        .filterScadenziario) {
                                                      if (element.selected) {
                                                        controller.generaPdf();
                                                        break;
                                                      }
                                                    }
                                                  },
                                                  icon: Icon(
                                                    LucideIcons.fileDown,
                                                    color: contentTheme.primary,
                                                  )),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                  sortAscending: true,
                                  onSelectAll: (val) {
                                    controller.all = !controller.all;
                                    for (var element
                                        in controller.filterScadenziario) {
                                      element.selected = controller.all;
                                    }
                                    controller.changeValue();
                                  },
                                  dataRowMaxHeight: 52,
                                  //columnSpacing: 170,
                                  showFirstLastButtons: true,
                                  showCheckboxColumn: true,
                                  columns: [
                                    /*DataColumn(
                                    label: MyText.labelLarge(
                                  'Cod. Cliente',
                                )),
                                DataColumn(
                                    label: MyText.labelLarge(
                                  'Rag. Sociale',
                                )),
                                DataColumn(
                                    label: MyText.labelLarge(
                                  'Doc.',
                                )),*/
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
                                        label: MyText.labelLarge(
                                            'Tipo Pagamento',
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
                                  showEmptyRows: false,
                                  source: controller.data!,
                                  rowsPerPage: controller.data!.rowCount > 20
                                      ? 20
                                      : controller.data!.rowCount == 0
                                          ? 1
                                          : controller.data!.rowCount,
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
      );
    }));
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

class MyDataDetailScadenziarioCliente extends DataTableSource with UIMixin {
  List<ScadenziarioCliente> listaScadenziario = [];
  ScadenziarioController controller;
  MyDataDetailScadenziarioCliente(this.listaScadenziario, this.controller);

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
        /*  DataCell(MyText.bodyMedium(
          "${scadenza.codCliente}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${scadenza.ragioneSociale}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
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
      selected: controller.filterScadenziario[index].selected,
      onSelectChanged: (value) {
        controller.filterScadenziario[index].selected = value ?? false;
        controller.changeValue();
      },
    );
  }

  void gotoEdit(String clientId) {
    Get.toNamed('/admin/customers/edit', arguments: clientId);
  }

  void gotoDetail(String clientId) {
    Get.toNamed('/admin/customers/detail', arguments: clientId);
  }
}
