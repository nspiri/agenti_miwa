// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/articolo.dart';
import 'package:foody/model/storico.dart';
import 'package:foody/views/ui/modal_list_storico_art_controller.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ModalListaStoricoArticolo extends StatefulWidget {
  final String codCliente;
  final Articolo articolo;
  const ModalListaStoricoArticolo(
      {super.key, required this.codCliente, required this.articolo});

  @override
  State<ModalListaStoricoArticolo> createState() =>
      _ModalListaStoricoArticoloState();
}

class _ModalListaStoricoArticoloState extends State<ModalListaStoricoArticolo>
    with SingleTickerProviderStateMixin, UIMixin {
  late ModalListaStoricoArtController controller;

  @override
  void initState() {
    controller = Get.put(ModalListaStoricoArtController(
        context: context,
        codCliente: widget.codCliente,
        articolo: widget.articolo));
    controller.storicoArticolo(widget.codCliente, widget.articolo.codArt ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder(
          init: controller,
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: MySpacing.xy(flexSpacing, flexSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText.titleMedium(
                          "${widget.articolo.descrizione}",
                          fontSize: 18,
                          fontWeight: 600,
                        ),
                        Row(
                          children: [
                            MyContainer(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              paddingAll: 8,
                              color: contentTheme.primary,
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.doorClosed,
                                    size: 20,
                                    color: contentTheme.onPrimary,
                                  ),
                                  MySpacing.width(8),
                                  MyText.bodyMedium(
                                    "Chiudi",
                                    color: contentTheme.onPrimary,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
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
                                        dataRowMaxHeight: 48,
                                        columnSpacing: 10,
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
                                                      border:
                                                          OutlineInputBorder(
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
                                                          MySpacing.xy(12, 4)),
                                                  onChanged: (value) {
                                                    /*controller
                                                        .filterByName(value);*/
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        showCheckboxColumn: false,
                                        columns: [
                                          DataColumn(
                                              onSort:
                                                  (columnIndex, ascending) =>
                                                      controller.orderByData(),
                                              label: MyText.bodyMedium('Data',
                                                  fontWeight: 600)),
                                          /* DataColumn(
                                              /*onSort: (columnIndex, ascending) =>
                                          controller.orderByDoc(),*/
                                              label: MyText.bodyMedium('Doc.',
                                                  fontWeight: 600)),*/
                                          DataColumn(
                                              label: MyText.bodyMedium('Numero',
                                                  fontWeight: 600)),
                                          /* DataColumn(
                                              /*onSort: (columnIndex, ascending) =>
                                          controller.orderByUm(),*/
                                              label: MyText.bodyMedium('Um',
                                                  fontWeight: 600)),*/
                                          DataColumn(
                                              label: MyText.bodyMedium('Q.ta',
                                                  fontWeight: 600)),
                                          DataColumn(
                                              /*onSort: (columnIndex, ascending) =>
                                          controller.orderByPrezzo(),*/
                                              label: MyText.bodyMedium('Prezzo',
                                                  fontWeight: 600)),
                                          DataColumn(
                                              label: MyText.bodyMedium('Sconti',
                                                  fontWeight: 600)),
                                          DataColumn(
                                              /*onSort: (columnIndex, ascending) =>
                                          controller.orderByImporto(),*/
                                              label: MyText.bodyMedium(
                                                  'Importo',
                                                  fontWeight: 600)),
                                          DataColumn(
                                              /*onSort: (columnIndex, ascending) =>
                                          controller.orderByIva(),*/
                                              label: MyText.bodyMedium('Iva',
                                                  fontWeight: 600)),
                                        ],
                                        source: controller.data!,
                                        horizontalMargin: 20,
                                        rowsPerPage:
                                            controller.data!.rowCount > 20
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyDataListStoricoArtModal extends DataTableSource with UIMixin {
  List<Storico> listaStorico = [];

  MyDataListStoricoArtModal(this.listaStorico);

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
        /* DataCell(MyText.bodyMedium(
          "${storico.documento}",
          fontWeight: 600,
        )),*/
        DataCell(MyText.bodyMedium(
          "${storico.documento} ${storico.serie}/${storico.numero}",
          fontWeight: 600,
        )),
        /*DataCell(MyText.bodyMedium(
          "${storico.um}",
          fontWeight: 600,
        )),*/
        DataCell(MyText.bodyMedium(
          "${storico.colli}*${storico.qta} ${storico.um}",
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

  /* void gotoEdit(String clientId) {
    codClienteSelezionato = clientId;
    Get.toNamed('/admin/customers/edit', arguments: clientId);
  }

  void gotoDetail(String clientId) {
    codClienteSelezionato = clientId;
    Get.toNamed('/admin/customers/detail', arguments: clientId);
  }*/
}
