import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/add_customer_controller.dart';
import 'package:foody/helpers/theme/app_themes.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_button.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_category.dart';
import 'package:foody/model/customers_fa.dart';
import 'package:foody/model/nazionalita.dart';
import 'package:foody/model/pagamenti.dart';
import 'package:foody/model/tipo_attivita.dart';
import 'package:foody/model/tipo_soc.dart';
import 'package:foody/model/zone_clienti.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:time_range/time_range.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late AddCustomerController controller;

  @override
  void initState() {
    controller = Get.put(AddCustomerController(context: context));
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
                      "Aggiungi Cliente",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Admin'),
                        MyBreadcrumbItem(
                            name: 'Aggiungi Cliente', active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: MyContainer(
                  padding: MySpacing.xy(20, 20),
                  child: Form(
                    key: controller.basicValidator.formKey,
                    child: Column(
                      children: [
                        MyFlex(
                          children: [
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: MyFlex(children: [
                                  MyFlexItem(
                                    sizes: "md-12 sm-12",
                                    child: buildTextField(
                                        'Rag. Sociale',
                                        "Inserisci La Ragione Sociale",
                                        controller.basicValidator
                                            .getController("ragioneSociale"),
                                        controller.basicValidator
                                            .getValidation("ragioneSociale"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: MyText.bodyMedium(
                                          "Privato",
                                          fontWeight: 600,
                                        ),
                                        value: controller.isChecked,
                                        onChanged: (value) =>
                                            controller.onChangeCheckBox(value),
                                      ),
                                    ),
                                  ),
                                  MyFlexItem(
                                      sizes: "md-6 sm-12",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText.labelMedium(
                                            "Tipo società",
                                          ),
                                          MySpacing.height(8),
                                          DropDownSearchFormField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Seleziona Il Tipo Di Società",
                                                hintStyle:
                                                    MyTextStyle.bodySmall(
                                                        xMuted: true),
                                                border: outlineInputBorder,
                                                contentPadding:
                                                    MySpacing.all(16),
                                                isCollapsed: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                /*suffixIcon: InkWell(
                                                onTap: () {
                                                  _dropdownSearchFieldController
                                                      .text = "";
                                                  setState(() {});
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))*/
                                              ),
                                              controller: controller
                                                  .tipoSocTextController,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return controller
                                                  .getTipoSocieta(pattern);
                                            },
                                            suggestionsBoxDecoration:
                                                SuggestionsBoxDecoration(
                                                    color: contentTheme
                                                        .background),
                                            itemBuilder: (context,
                                                TipoSocieta suggestion) {
                                              return ListTile(
                                                title: MyText.labelMedium(
                                                  suggestion.descrizione ?? "",
                                                ),
                                              );
                                            },
                                            transitionBuilder: (context,
                                                suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected:
                                                (TipoSocieta suggestion) {
                                              controller.tipoSocTextController
                                                      .text =
                                                  suggestion.descrizione ?? "";
                                              controller
                                                      .tiposocietaSelezionata =
                                                  suggestion;
                                            },
                                            suggestionsBoxController: controller
                                                .basicValidator
                                                .getController("tipoSoc"),
                                            validator: controller.basicValidator
                                                .getValidation("tipoSoc"),
                                            displayAllSuggestionWhenTap: false,
                                          )
                                        ],
                                      )),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Cod. Fiscale',
                                        "Inserisci Il Codice Fiscale",
                                        controller.basicValidator
                                            .getController("codFisc"),
                                        controller.basicValidator
                                            .getValidation("codFisc"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Partita Iva',
                                        "Inserisci La Partita Iva",
                                        controller.basicValidator
                                            .getController("partIva"),
                                        controller.basicValidator
                                            .getValidation("partIva"),
                                        !controller.isChecked),
                                  ),
                                  MyFlexItem(
                                      sizes: "md-6 sm-12",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText.labelMedium(
                                            "Nazionalità",
                                          ),
                                          MySpacing.height(8),
                                          DropDownSearchFormField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Seleziona La Nazionalità",
                                                hintStyle:
                                                    MyTextStyle.bodySmall(
                                                        xMuted: true),
                                                border: outlineInputBorder,
                                                contentPadding:
                                                    MySpacing.all(16),
                                                isCollapsed: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                /*suffixIcon: InkWell(
                                                onTap: () {
                                                  _dropdownSearchFieldController
                                                      .text = "";
                                                  setState(() {});
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))*/
                                              ),
                                              controller: controller
                                                  .nazionalitaTextController,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return controller
                                                  .getNazionalita(pattern);
                                            },
                                            suggestionsBoxDecoration:
                                                SuggestionsBoxDecoration(
                                                    color: contentTheme
                                                        .background),
                                            itemBuilder: (context,
                                                Nazionalita suggestion) {
                                              return ListTile(
                                                title: MyText.labelMedium(
                                                  suggestion.descrizione ?? "",
                                                ),
                                              );
                                            },
                                            transitionBuilder: (context,
                                                suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected:
                                                (Nazionalita suggestion) {
                                              controller
                                                      .nazionalitaTextController
                                                      .text =
                                                  suggestion.descrizione ?? "";
                                              controller
                                                      .nazionalitaSelezionata =
                                                  suggestion;
                                            },
                                            suggestionsBoxController: controller
                                                .basicValidator
                                                .getController("nazionalita"),
                                            validator: controller.basicValidator
                                                .getValidation("nazionalita"),
                                            displayAllSuggestionWhenTap: false,
                                          )
                                        ],
                                      )),
                                  MyFlexItem(
                                      sizes: "md-6 sm-12",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText.labelMedium(
                                            "Paese",
                                          ),
                                          MySpacing.height(8),
                                          DropDownSearchFormField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              decoration: InputDecoration(
                                                hintText: "Seleziona Il Paese",
                                                hintStyle:
                                                    MyTextStyle.bodySmall(
                                                        xMuted: true),
                                                border: outlineInputBorder,
                                                contentPadding:
                                                    MySpacing.all(16),
                                                isCollapsed: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                /*suffixIcon: InkWell(
                                                onTap: () {
                                                  _dropdownSearchFieldController
                                                      .text = "";
                                                  setState(() {});
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))*/
                                              ),
                                              controller: controller
                                                  .paeseTextController,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return controller
                                                  .getPaesi(pattern);
                                            },
                                            suggestionsBoxDecoration:
                                                SuggestionsBoxDecoration(
                                                    color: contentTheme
                                                        .background),
                                            itemBuilder:
                                                (context, Paesi suggestion) {
                                              return ListTile(
                                                title: MyText.labelMedium(
                                                  suggestion.descrizione ?? "",
                                                ),
                                              );
                                            },
                                            transitionBuilder: (context,
                                                suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected:
                                                (Paesi suggestion) {
                                              controller.paeseTextController
                                                      .text =
                                                  suggestion.descrizione ?? "";
                                              controller.paeseSelezionato =
                                                  suggestion;
                                            },
                                            suggestionsBoxController: controller
                                                .basicValidator
                                                .getController("paese"),
                                            validator: controller.basicValidator
                                                .getValidation("paese"),
                                            displayAllSuggestionWhenTap: false,
                                          )
                                        ],
                                      )),
                                  MyFlexItem(
                                    sizes: "md-12 sm-12",
                                    child: buildTextField(
                                        'Indirizzo',
                                        "Inserisci L'indirizzo",
                                        controller.basicValidator
                                            .getController("indirizzo"),
                                        controller.basicValidator
                                            .getValidation("indirizzo"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-3 sm-12",
                                    child: buildTextField(
                                        'Cap',
                                        "",
                                        controller.basicValidator
                                            .getController("cap"),
                                        controller.basicValidator
                                            .getValidation("cap"),
                                        false),
                                  ),
                                  MyFlexItem(
                                      sizes: "md-7 sm-12",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText.labelMedium(
                                            "Località",
                                          ),
                                          MySpacing.height(8),
                                          DropDownSearchFormField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Seleziona La Località",
                                                hintStyle:
                                                    MyTextStyle.bodySmall(
                                                        xMuted: true),
                                                border: outlineInputBorder,
                                                contentPadding:
                                                    MySpacing.all(16),
                                                isCollapsed: true,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                /*suffixIcon: InkWell(
                                                onTap: () {
                                                  _dropdownSearchFieldController
                                                      .text = "";
                                                  setState(() {});
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))*/
                                              ),
                                              controller: controller
                                                  .comuneTextController,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return controller
                                                  .getComuni(pattern);
                                            },
                                            suggestionsBoxDecoration:
                                                SuggestionsBoxDecoration(
                                                    color: contentTheme
                                                        .background),
                                            itemBuilder:
                                                (context, Comuni suggestion) {
                                              return ListTile(
                                                title: MyText.labelMedium(
                                                  suggestion.localita ?? "",
                                                ),
                                              );
                                            },
                                            transitionBuilder: (context,
                                                suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected:
                                                (Comuni suggestion) {
                                              controller.comuneTextController
                                                      .text =
                                                  suggestion.localita ?? "";
                                              controller.comuneSelezionato =
                                                  suggestion;
                                              controller.basicValidator
                                                  .getController("cap")
                                                  ?.text = suggestion.cap ?? "";
                                              controller.basicValidator
                                                  .getController("provincia")
                                                  ?.text = suggestion
                                                      .provincia ??
                                                  "";
                                            },
                                            suggestionsBoxController: controller
                                                .basicValidator
                                                .getController("localita"),
                                            validator: controller.basicValidator
                                                .getValidation("localita"),
                                            displayAllSuggestionWhenTap: false,
                                          )
                                        ],
                                      )),
                                  MyFlexItem(
                                    sizes: "md-2 sm-12",
                                    child: buildTextField(
                                        'Prov.',
                                        "",
                                        controller.basicValidator
                                            .getController("provincia"),
                                        controller.basicValidator
                                            .getValidation("provincia"),
                                        false),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Telefono',
                                        "Inserisci Il Numero Di Telefono",
                                        controller.basicValidator
                                            .getController("telefono"),
                                        controller.basicValidator
                                            .getValidation("telefono"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Cellulare',
                                        "Inserisci Il Numero Di Cellulare",
                                        controller.basicValidator
                                            .getController("fax"),
                                        controller.basicValidator
                                            .getValidation("fax"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-12 sm-12",
                                    child: buildTextField(
                                        "Email",
                                        "Enter Email",
                                        controller.basicValidator
                                            .getController("email"),
                                        controller.basicValidator
                                            .getValidation("email"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-8 sm-12",
                                    child: buildTextField(
                                        'Pec',
                                        "Inserisci La Pec",
                                        controller.basicValidator
                                            .getController("pec"),
                                        controller.basicValidator
                                            .getValidation("pec"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-4 sm-12",
                                    child: buildTextField(
                                        'Codice SDI',
                                        "Inserisci Codice SDI",
                                        controller.basicValidator
                                            .getController("codSDI"),
                                        controller.basicValidator
                                            .getValidation("codSDI"),
                                        true),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-12 sm-12",
                                    child: buildTextField(
                                        'Internet',
                                        "Inserisci Il Sito Internet",
                                        controller.basicValidator
                                            .getController("internet"),
                                        controller.basicValidator
                                            .getValidation("internet"),
                                        true),
                                  ),
                                ])),
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: MyFlex(
                                  children: [
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText.labelMedium(
                                              "Pagamento",
                                            ),
                                            MySpacing.height(8),
                                            DropDownSearchFormField(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Seleziona Il Pagamento",
                                                  hintStyle:
                                                      MyTextStyle.bodySmall(
                                                          xMuted: true),
                                                  border: outlineInputBorder,
                                                  contentPadding:
                                                      MySpacing.all(16),
                                                  isCollapsed: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  /*suffixIcon: InkWell(
                                                onTap: () {
                                                  _dropdownSearchFieldController
                                                      .text = "";
                                                  setState(() {});
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))*/
                                                ),
                                                controller: controller
                                                    .pagamentiTextController,
                                              ),
                                              suggestionsCallback: (pattern) {
                                                return controller
                                                    .getPagamenti(pattern);
                                              },
                                              suggestionsBoxDecoration:
                                                  SuggestionsBoxDecoration(
                                                      color: contentTheme
                                                          .background),
                                              itemBuilder: (context,
                                                  Pagamenti suggestion) {
                                                return ListTile(
                                                  title: MyText.labelMedium(
                                                    suggestion.descrizione ??
                                                        "",
                                                  ),
                                                );
                                              },
                                              transitionBuilder: (context,
                                                  suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected:
                                                  (Pagamenti suggestion) {
                                                controller
                                                        .pagamentiTextController
                                                        .text =
                                                    suggestion.descrizione ??
                                                        "";
                                                controller
                                                        .pagamentoSelezionato =
                                                    suggestion;
                                              },
                                              suggestionsBoxController:
                                                  controller
                                                      .basicValidator
                                                      .getController(
                                                          "pagamenti"),
                                              validator: controller
                                                  .basicValidator
                                                  .getValidation("pagamenti"),
                                              displayAllSuggestionWhenTap:
                                                  false,
                                            )
                                          ],
                                        )),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText.labelMedium(
                                              "Zone Clienti",
                                            ),
                                            MySpacing.height(8),
                                            DropDownSearchFormField(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                decoration: InputDecoration(
                                                  hintText: "Seleziona La Zona",
                                                  hintStyle:
                                                      MyTextStyle.bodySmall(
                                                          xMuted: true),
                                                  border: outlineInputBorder,
                                                  contentPadding:
                                                      MySpacing.all(16),
                                                  isCollapsed: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  /*suffixIcon: InkWell(
                                                onTap: () {
                                                  _dropdownSearchFieldController
                                                      .text = "";
                                                  setState(() {});
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))*/
                                                ),
                                                controller: controller
                                                    .zoneCliTextController,
                                              ),
                                              suggestionsCallback: (pattern) {
                                                return controller
                                                    .getZoneClienti(pattern);
                                              },
                                              suggestionsBoxDecoration:
                                                  SuggestionsBoxDecoration(
                                                      color: contentTheme
                                                          .background),
                                              itemBuilder: (context,
                                                  ZoneClienti suggestion) {
                                                return ListTile(
                                                  title: MyText.labelMedium(
                                                    suggestion.cydes ?? "",
                                                  ),
                                                );
                                              },
                                              transitionBuilder: (context,
                                                  suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected:
                                                  (ZoneClienti suggestion) {
                                                controller.zoneCliTextController
                                                        .text =
                                                    suggestion.cydes ?? "";
                                                controller
                                                        .zonaClienteSelezionata =
                                                    suggestion;
                                              },
                                              suggestionsBoxController:
                                                  controller.basicValidator
                                                      .getController("zoneCli"),
                                              validator: controller
                                                  .basicValidator
                                                  .getValidation("zoneCli"),
                                              displayAllSuggestionWhenTap:
                                                  false,
                                            )
                                          ],
                                        )),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText.labelMedium(
                                              "Categoria Cliente",
                                            ),
                                            MySpacing.height(8),
                                            DropDownSearchFormField(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Seleziona La Categoria Cliente",
                                                  hintStyle:
                                                      MyTextStyle.bodySmall(
                                                          xMuted: true),
                                                  border: outlineInputBorder,
                                                  contentPadding:
                                                      MySpacing.all(16),
                                                  isCollapsed: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  /*suffixIcon: InkWell(
                                                onTap: () {
                                                  _dropdownSearchFieldController
                                                      .text = "";
                                                  setState(() {});
                                                },
                                                child:
                                                    Icon(Icons.cancel_outlined))*/
                                                ),
                                                controller: controller
                                                    .catCliTextController,
                                              ),
                                              suggestionsCallback: (pattern) {
                                                return controller
                                                    .getCustomerCategory(
                                                        pattern);
                                              },
                                              suggestionsBoxDecoration:
                                                  SuggestionsBoxDecoration(
                                                      color: contentTheme
                                                          .background),
                                              itemBuilder: (context,
                                                  CustomerCategory suggestion) {
                                                return ListTile(
                                                  title: MyText.labelMedium(
                                                    suggestion.cxdes ?? "",
                                                  ),
                                                );
                                              },
                                              transitionBuilder: (context,
                                                  suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected:
                                                  (CustomerCategory
                                                      suggestion) {
                                                controller.catCliTextController
                                                        .text =
                                                    suggestion.cxdes ?? "";
                                                controller
                                                        .categoriaClienteSelezionata =
                                                    suggestion;
                                              },
                                              suggestionsBoxController:
                                                  controller.basicValidator
                                                      .getController("catCLi"),
                                              validator: controller
                                                  .basicValidator
                                                  .getValidation("catCli"),
                                              displayAllSuggestionWhenTap:
                                                  false,
                                            )
                                          ],
                                        )),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText.labelMedium(
                                              "Tipo Attività",
                                            ),
                                            MySpacing.height(8),
                                            MultiSelectDropDown(
                                              hint: "Seleziona Tipo Attività",
                                              showClearIcon: false,
                                              controller: controller
                                                  .controllerTipoAttivita,
                                              onOptionSelected: (options) {},
                                              options: <ValueItem<
                                                  TipoAttivita>>[
                                                ...controller.tipoAttivita
                                              ],
                                              optionTextStyle:
                                                  MyTextStyle.labelMedium(),
                                              /* selectedItemBuilder: (p0, p1) {
                                        return Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: contentTheme.primary),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                  child: MyText.labelMedium(
                                                      p1.label)),
                                              Flexible(
                                                  child: InkWell(
                                                      onTap: () {
                                                        controller.controller
                                                            .clearSelection(p1);
                                                        controller.update();
                                                      },
                                                      child:
                                                          Icon(Icons.cancel)))
                                            ],
                                          ),
                                        );
                                      },*/
                                              /*onOptionRemoved: (index, option) {
                                        controller.controller
                                            .clearSelection(option);
                                        controller.update();
                                      },*/
                                              inputDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                border: Border.all(
                                                    strokeAlign: 1,
                                                    color: theme.colorScheme
                                                        .onBackground
                                                        .withAlpha(80),
                                                    width: 1),
                                              ),
                                              selectionType:
                                                  SelectionType.multi,
                                              chipConfig: const ChipConfig(
                                                  wrapType: WrapType.wrap),
                                              //dropdownHeight: 300,
                                              selectedOptionIcon: const Icon(
                                                  Icons.check_circle),
                                              selectedOptionBackgroundColor:
                                                  contentTheme.background,
                                              selectedOptionTextColor:
                                                  contentTheme.primary,
                                              dropdownBackgroundColor:
                                                  contentTheme.background,
                                              dropdownMargin: 5,
                                              optionsBackgroundColor:
                                                  contentTheme.background,
                                            ),
                                          ],
                                        )),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText.labelMedium(
                                              "Giorni di chiusura",
                                            ),
                                            MySpacing.height(8),
                                            MultiSelectDropDown(
                                              hint:
                                                  "Seleziona giorni di chiusura",
                                              showClearIcon: false,
                                              controller:
                                                  controller.controllerGiorni,
                                              onOptionSelected: (options) {},
                                              options: <ValueItem<List>>[
                                                ...controller.giorni
                                              ],
                                              optionTextStyle:
                                                  MyTextStyle.labelMedium(),
                                              inputDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                border: Border.all(
                                                    strokeAlign: 1,
                                                    color: theme.colorScheme
                                                        .onBackground
                                                        .withAlpha(80),
                                                    width: 1),
                                              ),
                                              selectionType:
                                                  SelectionType.multi,
                                              chipConfig: const ChipConfig(
                                                  wrapType: WrapType.wrap),
                                              //dropdownHeight: 300,
                                              selectedOptionIcon: const Icon(
                                                  Icons.check_circle),
                                              selectedOptionBackgroundColor:
                                                  contentTheme.background,
                                              selectedOptionTextColor:
                                                  contentTheme.primary,
                                              dropdownBackgroundColor:
                                                  contentTheme.background,
                                              dropdownMargin: 5,
                                              optionsBackgroundColor:
                                                  contentTheme.background,
                                            ),
                                          ],
                                        )),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: TimeRange(
                                            fromTitle: MyText.labelMedium(
                                                "Chiuso dalle"),
                                            toTitle: MyText.labelMedium("Alle"),
                                            titlePadding: 0,
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: contentTheme.cardText),
                                            activeTextStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: contentTheme.primary),
                                            borderColor:
                                                contentTheme.cardBorder,
                                            backgroundColor: Colors.transparent,
                                            activeBackgroundColor:
                                                contentTheme.background,
                                            firstTime:
                                                TimeOfDay(hour: 9, minute: 0),
                                            lastTime:
                                                TimeOfDay(hour: 21, minute: 00),
                                            timeStep: 30,
                                            timeBlock: 30,
                                            onRangeCompleted: (range) {
                                              controller
                                                  .setOrarioChiusura(range);
                                            },
                                            onFirstTimeSelected:
                                                (startHour) {})),
                                    MyFlexItem(
                                      sizes: "md-12 sm-12",
                                      child: buildTextField(
                                          'Note',
                                          "Inserisci Le Note",
                                          controller.basicValidator
                                              .getController("nota2"),
                                          controller.basicValidator
                                              .getValidation("nota2"),
                                          true),
                                    ),
                                  ],
                                )),

                            /* Separatore */
                            MyFlexItem(child: Divider()),
                            /* Separatore */
                            MyFlexItem(
                              sizes: "md-12 sm-12",
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: MyText.bodyLarge(
                                  "Destinazione diversa",
                                  fontWeight: 600,
                                ),
                                value: controller.destDiversa,
                                onChanged: (value) =>
                                    controller.onChangeDestDiversa(value),
                              ),
                            ),
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: Visibility(
                                  visible: controller.destDiversa,
                                  child: MyFlex(
                                    children: [
                                      MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: buildTextField(
                                            'Rag. Sociale',
                                            "Inserisci La Ragione Sociale",
                                            controller.basicValidator
                                                .getController("ragSocDest"),
                                            controller.basicValidator
                                                .getValidation("ragSocDest"),
                                            true),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: CheckboxListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.zero,
                                            dense: true,
                                            title: MyText.bodyMedium(
                                              "Privato",
                                              fontWeight: 600,
                                            ),
                                            value: controller.isCheckedDest,
                                            onChanged: (value) => controller
                                                .onChangeCheckBoxDest(value),
                                          ),
                                        ),
                                      ),
                                      MyFlexItem(
                                          sizes: "md-6 sm-12",
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText.labelMedium(
                                                "Tipo società",
                                              ),
                                              MySpacing.height(8),
                                              DropDownSearchFormField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Seleziona Il Tipo Di Società",
                                                    hintStyle:
                                                        MyTextStyle.bodySmall(
                                                            xMuted: true),
                                                    border: outlineInputBorder,
                                                    contentPadding:
                                                        MySpacing.all(16),
                                                    isCollapsed: true,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    /*suffixIcon: InkWell(
                                                  onTap: () {
                                                    _dropdownSearchFieldController
                                                        .text = "";
                                                    setState(() {});
                                                  },
                                                  child:
                                                      Icon(Icons.cancel_outlined))*/
                                                  ),
                                                  controller: controller
                                                      .tipoSocDestTextController,
                                                ),
                                                suggestionsCallback: (pattern) {
                                                  return controller
                                                      .getTipoSocieta(pattern);
                                                },
                                                suggestionsBoxDecoration:
                                                    SuggestionsBoxDecoration(
                                                        color: contentTheme
                                                            .background),
                                                itemBuilder: (context,
                                                    TipoSocieta suggestion) {
                                                  return ListTile(
                                                    title: MyText.labelMedium(
                                                      suggestion.descrizione ??
                                                          "",
                                                    ),
                                                  );
                                                },
                                                transitionBuilder: (context,
                                                    suggestionsBox,
                                                    controller) {
                                                  return suggestionsBox;
                                                },
                                                onSuggestionSelected:
                                                    (TipoSocieta suggestion) {
                                                  controller
                                                      .tipoSocDestTextController
                                                      .text = suggestion
                                                          .descrizione ??
                                                      "";
                                                  controller
                                                          .tiposocietaSelezionataDest =
                                                      suggestion;
                                                },
                                                suggestionsBoxController:
                                                    controller
                                                        .basicValidator
                                                        .getController(
                                                            "tipoSocDest"),
                                                validator: controller
                                                    .basicValidator
                                                    .getValidation(
                                                        "tipoSocDest"),
                                                displayAllSuggestionWhenTap:
                                                    false,
                                              )
                                            ],
                                          )),
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: buildTextField(
                                            'Cod. Fiscale',
                                            "Inserisci Il Codice Fiscale",
                                            controller.basicValidator
                                                .getController("codFiscDest"),
                                            controller.basicValidator
                                                .getValidation("codFiscDest"),
                                            true),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: buildTextField(
                                            'Partita Iva',
                                            "Inserisci La Partita Iva",
                                            controller.basicValidator
                                                .getController("partIvaDest"),
                                            controller.basicValidator
                                                .getValidation("partIvaDest"),
                                            !controller.isCheckedDest),
                                      ),
                                    ],
                                  ),
                                )),
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: Visibility(
                                  visible: controller.destDiversa,
                                  child: MyFlex(
                                    children: [
                                      MyFlexItem(
                                          sizes: "md-6 sm-12",
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText.labelMedium(
                                                "Nazionalità",
                                              ),
                                              MySpacing.height(8),
                                              DropDownSearchFormField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Seleziona La Nazionalità",
                                                    hintStyle:
                                                        MyTextStyle.bodySmall(
                                                            xMuted: true),
                                                    border: outlineInputBorder,
                                                    contentPadding:
                                                        MySpacing.all(16),
                                                    isCollapsed: true,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    /*suffixIcon: InkWell(
                                                  onTap: () {
                                                    _dropdownSearchFieldController
                                                        .text = "";
                                                    setState(() {});
                                                  },
                                                  child:
                                                      Icon(Icons.cancel_outlined))*/
                                                  ),
                                                  controller: controller
                                                      .nazionalitaDestTextController,
                                                ),
                                                suggestionsCallback: (pattern) {
                                                  return controller
                                                      .getNazionalita(pattern);
                                                },
                                                suggestionsBoxDecoration:
                                                    SuggestionsBoxDecoration(
                                                        color: contentTheme
                                                            .background),
                                                itemBuilder: (context,
                                                    Nazionalita suggestion) {
                                                  return ListTile(
                                                    title: MyText.labelMedium(
                                                      suggestion.descrizione ??
                                                          "",
                                                    ),
                                                  );
                                                },
                                                transitionBuilder: (context,
                                                    suggestionsBox,
                                                    controller) {
                                                  return suggestionsBox;
                                                },
                                                onSuggestionSelected:
                                                    (Nazionalita suggestion) {
                                                  controller
                                                      .nazionalitaDestTextController
                                                      .text = suggestion
                                                          .descrizione ??
                                                      "";
                                                  controller
                                                          .nazionalitaSelezionataDest =
                                                      suggestion;
                                                },
                                                suggestionsBoxController:
                                                    controller
                                                        .basicValidator
                                                        .getController(
                                                            "nazionalitaDest"),
                                                validator: controller
                                                    .basicValidator
                                                    .getValidation(
                                                        "nazionalitaDest"),
                                                displayAllSuggestionWhenTap:
                                                    false,
                                              )
                                            ],
                                          )),
                                      MyFlexItem(
                                          sizes: "md-6 sm-12",
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText.labelMedium(
                                                "Paese",
                                              ),
                                              MySpacing.height(8),
                                              DropDownSearchFormField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Seleziona Il Paese",
                                                    hintStyle:
                                                        MyTextStyle.bodySmall(
                                                            xMuted: true),
                                                    border: outlineInputBorder,
                                                    contentPadding:
                                                        MySpacing.all(16),
                                                    isCollapsed: true,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    /*suffixIcon: InkWell(
                                                  onTap: () {
                                                    _dropdownSearchFieldController
                                                        .text = "";
                                                    setState(() {});
                                                  },
                                                  child:
                                                      Icon(Icons.cancel_outlined))*/
                                                  ),
                                                  controller: controller
                                                      .paeseDestTextController,
                                                ),
                                                suggestionsCallback: (pattern) {
                                                  return controller
                                                      .getPaesi(pattern);
                                                },
                                                suggestionsBoxDecoration:
                                                    SuggestionsBoxDecoration(
                                                        color: contentTheme
                                                            .background),
                                                itemBuilder: (context,
                                                    Paesi suggestion) {
                                                  return ListTile(
                                                    title: MyText.labelMedium(
                                                      suggestion.descrizione ??
                                                          "",
                                                    ),
                                                  );
                                                },
                                                transitionBuilder: (context,
                                                    suggestionsBox,
                                                    controller) {
                                                  return suggestionsBox;
                                                },
                                                onSuggestionSelected:
                                                    (Paesi suggestion) {
                                                  controller
                                                      .paeseDestTextController
                                                      .text = suggestion
                                                          .descrizione ??
                                                      "";
                                                  controller
                                                          .paeseSelezionatoDest =
                                                      suggestion;
                                                },
                                                suggestionsBoxController:
                                                    controller
                                                        .basicValidator
                                                        .getController(
                                                            "paeseDest"),
                                                validator: controller
                                                    .basicValidator
                                                    .getValidation("paeseDest"),
                                                displayAllSuggestionWhenTap:
                                                    false,
                                              )
                                            ],
                                          )),
                                      MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: buildTextField(
                                            'Indirizzo',
                                            "Inserisci L'indirizzo",
                                            controller.basicValidator
                                                .getController("indirizzoDest"),
                                            controller.basicValidator
                                                .getValidation("indirizzoDest"),
                                            true),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-3 sm-12",
                                        child: buildTextField(
                                            'Cap',
                                            "",
                                            controller.basicValidator
                                                .getController("capDest"),
                                            controller.basicValidator
                                                .getValidation("capDest"),
                                            false),
                                      ),
                                      MyFlexItem(
                                          sizes: "md-7 sm-12",
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText.labelMedium(
                                                "Località",
                                              ),
                                              MySpacing.height(8),
                                              DropDownSearchFormField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Seleziona La Località",
                                                    hintStyle:
                                                        MyTextStyle.bodySmall(
                                                            xMuted: true),
                                                    border: outlineInputBorder,
                                                    contentPadding:
                                                        MySpacing.all(16),
                                                    isCollapsed: true,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    /*suffixIcon: InkWell(
                                                  onTap: () {
                                                    _dropdownSearchFieldController
                                                        .text = "";
                                                    setState(() {});
                                                  },
                                                  child:
                                                      Icon(Icons.cancel_outlined))*/
                                                  ),
                                                  controller: controller
                                                      .comuneDestTextController,
                                                ),
                                                suggestionsCallback: (pattern) {
                                                  return controller
                                                      .getComuni(pattern);
                                                },
                                                suggestionsBoxDecoration:
                                                    SuggestionsBoxDecoration(
                                                        color: contentTheme
                                                            .background),
                                                itemBuilder: (context,
                                                    Comuni suggestion) {
                                                  return ListTile(
                                                    title: MyText.labelMedium(
                                                      suggestion.localita ?? "",
                                                    ),
                                                  );
                                                },
                                                transitionBuilder: (context,
                                                    suggestionsBox,
                                                    controller) {
                                                  return suggestionsBox;
                                                },
                                                onSuggestionSelected:
                                                    (Comuni suggestion) {
                                                  controller
                                                      .comuneDestTextController
                                                      .text = suggestion
                                                          .localita ??
                                                      "";
                                                  controller
                                                          .comuneSelezionatoDest =
                                                      suggestion;
                                                  controller.basicValidator
                                                      .getController("capDest")
                                                      ?.text = suggestion
                                                          .cap ??
                                                      "";
                                                  controller.basicValidator
                                                          .getController(
                                                              "provinciaDest")
                                                          ?.text =
                                                      suggestion.provincia ??
                                                          "";
                                                },
                                                suggestionsBoxController:
                                                    controller
                                                        .basicValidator
                                                        .getController(
                                                            "localitaDest"),
                                                validator: controller
                                                    .basicValidator
                                                    .getValidation(
                                                        "localitaDest"),
                                                displayAllSuggestionWhenTap:
                                                    false,
                                              )
                                            ],
                                          )),
                                      MyFlexItem(
                                        sizes: "md-2 sm-12",
                                        child: buildTextField(
                                            'Prov.',
                                            "",
                                            controller.basicValidator
                                                .getController("provinciaDest"),
                                            controller.basicValidator
                                                .getValidation("provinciaDest"),
                                            false),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        MySpacing.height(12),
                        Padding(
                          padding: MySpacing.right(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /* MyContainer.bordered(
                                paddingAll: 8,
                                onTap: () {
                                  showErrorMessage(context, "Attenzione",
                                      "La partita iva esiste gia' con altro codice nello stesso gruppo/mastro <501.07571>");
                                },
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.x, size: 20),
                                    MySpacing.width(8),
                                    MyText.bodyMedium(
                                      "Close",
                                      fontWeight: 600,
                                    )
                                  ],
                                ),
                              ),*/
                              MySpacing.width(12),
                              MyButton.rounded(
                                onPressed: controller.inserisciCliente,
                                elevation: 0,
                                padding: MySpacing.xy(20, 16),
                                backgroundColor: contentTheme.primary,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    controller.loading
                                        ? SizedBox(
                                            height: 14,
                                            width: 14,
                                            child: CircularProgressIndicator(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              strokeWidth: 1.2,
                                            ),
                                          )
                                        : Container(),
                                    if (controller.loading) MySpacing.width(16),
                                    MyText.bodySmall(
                                      'Salva',
                                      color: contentTheme.onPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  buildTextField(
      String fieldTitle,
      String hintText,
      TextEditingController? controller,
      String? Function(String?)? validator,
      bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelMedium(
          fieldTitle,
        ),
        MySpacing.height(8),
        TextFormField(
          enabled: enabled,
          controller: controller,
          validator: validator,
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
