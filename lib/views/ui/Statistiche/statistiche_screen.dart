import 'package:flutter/material.dart';
import 'package:foody/controller/ui/Statistiche/statistiche_controller.dart';
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
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/agente.dart';
import 'package:foody/model/statistiche.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StatisticheListScreen extends StatefulWidget {
  const StatisticheListScreen({super.key});

  @override
  State<StatisticheListScreen> createState() => _StatisticheListScreenState();
}

class _StatisticheListScreenState extends State<StatisticheListScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late StatisticheController controller;

  @override
  void initState() {
    controller = Get.put(StatisticheController());
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText.titleMedium(
                      "Statistiche Vendite",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(
                          name: 'Statistiche Vendite',
                          active: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(12),
              if (screenMT.isMobile || screenMT.isTablet)
                Padding(
                  padding: MySpacing.x(flexSpacing / 2),
                  child: filtriMobile(),
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
                        //if (controller.statistiche.isNotEmpty)
                        !controller.isLoading
                            ? SizedBox(
                                width: double.infinity,
                                child: PaginatedDataTable(
                                  header: screenMT.isMobile || screenMT.isTablet
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, right: 10),
                                          child: SizedBox(
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
                                              ),
                                              onChanged: (value) {
                                                controller.filterByName(value);
                                              },
                                            ),
                                          ),
                                        )
                                      : filtri(),
                                  sortAscending: true,
                                  onSelectAll: (_) => {},
                                  dataRowMaxHeight: 52,
                                  //columnSpacing: 170,
                                  showFirstLastButtons: true,
                                  showCheckboxColumn: true,
                                  columns: [
                                    DataColumn(
                                        onSort: (columnIndex, ascending) =>
                                            controller.orderByCategoria(),
                                        label: ordinamento(
                                            "Categoria", controller.categoria)),
                                    DataColumn(
                                        onSort: (columnIndex, ascending) =>
                                            controller.orderByArticolo(),
                                        label: ordinamento(
                                            "Articolo", controller.articolo)),
                                    if (controller.isChecked)
                                      DataColumn(
                                          onSort: (columnIndex, ascending) =>
                                              controller.orderByCliente(),
                                          label: ordinamento(
                                              "Cliente", controller.cliente)),
                                    DataColumn(
                                        onSort: (columnIndex, ascending) =>
                                            controller.orderByQta(),
                                        numeric: true,
                                        label: ordinamento(
                                            "Q.ta", controller.qta)),
                                    DataColumn(
                                        numeric: true,
                                        onSort: (columnIndex, ascending) =>
                                            controller.orderByValore(),
                                        label: ordinamento(
                                            "Valore", controller.valore)),
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

  Widget filtri() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
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
                    prefixIcon: Icon(LucideIcons.search, size: 20),
                    hintText: 'Cerca',
                    contentPadding: MySpacing.xy(12, 8)),
                onChanged: (value) {
                  controller.filterByName(value);
                },
              ),
            ),
          ),
        ),
        MySpacing.width(12),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              width: 150,
              child: TextField(
                  controller: controller.dateControllerDa,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      prefixIcon: Icon(LucideIcons.calendar, size: 20),
                      hintText: 'Da',
                      contentPadding: MySpacing.xy(12, 8)),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: Utils.stringToData(
                            controller.dateControllerDa.text),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    controller.dateControllerDa.text =
                        Utils.getDateTimeStringFromDateTime(
                            pickedDate ?? DateTime.now(),
                            showTime: false);
                    controller.getStatisticheCliente();
                  }),
            ),
          ),
        ),
        MySpacing.width(12),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              width: 150,
              child: TextField(
                  controller: controller.dateControllerA,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      prefixIcon: Icon(LucideIcons.calendar, size: 20),
                      hintText: 'A',
                      contentPadding: MySpacing.xy(12, 8)),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: Utils.stringToData(
                            controller.dateControllerA.text), //get today's date
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));
                    controller.dateControllerA.text =
                        Utils.getDateTimeStringFromDateTime(
                            pickedDate ?? DateTime.now(),
                            showTime: false);
                    controller.getStatisticheCliente();
                  }),
            ),
          ),
        ),
        MySpacing.width(12),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              //width: 150,
              child: buildDropDownField<Agente>(
                  controller.agenti
                      .map(
                        (societa) => DropdownMenuItem<Agente>(
                          value: societa,
                          child: MyText.labelMedium(
                            societa.pcdes ?? "",
                          ),
                        ),
                      )
                      .toList(), (value) {
                controller.agenteSelezionato = value;
                controller.getStatisticheCliente();
              }, "Agenti", controller.agenteSelezionato),
            ),
          ),
        ),
        MySpacing.width(12),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              width: 150,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: MyText.bodyMedium(
                  "Dett. clienti",
                  fontWeight: 600,
                ),
                value: controller.isChecked,
                onChanged: (value) => controller.onChangeCheckBox(value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget filtriMobile() {
    return Card(
      //paddingAll: 0,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            LucideIcons.listFilter,
            color: contentTheme.primary,
          ),
          title: MyText.titleMedium(
            "Filtri",
            fontWeight: 600,
          ),
          childrenPadding: MySpacing.x(12),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyFlex(spacing: 0, children: [
              MyFlexItem(
                sizes: "xs-6 sm-6 md-6 lg-6",
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: TextField(
                      controller: controller.dateControllerDa,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          prefixIcon: Icon(LucideIcons.calendar, size: 20),
                          hintText: 'Da',
                          contentPadding: MySpacing.xy(12, 8)),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utils.stringToData(
                                controller.dateControllerDa.text),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        controller.dateControllerDa.text =
                            Utils.getDateTimeStringFromDateTime(
                                pickedDate ?? DateTime.now(),
                                showTime: false);
                        controller.getStatisticheCliente();
                      }),
                ),
              ),
              MyFlexItem(
                sizes: "xs-6 sm-6 md-6 lg-6",
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: TextField(
                      controller: controller.dateControllerA,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          prefixIcon: Icon(LucideIcons.calendar, size: 20),
                          hintText: 'A',
                          contentPadding: MySpacing.xy(12, 8)),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utils.stringToData(controller
                                .dateControllerA.text), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));
                        controller.dateControllerA.text =
                            Utils.getDateTimeStringFromDateTime(
                                pickedDate ?? DateTime.now(),
                                showTime: false);
                        controller.getStatisticheCliente();
                      }),
                ),
              )
            ]),
            MySpacing.height(12),
            SizedBox(
              //width: 150,
              child: buildDropDownField<Agente>(
                  controller.agenti
                      .map(
                        (societa) => DropdownMenuItem<Agente>(
                          value: societa,
                          child: MyText.labelMedium(
                            societa.pcdes ?? "",
                          ),
                        ),
                      )
                      .toList(), (value) {
                controller.agenteSelezionato = value;
                controller.getStatisticheCliente();
              }, "Agenti", controller.agenteSelezionato),
            ),
            MySpacing.height(8),
            SizedBox(
              width: 150,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: MyText.bodyMedium(
                  "Dett. clienti",
                  fontWeight: 600,
                ),
                value: controller.isChecked,
                onChanged: (value) => controller.onChangeCheckBox(value),
              ),
            ),
            MySpacing.height(8),
          ],
        ),
      ),
    );
  }

  buildDropDownField<T>(List<DropdownMenuItem<T>> items,
      Function(T? value) onChanged, String title, T? valoreSelezionato) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* MyText.labelMedium(
          title,
        ),*/
        // MySpacing.height(4),
        DropdownButtonFormField<T>(
          dropdownColor: contentTheme.background,
          isDense: true,
          items: items,
          icon: Icon(
            LucideIcons.chevronDown,
            size: 20,
          ),
          decoration: InputDecoration(
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(12),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          value: valoreSelezionato,
          onChanged: (value) {
            onChanged(value);
          },
        )
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

class MyDataDetailStatistiche extends DataTableSource with UIMixin {
  List<Statistiche> listaStatistiche = [];
  StatisticheController controller;

  MyDataDetailStatistiche(this.listaStatistiche, this.controller);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listaStatistiche.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    Statistiche scadenza = listaStatistiche[index];

    return DataRow(
      cells: [
        DataCell(MyText.bodySmall(
          "${scadenza.categoria}",
        )),
        DataCell(MyText.bodySmall(
          "${scadenza.articolo}",
        )),
        if (controller.isChecked)
          DataCell(MyText.bodySmall(
            "${scadenza.cliente}",
          )),
        DataCell(MyText.bodySmall(
          Utils.formatStringDecimal(scadenza.quantita, 2),
        )),
        DataCell(MyText.bodySmall(
          "€ ${Utils.formatStringDecimal(scadenza.valore, 2)}",
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
