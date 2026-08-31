class /ITETR/CL_OUTGOING_INVOICE definition
  public
  create public .

public section.

  types:
    BEGIN OF mty_response_data ,
        bukrs       TYPE  bukrs,
        doc_number  TYPE  belnr_d,
        gjahr       TYPE  gjahr,
        prfid       TYPE  /itetr/inv_e_prfid,
        invty       TYPE  /itetr/inv_e_invty,
        docui       TYPE  /itetr/com_e_docui,
        envui       TYPE  /itetr/com_e_envui,
        invui       TYPE  /itetr/com_e_duich,
        invno       TYPE  /itetr/com_e_docno,
        invii       TYPE /itetr/com_e_docii,
        stacd       TYPE /itetr/com_e_stacd,
        xsltt       TYPE  /itetr/com_e_xsltt,
        ubl_xstring TYPE  xstring,
        staex       TYPE /itetr/com_e_staex,
      END OF mty_response_data .
  types:
    BEGIN OF mty_texts.
        INCLUDE TYPE stxh_key.
    TYPES tline TYPE tline_tab.
    TYPES END OF mty_texts .
  types:
    BEGIN OF mty_return_references.
    TYPES return_ref_no TYPE char30.
    TYPES return_ref_date TYPE char10.
    TYPES END OF mty_return_references .
  types:
    BEGIN OF mty_billing_data.
    TYPES t001  TYPE t001.
    TYPES vbrk  TYPE vbrkvb.
    TYPES vbrp  TYPE SORTED TABLE OF vbrpvb  WITH UNIQUE KEY posnr.
    TYPES mara  TYPE SORTED TABLE OF mara  WITH UNIQUE KEY matnr.
    TYPES maw1  TYPE SORTED TABLE OF maw1  WITH UNIQUE KEY matnr.
    TYPES marc  TYPE SORTED TABLE OF marc  WITH UNIQUE KEY matnr werks.
    TYPES t005  TYPE SORTED TABLE OF t005  WITH UNIQUE KEY land1.
    TYPES t005t TYPE SORTED TABLE OF t005t WITH UNIQUE KEY land1.
    TYPES likp  TYPE SORTED TABLE OF likp  WITH UNIQUE KEY vbeln.
    TYPES lips  TYPE SORTED TABLE OF lips  WITH UNIQUE KEY vbeln posnr.
    TYPES vbak  TYPE SORTED TABLE OF vbak  WITH UNIQUE KEY vbeln.
    TYPES vbap  TYPE SORTED TABLE OF vbap  WITH UNIQUE KEY vbeln posnr.
    TYPES vbkd  TYPE SORTED TABLE OF vbkd  WITH UNIQUE KEY vbeln posnr.
    TYPES vbpa  TYPE SORTED TABLE OF vbpavb  WITH UNIQUE KEY vbeln posnr parvw
                                           WITH NON-UNIQUE SORTED KEY by_parvw COMPONENTS parvw.
    TYPES konv  TYPE SORTED TABLE OF komv  WITH UNIQUE KEY kposn stunr zaehk
                                           WITH NON-UNIQUE SORTED KEY by_kschl COMPONENTS kposn kschl kinak
                                           WITH NON-UNIQUE SORTED KEY by_koaid COMPONENTS kposn koaid kinak.
    TYPES address_number TYPE adrnr.
    TYPES taxid TYPE stcd2.
    TYPES tax_office TYPE /itetr/com_e_taxof.
    TYPES carier_taxid           TYPE stcd2.
    TYPES carier_name            TYPE text100.
    TYPES t685t TYPE SORTED TABLE OF t685t WITH UNIQUE KEY kschl.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES conditions TYPE SORTED TABLE OF /itetr/inv_cond WITH UNIQUE KEY kschl
                                                          WITH NON-UNIQUE SORTED KEY by_cndty COMPONENTS cndty
                                                          WITH NON-UNIQUE SORTED KEY by_kschl COMPONENTS kschl cndty.
    TYPES return_ref   TYPE SORTED TABLE OF mty_return_references WITH UNIQUE KEY return_ref_no return_ref_date.
    TYPES END OF mty_billing_data .
  types:
    BEGIN OF mty_accdoc_data.
    TYPES t001 TYPE t001.
    TYPES t005 TYPE SORTED TABLE OF t005 WITH UNIQUE KEY land1.
    TYPES t005t TYPE SORTED TABLE OF t005t WITH UNIQUE KEY land1.
    TYPES t005u TYPE SORTED TABLE OF t005u WITH UNIQUE KEY land1 bland.
    TYPES bkpf TYPE bkpf.
    TYPES bsec TYPE bsec.
    TYPES bseg TYPE SORTED TABLE OF bseg WITH UNIQUE KEY buzei
                                         WITH NON-UNIQUE SORTED KEY by_koart COMPONENTS koart shkzg
                                         WITH NON-UNIQUE SORTED KEY by_hkont COMPONENTS hkont shkzg.

    TYPES bseg_partner TYPE bseg.
    TYPES address_number TYPE adrnr.
    TYPES taxid TYPE stcd2.
    TYPES tax_office TYPE /itetr/com_e_taxof.
    TYPES skat TYPE SORTED TABLE OF skat WITH UNIQUE KEY saknr.
    TYPES accounts TYPE SORTED TABLE OF /itetr/inv_fiac WITH UNIQUE KEY saknr
                                                        WITH NON-UNIQUE SORTED KEY by_accty COMPONENTS accty.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES return_ref TYPE SORTED TABLE OF mty_return_references WITH UNIQUE KEY return_ref_no return_ref_date.
    TYPES END OF mty_accdoc_data .
  types:
    BEGIN OF mty_fica_data.
    TYPES t001 TYPE t001.
    TYPES t005 TYPE SORTED TABLE OF t005 WITH UNIQUE KEY land1.
    TYPES t005t TYPE SORTED TABLE OF t005t WITH UNIQUE KEY land1.
    TYPES dfkkko TYPE dfkkko.
    TYPES dfkkop TYPE dfkkop.
    TYPES dfkkopk TYPE SORTED TABLE OF dfkkopk WITH UNIQUE KEY opbel opupk.
    TYPES dfkkopk_partner TYPE dfkkopk.
    TYPES t030k TYPE SORTED TABLE OF t030k WITH UNIQUE KEY ktopl ktosl mwskz.
    TYPES skat TYPE skat.
    TYPES oginv TYPE /itetr/inv_oginv.

    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.

    TYPES address_number TYPE adrnr.
    TYPES taxid TYPE stcd2.
    TYPES tax_office TYPE /itetr/com_e_taxof.

    TYPES END OF mty_fica_data .
  types:
    BEGIN OF mty_invrec_data.
    TYPES t001 TYPE t001.
    TYPES t005 TYPE SORTED TABLE OF t005 WITH UNIQUE KEY land1.
    TYPES t005t TYPE SORTED TABLE OF t005t WITH UNIQUE KEY land1.
    TYPES headerdata TYPE bapi_incinv_detail_header.
    TYPES addressdata TYPE bapi_incinv_detail_addressdata.
    TYPES itemdata TYPE TABLE OF bapi_incinv_detail_item WITH DEFAULT KEY.
    TYPES accountingdata TYPE TABLE OF bapi_incinv_detail_account WITH DEFAULT KEY.
    TYPES glaccountdata TYPE TABLE OF bapi_incinv_detail_gl_account WITH DEFAULT KEY.
    TYPES materialdata TYPE TABLE OF bapi_incinv_detail_material WITH DEFAULT KEY.
    TYPES taxdata TYPE TABLE OF bapi_incinv_detail_tax WITH DEFAULT KEY.
    TYPES address_number TYPE adrnr.
    TYPES taxid TYPE stcd2.
    TYPES tax_office TYPE /itetr/com_e_taxof.
    TYPES ekpo TYPE SORTED TABLE OF ekpo WITH UNIQUE KEY ebeln ebelp.
    TYPES ekko TYPE SORTED TABLE OF ekko WITH UNIQUE KEY ebeln.
    TYPES ekbe TYPE SORTED TABLE OF ekbe WITH UNIQUE KEY ebeln ebelp zekkn vgabe gjahr belnr buzei.
    TYPES mseg TYPE SORTED TABLE OF mseg WITH UNIQUE KEY mblnr mjahr zeile.
    TYPES mkpf TYPE SORTED TABLE OF mkpf WITH UNIQUE KEY mblnr mjahr .
    TYPES makt TYPE SORTED TABLE OF makt WITH UNIQUE KEY matnr.
    TYPES mara TYPE SORTED TABLE OF mara WITH UNIQUE KEY matnr.
    TYPES maw1  TYPE SORTED TABLE OF maw1  WITH UNIQUE KEY matnr.
    TYPES marc  TYPE SORTED TABLE OF marc  WITH UNIQUE KEY matnr werks.
    TYPES texts TYPE SORTED TABLE OF mty_texts WITH UNIQUE KEY tdobject tdid tdspras tdname.
    TYPES return_ref TYPE SORTED TABLE OF mty_return_references WITH UNIQUE KEY return_ref_no return_ref_date.
    TYPES END OF mty_invrec_data .
  types:
    BEGIN OF mty_export_spec_data.
    TYPES kunwe TYPE bu_partner.
    TYPES adrwe TYPE adrnr.
    TYPES inco1 TYPE inco1.
    TYPES trnty TYPE /itetr/com_e_trnty.
    TYPES hscod TYPE /itetr/inv_e_hscod.
    TYPES kwrfr TYPE kwert.
    TYPES kwrin TYPE kwert.
    TYPES END OF mty_export_spec_data .
  types:
    BEGIN OF mty_item_collect.
    TYPES posnr TYPE posnr.
    TYPES uepos TYPE uepos.
    TYPES pstyv TYPE pstyv.
    TYPES matnr TYPE matnr.
    TYPES kdmat TYPE kdmat.
    TYPES admat TYPE kdmat.
    TYPES arktx TYPE text255.
    TYPES descr TYPE text255.
    TYPES fkimg TYPE fkimg.
    TYPES vrkme TYPE vrkme.
    TYPES netwr TYPE netwr.
    TYPES netpr TYPE char20.
    TYPES peinh TYPE char20.
    TYPES herkl TYPE text30.
    TYPES netwa TYPE waers.
    TYPES disrt TYPE char20.
    TYPES distr TYPE kwert.
    TYPES surrt TYPE char20.
    TYPES surtr TYPE kwert.
    TYPES mwskz TYPE mwskz.
    TYPES mwsbp TYPE mwsbp.
    TYPES othtx TYPE mwsbp.
    TYPES othtt TYPE /itetr/com_e_taxty.
    TYPES othtr TYPE char20.
    TYPES dgrtx TYPE mwsbp.
    TYPES dgrtt TYPE /itetr/com_e_taxty.
    TYPES dgrtr TYPE char20.
    TYPES waers TYPE waers.
    TYPES summr TYPE text255.
    TYPES diib  TYPE char20.
    TYPES sellerdiib TYPE char20.
    TYPES buyerdiib  TYPE char20.
    TYPES etiketno TYPE char9. "gkadioglu
    TYPES classification_code TYPE char2. "gkadioglu
    TYPES model_name TYPE char50. "gkadioglu
    TYPES serial_id  TYPE char50. "gkadioglu
    TYPES product_trace_id TYPE char10. "gkadioglu

*    TYPES ilac_gtin TYPE char20.
*    TYPES ilac_bn TYPE char20.
*    TYPES ilac_sn TYPE char20.
*    TYPES ilac_xd TYPE char20.
*    TYPES tibbicihaz_uno TYPE char20.
*    TYPES tibbicihaz_lno TYPE char20.
*    TYPES tibbicihaz_sno TYPE char20.
*    TYPES tibbicihaz_urt TYPE char20.
    INCLUDE TYPE mty_export_spec_data.
    TYPES END OF mty_item_collect .
  types:
    mty_item_collect_t TYPE TABLE OF mty_item_collect .
  types:
    BEGIN OF mty_item_allowance.
    TYPES posnr TYPE posnr.
    TYPES disrt TYPE char20.
    TYPES distr TYPE kwert.
    TYPES surrt TYPE char20.
    TYPES surtr TYPE kwert.
    TYPES summr TYPE text255.
    TYPES END OF mty_item_allowance .
  types:
    mty_item_allowance_t TYPE TABLE OF mty_item_allowance .
  types:
    BEGIN OF mty_item_additional.
    TYPES posnr TYPE posnr.
    TYPES matnr TYPE matnr.
    TYPES scheme_id TYPE char20.
    TYPES content TYPE string.
    TYPES END OF mty_item_additional .
  types:
    mty_item_additional_t TYPE TABLE OF mty_item_additional .
  types:
    BEGIN OF mty_contract_document.
    TYPES schemeid TYPE char20.
    TYPES id TYPE char6.
    TYPES issue_date TYPE char10.
    TYPES END OF mty_contract_document .
  types:
    mty_contract_document_t TYPE TABLE OF mty_contract_document .
  types:
    mty_iban_t TYPE TABLE OF /itetr/inv_iban .
  types:
    BEGIN OF st_banka.
    TYPES hbkid TYPE hbkid.
    TYPES hktid TYPE hktid.
    TYPES banka TYPE banka.
    TYPES brnch TYPE brnch.
    TYPES waers TYPE waers.
    TYPES iban  TYPE iban.
    TYPES swift TYPE swift.
    TYPES END OF st_banka .
  types:
    mty_banka_info TYPE TABLE OF st_banka .
  types MST_BANKA_INFO type ST_BANKA .

  class-methods FACTORY
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DOCUI
      !IV_PREVIEW type XFELD
    returning
      value(RO_OBJECT) type ref to /ITETR/CL_OUTGOING_INVOICE
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA
    exporting
      !ES_INVOICE_UBL type /ITETR/COM_MESSAGE1
      !EV_INVOICE_UBL type XSTRING
      !EV_INVOICE_HASH type MD5_FIELDS-HASH
      !EV_INVOICE_NO type /ITETR/COM_E_DOCNO
      !ET_CUSTOM_PARAMETERS type /ITETR/COM_TT_CUSTOM_PARAM
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_TAX_MATCH
    importing
      !IV_KALSM type KALSM_D
      !IV_MWSKZ type MWSKZ
    returning
      value(RS_TAX_MATCH) type /ITETR/INV_TAXM .
  class-methods SEND_INV_TO_TRA
    importing
      !IV_MODULE type CHAR4
      !IV_BUKRS type BUKRS
      !IT_DATA type TABLE
      !IV_PROCESS_METHOD type CHAR10
      !IV_PARAMETER type /ITETR/INV_E_EICPA optional
    exporting
      !ES_RESPONSE type MTY_RESPONSE_DATA
      !ET_RETURN type BAPIRET2_TAB .
  methods EXIT_AFTER_SEND_INVOICE
    importing
      !IS_OGINV type /ITETR/INV_OGINV optional
      !IV_UBL_XSTRING type XSTRING optional
      !IV_RESPONSE_MESSAGE type /ITETR/COM_E_LONG_NOTE optional
      !IV_STATUS_CODE type /ITETR/COM_E_STACD optional .
protected section.

  data MO_INVOICE_OPERATIONS type ref to /ITETR/CL_INVOICE_OPERATIONS .
  data MS_DOCUMENT type /ITETR/INV_OGINV .
  data MV_PREVIEW type XFELD .
  data MS_INVOICE_UBL type /ITETR/COM_MESSAGE1 .
  data MV_INVOICE_HASH type MD5_FIELDS-HASH .
  data MV_INVOICE_UBL type XSTRING .
  data MT_CUSTOM_PARAMETERS type /ITETR/COM_TT_CUSTOM_PARAM .
  data MS_BILLING_DATA type MTY_BILLING_DATA .
  data MS_ACCDOC_DATA type MTY_ACCDOC_DATA .
  data MS_INVREC_DATA type MTY_INVREC_DATA .
  data MS_FICA_DATA type MTY_FICA_DATA .
  data MT_INVOICE_ITEMS type MTY_ITEM_COLLECT_T .
  data MV_GENERATE_INVOICE_ID type /ITETR/COM_E_GENID .
  data MV_COMPANY_TAXID type STCD2 .
  data MV_ADD_SIGNATURE type /ITETR/COM_E_VALUE .
  data MV_ITEM_SORT type /ITETR/COM_E_VALUE .
  data MV_BARCODE type /ITETR/COM_E_BARCODE .
  data MV_SEPALLOWANCE type /ITETR/COM_E_SEPALLOWANCE .
  data MT_ITEMS_ALLOWANCE type MTY_ITEM_ALLOWANCE_T .
  data MT_ITEMS_ADDITIONAL type MTY_ITEM_ADDITIONAL_T .
  data MT_CONTRACT_DOCUMENT type MTY_CONTRACT_DOCUMENT_T .
  data MV_FIX_QUANTITY type /ITETR/COM_E_VALUE .
  data MT_IBAN type MTY_IBAN_T .
  data MT_BANKA type MTY_BANKA_INFO .
  data MV_COUNTRY type LAND1 .
  data MV_INVTYPE type /ITETR/COM_E_VALUE .
  data MV_SHIPTO_ADDRESS type ADRNR .
  data:
    mt_inv_eicp TYPE TABLE OF  /itetr/inv_eicp .

  methods GET_DATA_VBRK
    importing
      !IV_VBELN type VBELN_VF
    returning
      value(RS_DATA) type /ITETR/CL_OUTGOING_INVOICE=>MTY_BILLING_DATA .
  methods GET_DATA_BKPF
    importing
      !IV_BUKRS type BUKRS
      !IV_BELNR type BELNR_D
      !IV_GJAHR type GJAHR
    returning
      value(RS_DATA) type /ITETR/CL_OUTGOING_INVOICE=>MTY_ACCDOC_DATA .
  methods GET_DATA_RMRP
    importing
      !IV_BELNR type BELNR_D
      !IV_GJAHR type GJAHR
    returning
      value(RS_DATA) type /ITETR/CL_OUTGOING_INVOICE=>MTY_INVREC_DATA .
  methods GET_DATA_FICA
    importing
      !IV_BUKRS type BUKRS
      !IV_BELNR type /ITETR/INV_E_BELNR_FICA
      !IV_GJAHR type GJAHR
      !IV_GPART type GPART_KK
    returning
      value(RS_DATA) type /ITETR/CL_OUTGOING_INVOICE=>MTY_FICA_DATA .
  methods GENERATE_INVOICE_ID
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods FILL_COMMON_INVOICE_DATA
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_VBRK
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_VBRK_HEAD
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_VBRK_REF
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_VBRK_PARTY
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_VBRK_ITEM
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_VBRK_EXPORT
    importing
      !IS_VBRP type VBRPVB
    returning
      value(RS_DATA) type MTY_EXPORT_SPEC_DATA .
  methods BUILD_INVOICE_DATA_VBRK_TOTALS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_VBRK_NOTES
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_RMRP
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_RMRP_HEAD
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_RMRP_REF .
  methods BUILD_INVOICE_DATA_RMRP_PARTY
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_RMRP_ITEM
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_RMRP_TOTALS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_RMRP_NOTES
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_BKPF
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_BKPF_HEAD
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_BKPF_PARTY
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_BKPF_ITEM
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_BKPF_TOTALS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_BKPF_NOTES
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_COMMON_ITEM
    importing
      !IV_KALSM type KALSM_D
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_FICA
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_FICA_HEAD
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_FICA_PARTY
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_FICA_ITEM
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_FICA_TOTALS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_INVOICE_DATA_FICA_NOTES
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods FILL_COMMON_TAX_TOTALS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods SUMMARIZE_ITEMS .
  methods COLLECT_ITEMS_VBRK .
  methods COLLECT_ITEMS_VBRK_CHANGE_ITEM
    importing
      !IS_VBRP type VBRPVB
    changing
      !CS_ITEM type MTY_ITEM_COLLECT .
  methods COLLECT_ITEMS_BKPF .
  methods COLLECT_ITEMS_RMRP .
  methods UBL_FILL_PARTNER_DATA
    importing
      !IV_ADDRESS_NUMBER type AD_ADDRNUM
      !IV_NATION type AD_NATION optional
      !IV_PROFILE_ID type /ITETR/INV_E_PRFID optional
      !IV_TAX_OFFICE type /ITETR/COM_E_TAXOF optional
      !IV_TAX_ID type STCD2 optional
    returning
      value(RS_DATA) type /ITETR/COM_PARTY
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods UBL_FILL_COMPANY_DATA
    importing
      !IV_BUKRS type BUKRS
    returning
      value(RS_DATA) type /ITETR/COM_PARTY
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods UBL_FILL_AGENT_DATA
    importing
      !IV_BUKRS type BUKRS
      !IV_AGENT type /ITETR/COM_E_AGENT
    returning
      value(RS_DATA) type /ITETR/COM_ZZ_PARTY_TYPE
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods UBL_FILL_OTHER_PARTY_DATA
    importing
      !IV_TAXID type STCD2 optional
      !IV_PRTTY type /ITETR/COM_E_PRTTY optional
    returning
      value(RS_DATA) type /ITETR/COM_PARTY
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods INVOICE_ABAP_TO_UBL
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_EINVOICE_RULE
    importing
      !IV_RULE_TYPE type /ITETR/INV_E_RULET
      !IS_RULE_INPUT type /ITETR/INV_S_EIRULES_IN
    returning
      value(RT_RULE_OUTPUT) type /ITETR/INV_TT_EIRULES_OUT .
  methods GET_EARCHIVE_RULE
    importing
      !IV_RULE_TYPE type /ITETR/INV_E_RULET
      !IS_RULE_INPUT type /ITETR/INV_S_EARULES_IN
    returning
      value(RT_RULE_OUTPUT) type /ITETR/INV_TT_EARULES_OUT .
  methods COLLECT_ITEMS_FICA .
  methods SET_INITIAL_DATA
    importing
      !IS_DOCUMENT type /ITETR/INV_OGINV
      !IV_PREVIEW type XFELD
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_EINVOICE_BARCODE
    returning
      value(IV_BARCODE) type STRING .
  methods GET_EARCHIVE_BARCODE
    returning
      value(IV_BARCODE) type STRING .
  methods BUILD_INVOICE_DATA_RMRP_EXPORT
    importing
      !IS_HEADERDATA type BAPI_INCINV_DETAIL_HEADER
      !IS_ITEMDATA type BAPI_INCINV_DETAIL_ITEM optional
      !IS_MATERIALDATA type BAPI_INCINV_DETAIL_MATERIAL optional
    returning
      value(RS_DATA) type MTY_EXPORT_SPEC_DATA .
  methods BUILD_INVOICE_DATA_RMRP_IHRAC
    importing
      !IS_HEADERDATA type BAPI_INCINV_DETAIL_HEADER
      !IS_ITEMDATA type BAPI_INCINV_DETAIL_ITEM optional
      !IS_MATERIALDATA type BAPI_INCINV_DETAIL_MATERIAL optional
    returning
      value(RV_HSCODE) type /ITETR/INV_E_HSCOD .
  methods EXIT_BEFORE_SEND_CHANGE_UBL .
  methods FILL_COMMON_TAX_YTB
    importing
      !IS_INVOICE_LINE type /ITETR/COM_INVOICE_LINE
      !IS_INVOICE_ITEMS type MTY_ITEM_COLLECT
      !IV_KALSM type KALSM_D
      !IS_ITEM_YTB type /ITETR/INV_YTB_I optional
    changing
      !CS_TAX_SUBTOTAL type /ITETR/COM_TAX_SUBTOTAL .
private section.
  methods RAISE_CUSTOM_ERROR
    importing
      !IV_TEXT type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION . "[MAI | 2026-08-20] Schematron kurallari icin serbest metinli hata (msgno 000)
  methods CHECK_IHRACKAYITLI_702_LINES
    importing
      !IV_INVOICE_TYPE_CODE type STRING
      !IV_EXEMPTION_REASON_CODE type STRING
      !IV_TOTAL_LINES type I
      !IV_MATCHING_LINES type I
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION . "[MAI | 2026-08-20] Schematron TaxExemptionReasonCodeCheck IHRACKAYITLI+702 alt kurali (madde 6)
  methods CHECK_ENERJI_PROFILE_TYPE
    importing
      !IV_PROFILE_ID type STRING
      !IV_INVOICE_TYPE_CODE type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION . "[MAI | 2026-08-20] Schematron InvoiceTypeCodeCheck ENERJI<->SARJ/SARJANLIK biconditional (madde 17)
ENDCLASS.



CLASS /ITETR/CL_OUTGOING_INVOICE IMPLEMENTATION.


  METHOD build_invoice_data.
    DATA: ls_delivery                 TYPE /itetr/com_delivery,
          lv_export_data              TYPE abap_bool,
          ls_shipment_stage           TYPE /itetr/com_shipment_stage,
          ls_delivery_terms           TYPE /itetr/com_delivery_terms,
          ls_invoice_line             TYPE /itetr/com_invoice_line,
          ls_goods_item               TYPE /itetr/com_goods_item,
          lx_exception                TYPE REF TO /itetr/cx_regulative_exception,
          ls_billing_ref              TYPE /itetr/com_billing_reference,
          ls_party_identification     TYPE /itetr/com_party_identificati1,
          ls_contract_document        TYPE /itetr/com_contract_document_r,
          lv_taxid                    TYPE string,
          lv_sevkiyat_no              TYPE string,
          ls_inv_taxp                 TYPE /itetr/inv_taxp,
          ls_inv_eicp                 TYPE /itetr/inv_eicp,
          lv_len                      TYPE i,
          lv_error_flag               TYPE char1,
          ls_commodity_classification TYPE /itetr/com_commodity_classifi1,
          ls_item_instance            TYPE /itetr/com_item_instance,
          lv_string                   TYPE string,
          lv_tax_code                 TYPE string,
          ls_add_doc_ref              TYPE /itetr/com_additional_document. "[MAI | 2026-08-20] Enerji/ESURaporID kontrolu

    DATA: lv_tabix            TYPE char4, "hkizilkaya
          ls_tax_subtotal     TYPE /itetr/com_tax_subtotal, "hkizilkaya
          ls_tax_total        TYPE /itetr/com_tax_total, "hkizilkaya
          ls_allowance_charge TYPE /itetr/com_allowance_charge, "hkizilkaya
          lv_barcode          TYPE string. "hkizilkaya

    FIELD-SYMBOLS: <ls_tax_total>          TYPE /itetr/com_tax_total,
                   <ls_tax_subtotal>       TYPE /itetr/com_tax_subtotal,
                   <ls_invoice_line>       TYPE /itetr/com_invoice_line,
                   <ls_allowance_charge>   TYPE /itetr/com_allowance_charge,
                   <ls_document_reference> TYPE /itetr/com_additional_document,
                   <ls_payment_means>      TYPE /itetr/com_payment_means.

    CASE ms_document-awtyp.
      WHEN 'BKPF' OR 'BKPFF' OR 'REACI' OR 'IDOC'.
        build_invoice_data_bkpf( ).
      WHEN 'RMRP'.
        build_invoice_data_rmrp( ).
      WHEN 'VBRK'.
        build_invoice_data_vbrk( ).
      WHEN 'FKKKO'.
        build_invoice_data_fica( ).
    ENDCASE.

    CONDENSE: ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-content,
              ms_invoice_ubl-part1-legal_monetary_total-charge_total_amount-base-content,
              ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content,
              ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content,
              ms_invoice_ubl-part1-legal_monetary_total-payable_rounding_amount-base-content,
              ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content,
              ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content.
    LOOP AT ms_invoice_ubl-part1-tax_total ASSIGNING <ls_tax_total>.
      CONDENSE: <ls_tax_total>-tax_amount-base-content.
      LOOP AT <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
        CONDENSE: <ls_tax_subtotal>-tax_amount-base-content,
                  <ls_tax_subtotal>-taxable_amount-base-content,
                  <ls_tax_subtotal>-per_unit_amount-base-content,
                  <ls_tax_subtotal>-percent-base-base-content.
      ENDLOOP.
    ENDLOOP.
    LOOP AT ms_invoice_ubl-part1-withholding_tax_total ASSIGNING <ls_tax_total>.
      CONDENSE: <ls_tax_total>-tax_amount-base-content.
      LOOP AT <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
        CONDENSE: <ls_tax_subtotal>-tax_amount-base-content,
                  <ls_tax_subtotal>-taxable_amount-base-content,
                  <ls_tax_subtotal>-per_unit_amount-base-content,
                  <ls_tax_subtotal>-percent-base-base-content.
      ENDLOOP.
    ENDLOOP.

    LOOP AT ms_invoice_ubl-part1-invoice_line ASSIGNING <ls_invoice_line>.
      CONDENSE: <ls_invoice_line>-tax_total-tax_amount-base-content.
      LOOP AT <ls_invoice_line>-tax_total-tax_subtotal ASSIGNING <ls_tax_subtotal>.
        CONDENSE: <ls_tax_subtotal>-tax_amount-base-content,
                  <ls_tax_subtotal>-taxable_amount-base-content,
                  <ls_tax_subtotal>-per_unit_amount-base-content,
                  <ls_tax_subtotal>-percent-base-base-content.
      ENDLOOP.
      LOOP AT <ls_invoice_line>-withholding_tax_total ASSIGNING <ls_tax_total>.
        CONDENSE: <ls_tax_total>-tax_amount-base-content.
        LOOP AT <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
          CONDENSE: <ls_tax_subtotal>-tax_amount-base-content,
                    <ls_tax_subtotal>-taxable_amount-base-content,
                    <ls_tax_subtotal>-per_unit_amount-base-content,
                    <ls_tax_subtotal>-percent-base-base-content.
        ENDLOOP.
      ENDLOOP.

      CONDENSE: <ls_invoice_line>-price-price_amount-base-content,
                <ls_invoice_line>-line_extension_amount-base-content,
                <ls_invoice_line>-invoiced_quantity-base-base-content.

      LOOP AT <ls_invoice_line>-allowance_charge ASSIGNING <ls_allowance_charge>.
        CONDENSE: <ls_allowance_charge>-amount-base-content,
                  <ls_allowance_charge>-base_amount-base-content,
                  <ls_allowance_charge>-multiplier_factor_numeric-base-base-content.
      ENDLOOP.
    ENDLOOP.

    "unvan guncelleme
    CLEAR:ls_inv_eicp.
    READ TABLE  mt_inv_eicp INTO ls_inv_eicp WITH KEY  cuspa = 'TRATITLE'.
    IF ls_inv_eicp-value EQ abap_false.
      CLEAR: ls_party_identification , lv_taxid, ls_inv_taxp .
      LOOP AT ms_invoice_ubl-part1-accounting_customer_party-party-party_identification INTO ls_party_identification
             WHERE id-base-base-scheme_id = 'TCKN' OR id-base-base-scheme_id = 'VKN'.
        EXIT.
      ENDLOOP.
      IF sy-subrc EQ 0.
        lv_taxid = ls_party_identification-id-base-base-content.
        IF lv_taxid IS NOT INITIAL.
          SELECT SINGLE title
            FROM /itetr/inv_taxp
            INTO CORRESPONDING FIELDS OF ls_inv_taxp
            WHERE taxid = lv_taxid
              AND regdt <= ms_document-bldat.
          IF sy-subrc EQ 0 AND ls_inv_taxp-title IS NOT INITIAL.
            SHIFT ls_inv_taxp-title LEFT DELETING LEADING space.
            IF strlen( lv_taxid ) = 11.
              SPLIT ls_inv_taxp-title
                    AT space
               INTO  ms_invoice_ubl-part1-accounting_customer_party-party-person-first_name-base-base-content
                     ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content.
              IF strlen( ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content ) < 2.
                CONCATENATE ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content '..' INTO ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content.
              ENDIF.
            ELSE.
              ms_invoice_ubl-part1-accounting_customer_party-party-party_name-name-base-base-content = ls_inv_taxp-title.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


    "VKN/TCKN kontrolu
    IF  mv_preview    IS INITIAL.
      CLEAR: ls_party_identification , lv_taxid.
      READ TABLE  mt_inv_eicp TRANSPORTING NO FIELDS WITH KEY cuspa = 'TAXID_CNTR'
                                                              value = abap_true.
      IF sy-subrc EQ 0.
        LOOP AT ms_invoice_ubl-part1-accounting_customer_party-party-party_identification INTO ls_party_identification
           WHERE id-base-base-scheme_id = 'TCKN' OR id-base-base-scheme_id = 'VKN'.
          EXIT.
        ENDLOOP.
        IF sy-subrc EQ 0.
          lv_taxid = ls_party_identification-id-base-base-content.
          IF lv_taxid  CO '0123456789'.
          ELSE.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '102'
                                                                             iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '102'
                                                                                                                                         iv_msgty = 'E'  ) ) .
            RAISE EXCEPTION lx_exception.

          ENDIF.

          IF strlen( lv_taxid ) NE 10 AND strlen( lv_taxid ) NE 11.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '103'
                                                                              iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '103'
                                                                                                                                          iv_msgty = 'E'  ) ) .
            RAISE EXCEPTION lx_exception.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


    IF  ( ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'IADE' OR
          ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'TEVKIFATIADE' OR
          ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBIADE' OR
          ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBTEVKIFATIADE' ) AND
          mv_preview             IS INITIAL .
      IF ms_invoice_ubl-part1-billing_reference[] IS INITIAL.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '117'
                                                                          iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '117'
                                                                                                                                       iv_msgty = 'E'  ) ) .
        RAISE EXCEPTION lx_exception.
      ELSE.
        LOOP AT ms_invoice_ubl-part1-billing_reference INTO ls_billing_ref.
          IF ls_billing_ref-invoice_document_reference-document_type_code-base-base-content = 'IADE'  OR
             ls_billing_ref-invoice_document_reference-document_type_code-base-base-content = 'İADE'.
            IF ls_billing_ref-invoice_document_reference-id-base-base-content    IS INITIAL OR
               ls_billing_ref-invoice_document_reference-issue_date-base-content IS INITIAL.
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '117'
                                                                                iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '117'
                                                                                                                                            iv_msgty = 'E'  ) ) .
              RAISE EXCEPTION lx_exception.
            ENDIF.
          ENDIF.
        ENDLOOP.

        LOOP AT ms_invoice_ubl-part1-billing_reference INTO ls_billing_ref .
          IF ls_billing_ref-invoice_document_reference-document_type_code-base-base-content = 'IADE'
          OR ls_billing_ref-invoice_document_reference-document_type_code-base-base-content = 'İADE'.
            lv_len = strlen(  ls_billing_ref-invoice_document_reference-id-base-base-content ).
            IF lv_len <> 16.
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '129'
                                                                                iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '129'
                                                                                                                                            iv_msgty = 'E'  ) ) .
              RAISE EXCEPTION lx_exception.
            ENDIF.
          ENDIF.
        ENDLOOP.


      ENDIF.
    ENDIF.

    "Yatırım tesvik kontrolleri
    IF  ms_invoice_ubl-part1-profile_id-base-base-content EQ 'YATIRIMTESVIK'  AND
        mv_preview             IS INITIAL  AND
      ( ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'IADE'         AND
        ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'SATIS'        AND
        ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'TEVKIFATIADE' AND
        ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'TEVKIFAT'     AND
        ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'ISTISNA' ) .

      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '132'
                                                                        iv_msgv1 = ms_invoice_ubl-part1-invoice_type_code-base-base-content
                                                                        iv_msgv2 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '132'
                                                                                                                                    iv_msgty = 'E'  ) ) .
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF  mv_preview             IS INITIAL  AND
     (  ms_invoice_ubl-part1-profile_id-base-base-content = 'YATIRIMTESVIK' OR
     ( ms_invoice_ubl-part1-profile_id-base-base-content = 'EARSIVFATURA' AND
     ( ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBSATIS'        OR
       ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBISTISNA'      OR
       ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBTEVKIFAT'     OR
       ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBTEVKIFATIADE' OR
       ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBIADE'    ) ) ).
      IF  ms_invoice_ubl-part1-contract_document_reference[] IS INITIAL.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '133'
                                                                          iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '133'
                                                                                                                                       iv_msgty = 'E'  ) ) .
        RAISE EXCEPTION lx_exception.
      ELSE.
        READ TABLE ms_invoice_ubl-part1-contract_document_reference
                                            TRANSPORTING NO FIELDS WITH KEY id-base-base-scheme_id = 'YTBNO'.
        IF sy-subrc <> 0.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '133'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '133'
                                                                                                                                        iv_msgty = 'E'  ) ) .
          RAISE EXCEPTION lx_exception.
        ENDIF.
        LOOP AT ms_invoice_ubl-part1-contract_document_reference INTO ls_contract_document
                                                                 WHERE id-base-base-scheme_id = 'YTBNO'.
          lv_string = ls_contract_document-id-base-base-content.
          lv_len = strlen(  ls_contract_document-id-base-base-content ).
          IF lv_len <> 6.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '143'
                                                                              iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '143'
                                                                                                                                          iv_msgty = 'E'  ) ) .
            RAISE EXCEPTION lx_exception.
          ELSE.
            IF  lv_string  CO '0123456789'.
            ELSE.
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '143'
                                                                                iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '143'
                                                                                                                                            iv_msgty = 'E'  ) ) .
              RAISE EXCEPTION lx_exception.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
        "ItemClassificationCode kontrol
        READ TABLE ls_invoice_line-item-commodity_classification TRANSPORTING NO FIELDS INDEX 1.
        IF sy-subrc <> 0.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '138'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '138'
                                                                                                                                        iv_msgty = 'E'  ) ) .
          RAISE EXCEPTION lx_exception.
        ELSE.
          LOOP AT ls_invoice_line-item-commodity_classification INTO ls_commodity_classification.
            IF ls_commodity_classification-item_classification_code-base-base-content EQ '01' OR
               ls_commodity_classification-item_classification_code-base-base-content EQ '02' OR
               ls_commodity_classification-item_classification_code-base-base-content EQ '03' OR
               ls_commodity_classification-item_classification_code-base-base-content EQ '04' .
              IF ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBISTISNA' OR
                 ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'ISTISNA' .
                IF  ls_commodity_classification-item_classification_code-base-base-content EQ '03' OR
                    ls_commodity_classification-item_classification_code-base-base-content EQ '04'.

                  lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '140'
                                                                                    iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '140'
                                                                                                                                                 iv_msgty = 'E'  ) ) .
                  RAISE EXCEPTION lx_exception.
                ENDIF.


                LOOP AT ls_invoice_line-tax_total-tax_subtotal TRANSPORTING NO FIELDS
                       WHERE calculation_sequence_numeric-base-base-content EQ '-1'.
                  EXIT.
                ENDLOOP.
                IF sy-subrc <> 0.
                  lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '144'
                                                                                    iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '144'
                                                                                                                                                iv_msgty = 'E'  ) ) .
                  RAISE EXCEPTION lx_exception.
                ENDIF.


                IF ls_commodity_classification-item_classification_code-base-base-content EQ '01'.
                  LOOP AT ls_invoice_line-tax_total-tax_subtotal TRANSPORTING NO FIELDS
                       WHERE tax_category-tax_exemption_reason_code-base-base-content EQ '308'.
                    EXIT.
                  ENDLOOP.
                  IF sy-subrc <> 0.
                    lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '142'
                                                                                      iv_msgv1 = '01'
                                                                                      iv_msgv2 = '308'
                                                                                      iv_msgv3 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '142'
                                                                                                                                                  iv_msgty = 'E'  ) ) .
                    RAISE EXCEPTION lx_exception.
                  ENDIF.

                ELSEIF ls_commodity_classification-item_classification_code-base-base-content EQ '02'.
                  LOOP AT ls_invoice_line-tax_total-tax_subtotal TRANSPORTING NO FIELDS
                           WHERE tax_category-tax_exemption_reason_code-base-base-content EQ '339'.
                    EXIT.
                  ENDLOOP.
                  IF sy-subrc <> 0.
                    lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '142'
                                                                                      iv_msgv1 = '02'
                                                                                      iv_msgv2 = '339'
                                                                                      iv_msgv3 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '142'
                                                                                                                                                  iv_msgty = 'E'  ) ) .
                    RAISE EXCEPTION lx_exception.
                  ENDIF.
                ENDIF.
              ENDIF.

              IF ls_commodity_classification-item_classification_code-base-base-content EQ '01'.
                IF ls_invoice_line-item-model_name-base-base-content IS INITIAL.
                  lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '141'
                                                                                    iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '141'
                                                                                                                                                iv_msgty = 'E'  ) ) .
                  RAISE EXCEPTION lx_exception.
                ENDIF.
                LOOP AT ls_invoice_line-item-item_instance TRANSPORTING NO FIELDS
                          WHERE serial_id-base-base-content IS INITIAL OR
                                product_trace_id-base-base-content IS INITIAL.
                  EXIT.
                ENDLOOP.
                IF sy-subrc EQ 0.
                  lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '141'
                                                                                    iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '141'
                                                                                                                                                iv_msgty = 'E'  ) ) .
                  RAISE EXCEPTION lx_exception.
                ENDIF.

              ENDIF.

            ELSE."gecersiz bir deger ise
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '139'
                                                                                iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '139'
                                                                                                                                            iv_msgty = 'E'  ) ) .
              RAISE EXCEPTION lx_exception.
            ENDIF.

          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDIF.


    "IDIS
    IF  ms_invoice_ubl-part1-profile_id-base-base-content EQ 'IDIS'    AND
        mv_preview        IS INITIAL.

      IF ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'IADE'         AND
         ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'SATIS'        AND
         ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'ISTISNA'      AND
         ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'TEVKIFATIADE' AND
         ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'TEVKIFAT'     AND
         ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'IHRACKAYITLI'   .

        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '134'
                                                                          iv_msgv1 = ms_document-invty
                                                                          iv_msgv2 = /itetr/cl_regulative_common=>message_text_build(  iv_msgno = '134'
                                                                                                                                       iv_msgty = 'E'  ) ).
        RAISE EXCEPTION lx_exception.
      ENDIF.

      "Sevkiyat no kontrol
      LOOP AT ms_invoice_ubl-part1-accounting_supplier_party-party-party_identification INTO ls_party_identification
       WHERE id-base-base-scheme_id = 'SEVKIYATNO'.
        EXIT.
      ENDLOOP.
      IF sy-subrc EQ 0.
        lv_sevkiyat_no  = ls_party_identification-id-base-base-content.
        lv_len = strlen(  lv_sevkiyat_no ).
        IF lv_len EQ 10.
          IF lv_sevkiyat_no+0(2) NE 'SE' AND lv_sevkiyat_no+0(2) NE 'ES'. "[MAI | 2026-08-20] Schematron IdisSevkiyatNoCheck: ES- oneki de gecerli
            lv_error_flag = abap_true.
          ELSEIF lv_sevkiyat_no+2(1) NE '-'.
            lv_error_flag = abap_true.
          ENDIF.

          IF  lv_sevkiyat_no+3(7) CO '0123456789'.
          ELSE.
            lv_error_flag = abap_true.
          ENDIF.

          IF lv_error_flag EQ  abap_true.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '137'
                                                                              iv_msgv1 = /itetr/cl_regulative_common=>message_text_build(  iv_msgno = '137'
                                                                                                                                           iv_msgty = 'E'  ) ).
            RAISE EXCEPTION lx_exception.

          ENDIF.

        ELSE.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '136'
                                                                            iv_msgv1 = lv_sevkiyat_no
                                                                            iv_msgv2 = /itetr/cl_regulative_common=>message_text_build(  iv_msgno = '136'
                                                                                                                                         iv_msgty = 'E'  ) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.

      ELSE.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '135'
                                                                          iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '135'
                                                                                                                                      iv_msgty = 'E'  ) ) .

        RAISE EXCEPTION lx_exception.
      ENDIF.
    ENDIF.

    "ENERJI (SARJ/SARJANLIK) fatura kontrolleri [MAI | 2026-08-20]
    "Schematron: EnerjiInvoicePeriodCheck, EnerjiPartyIdentificationPlakaCheck,
    "            EnerjiESURaporIDCheck, EnerjiItemInstanceSerialIDCheck
    IF mv_preview IS INITIAL AND
       ( ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'SARJ' OR
         ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'SARJANLIK' ).

      "EnerjiInvoicePeriodCheck
      IF ms_invoice_ubl-part1-invoice_period-start_date-base-content IS INITIAL OR
         ms_invoice_ubl-part1-invoice_period-start_time-base-content IS INITIAL OR
         ms_invoice_ubl-part1-invoice_period-end_date-base-content   IS INITIAL OR
         ms_invoice_ubl-part1-invoice_period-end_time-base-content   IS INITIAL.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '155'
                                                                          iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '155'
                                                                                                                                      iv_msgty = 'E'  ) ) .
        RAISE EXCEPTION lx_exception.
      ENDIF.

      "EnerjiPartyIdentificationPlakaCheck
      CLEAR ls_party_identification.
      LOOP AT ms_invoice_ubl-part1-accounting_customer_party-party-party_identification INTO ls_party_identification
             WHERE id-base-base-scheme_id = 'PLAKA'.
        EXIT.
      ENDLOOP.
      IF sy-subrc NE 0.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '156'
                                                                          iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '156'
                                                                                                                                      iv_msgty = 'E'  ) ) .
        RAISE EXCEPTION lx_exception.
      ELSE.
        lv_string = ls_party_identification-id-base-base-content.
        IF lv_string IS INITIAL OR strlen( lv_string ) > 50 OR
           NOT matches( val = lv_string regex = '^[A-Z0-9_-]+$' ).
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '157'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '157'
                                                                                                                                        iv_msgty = 'E'  ) ) .
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDIF.

      "EnerjiESURaporIDCheck
      IF ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'SARJ'.
        CLEAR ls_add_doc_ref.
        LOOP AT ms_invoice_ubl-part1-additional_document_reference INTO ls_add_doc_ref
               WHERE id-base-base-scheme_id = 'ESURaporID'.
          EXIT.
        ENDLOOP.
        IF sy-subrc NE 0
        OR ls_add_doc_ref-id-base-base-content IS INITIAL
        OR NOT matches( val = ls_add_doc_ref-id-base-base-content
                     regex = '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$' )
        OR ls_add_doc_ref-issue_date-base-content IS INITIAL
        OR NOT matches( val = ls_add_doc_ref-issue_date-base-content regex = '^20\d{2}-\d{2}-\d{2}$' ).
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '158'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '158'
                                                                                                                                        iv_msgty = 'E'  ) ) .
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDIF.

      "EnerjiItemInstanceSerialIDCheck [MAI | 2026-08-26] 14 Eylul plani: SARJ da dahil edildi
      IF ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'SARJ' OR
         ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'SARJANLIK'.
        CLEAR lv_error_flag.
        LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
          LOOP AT ls_invoice_line-item-item_instance INTO ls_item_instance
                 WHERE serial_id-base-base-content IS NOT INITIAL.
            lv_error_flag = abap_true.
            EXIT.
          ENDLOOP.
          IF lv_error_flag EQ abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF lv_error_flag NE abap_true.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '159'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '159'
                                                                                                                                        iv_msgty = 'E'  ) ) .
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDIF.
    ENDIF.

    "TaxExemptionReasonCodeCheck (genel bicimsel kural) [MAI | 2026-08-20]
    "Schematron madde 6: TaxExemptionReason doluysa TaxExemptionReasonCode de dolu olmalidir.
    "NOT: GIB'in tam kod listeleri (TaxExemptionReasonCodeType, YatirimTesvikTaxExemptionReasonCodeType,
    "istisnaTaxExemptionReasonCodeType, ozelMatrahTaxExemptionReasonCodeType, ihracExemptionReasonCodeType)
    "ve IHRACKAYITLI+702 GTIP/AliciSatirKodu alt kurali bu dokumanda deger listesi olarak verilmedigi icin
    "burada uygulanmamistir; kod listeleri netlesince genisletilmelidir.
    IF mv_preview IS INITIAL AND ms_invoice_ubl-part1-ublversion_id-base-base-content = '2.1'.
      LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
        LOOP AT ls_invoice_line-tax_total-tax_subtotal INTO ls_tax_subtotal.
          IF ls_tax_subtotal-tax_category-tax_exemption_reason-base-base-content IS NOT INITIAL
          AND ls_tax_subtotal-tax_category-tax_exemption_reason_code-base-base-content IS INITIAL.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '160'
                                                                              iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '160'
                                                                                                                                          iv_msgty = 'E'  ) ) .
            RAISE EXCEPTION lx_exception.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    "TaxExemptionReasonCodeCheck - kategori kod listeleri yerine "bos/dolu" + birlesim kume yaklasimi [MAI | 2026-08-24]
    "Schematron madde 6/11-13: TaxExemptionReasonCode istisna/ozelMatrah/ihracKayitli kategori kod
    "listelerinden birindeyse fatura tipi o kategoriye ozgu bir kume ile sinirlaniyor. GIB'in bu 3
    "kategoriye ait numerik kod listeleri (istisnaTaxExemptionReasonCodeType, ozelMatrahTaxExemptionReasonCodeType,
    "ihracExemptionReasonCodeType) repo'da olmadigi icin "kod hangi kategoride" ayrimi yapilamiyor.
    "YAKLASIM: Deger/kod listesi eslestirmesi yerine sadece "kod DOLU mu" (bos/dolu) kontrolu yapiliyor -
    "TaxExemptionReasonCode doluysa (ve '555' haric, v2 rehberine gore 555 istisna kategorisinden
    "muaf tutuluyor), fatura tipi 3 kategorinin birlesim kumesinde olmali: ISTISNA, IADE, IHRACKAYITLI,
    "SGK, YTBISTISNA, YTBIADE, OZELMATRAH. Bu, tam kategori bazli kontrolden daha gevsek (superset) bir
    "kontroldur ama kod listeleri gelmeden SATIS gibi tamamen ilgisiz fatura tiplerinde muafiyet kodu
    "kullanimini yakalar.
    IF mv_preview IS INITIAL AND ms_invoice_ubl-part1-ublversion_id-base-base-content = '2.1'.
      LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
        LOOP AT ls_invoice_line-tax_total-tax_subtotal INTO ls_tax_subtotal.
          lv_string = ls_tax_subtotal-tax_category-tax_exemption_reason_code-base-base-content.
          IF lv_string IS NOT INITIAL AND lv_string NE '555'.
            IF ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'ISTISNA'      AND
               ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'IADE'         AND
               ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'IHRACKAYITLI' AND
               ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'SGK'          AND
               ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'YTBISTISNA'   AND
               ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'YTBIADE'      AND
               ms_invoice_ubl-part1-invoice_type_code-base-base-content NE 'OZELMATRAH'.
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '154'
                                                                                iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '154'
                                                                                                                                            iv_msgty = 'E'  ) ) .
              RAISE EXCEPTION lx_exception.
            ENDIF.
          ENDIF.

          "[MAI | 2026-08-26] 14 Eylul plani madde 7: 308/339 muafiyet kodlari sadece YATIRIMTESVIK
          "profilinde (veya EARSIVFATURA + YTB* fatura tiplerinde) kullanilabilir.
          IF lv_string = '308' OR lv_string = '339'.
            IF NOT ( ms_invoice_ubl-part1-profile_id-base-base-content = 'YATIRIMTESVIK' OR
                   ( ms_invoice_ubl-part1-profile_id-base-base-content = 'EARSIVFATURA' AND
                   ( ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBSATIS'        OR
                     ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBISTISNA'      OR
                     ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBTEVKIFAT'     OR
                     ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBTEVKIFATIADE' OR
                     ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'YTBIADE' ) ) ).
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '161'
                                                                                iv_msgv1 = lv_string ).
              RAISE EXCEPTION lx_exception.
            ENDIF.
            lv_string = ls_tax_subtotal-tax_category-tax_exemption_reason_code-base-base-content.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    "InvoiceTypeCodeCheck: IADE <-> ProfileID kisiti [MAI | 2026-08-20]
    "Schematron madde 17: IADE tipi sadece TEMELFATURA/EARSIVFATURA/ILAC_TIBBICIHAZ/YATIRIMTESVIK/IDIS/KAMU profillerinde olabilir.
    IF mv_preview IS INITIAL AND
       ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'IADE' AND
       ms_invoice_ubl-part1-profile_id-base-base-content NE 'TEMELFATURA'    AND
       ms_invoice_ubl-part1-profile_id-base-base-content NE 'EARSIVFATURA'   AND
       ms_invoice_ubl-part1-profile_id-base-base-content NE 'ILAC_TIBBICIHAZ' AND
       ms_invoice_ubl-part1-profile_id-base-base-content NE 'YATIRIMTESVIK'  AND
       ms_invoice_ubl-part1-profile_id-base-base-content NE 'IDIS'           AND
       ms_invoice_ubl-part1-profile_id-base-base-content NE 'KAMU'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '162'
                                                                        iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '162'
                                                                                                                                    iv_msgty = 'E'  ) ) .
      RAISE EXCEPTION lx_exception.
    ENDIF.

    "InvoiceTypeCodeCheck: TEKNOLOJIDESTEK <-> ProfileID kisiti [MAI | 2026-08-24]
    "Schematron rehberi v2 (schematron_rehberi-v2.pdf, madde 17): Fatura Tipi = TEKNOLOJIDESTEK ise
    "Fatura Profili (ProfileID) sadece ve sadece EARSIVFATURA olabilir.
    IF mv_preview IS INITIAL AND
       ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'TEKNOLOJIDESTEK' AND
       ms_invoice_ubl-part1-profile_id-base-base-content NE 'EARSIVFATURA'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '153'
                                                                        iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '153'
                                                                                                                                    iv_msgty = 'E'  ) ) .
      RAISE EXCEPTION lx_exception.
    ENDIF.

    "InvoiceTypeCodeCheck: ENERJI <-> SARJ/SARJANLIK biconditional [MAI | 2026-08-20]
    "Schematron madde 17: ProfileID='ENERJI' <=> InvoiceTypeCode IN ('SARJ','SARJANLIK').
    "KULLANICI KARARI (2026-08-20): Bu kontrol HENUZ CAGRILMIYOR (bilincli olarak devre disi).
    "Sistemde SARJ/SARJANLIK faturalari icin ProfileID'nin 'ENERJI' olarak set edildigi baska
    "bir yerde teyit edilemedi (kod taramasinda bulunamadi) - veri kaynagi netlesmeden aktif
    "edilmeyecek, aksi halde mevcut SARJ/SARJANLIK faturalarini hataya dusurme riski var.
    "Aktif etmek icin: asagidaki IF blogunu geri getirin.
    "IF mv_preview IS INITIAL.
    "  check_enerji_profile_type(
    "    iv_profile_id         = ms_invoice_ubl-part1-profile_id-base-base-content
    "    iv_invoice_type_code  = ms_invoice_ubl-part1-invoice_type_code-base-base-content ).
    "ENDIF.

    "kamu fatura kontrol
    IF ms_invoice_ubl-part1-profile_id-base-base-content EQ 'KAMU' AND ms_invoice_ubl-part1-payment_means[] IS NOT INITIAL.
      LOOP AT ms_invoice_ubl-part1-payment_means ASSIGNING <ls_payment_means>.
        IF <ls_payment_means>-payee_financial_account-id-base-base-content IS INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '098'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '098'
                                                                                                                                        iv_msgty = 'E'  ) ) .
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDLOOP.
    ENDIF.

    "gonderim fonk. kontroller buraya tasınmıstır
    IF mv_preview    IS INITIAL .
      IF ( ms_document-fwste IS INITIAL OR ms_document-texex IS NOT INITIAL ) AND
           ms_document-taxex IS INITIAL AND
           ( ms_document-prfid <> 'MUSTAHSIL' OR ms_document-prfid <> 'YATIRIMTES' )
           .
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '039'
                                                                          iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '039'
                                                                                                                                      iv_msgty = 'E'  ) ) .
        RAISE EXCEPTION lx_exception.
      ELSEIF ms_invoice_ubl-part1-invoice_type_code-base-base-content EQ 'TEVKIFAT' AND ms_document-taxty IS INITIAL.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '075'
                                                                          iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '075'
                                                                                                                                      iv_msgty = 'E'  ) ) .
        RAISE EXCEPTION lx_exception.
      ENDIF.
    ENDIF.
    "gonderim fonk. kontroller buraya tasınmıstır



    IF ms_invoice_ubl-part1-profile_id-base-base-content IS INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '021'
                                                                        iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '021'
                                                                                                                                    iv_msgty = 'E'  ) ) .
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-invoice_type_code-base-base-content IS INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '022'
                                                                        iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '022'
                                                                                                                                    iv_msgty = 'E'  ) ) .
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-tax_total IS INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '057'
                                                                        iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '057'
                                                                                                                                    iv_msgty = 'E'  ) ) .
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-profile_id-base-base-content = 'IHRACAT'.
      READ TABLE ms_invoice_ubl-part1-delivery INTO ls_delivery INDEX 1.
      IF sy-subrc IS INITIAL.
        lv_export_data = abap_true.
        IF ls_delivery-delivery_address IS INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '026'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>get_data_element_text( iv_data_element = 'KUNWE' ) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.

*        READ TABLE ls_delivery-shipment-shipment_stage INTO ls_shipment_stage INDEX 1.
*        IF sy-subrc IS NOT INITIAL OR ls_shipment_stage-transport_mode_code-base-base-content IS INITIAL.
*          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '026'
*                                                                            iv_msgv1 = /itetr/cl_regulative_common=>get_data_element_text( iv_data_element = '/ITETR/COM_E_TRNTY' ) ).
*          RAISE EXCEPTION lx_exception.
*        ENDIF.

        READ TABLE ls_delivery-delivery_terms INTO ls_delivery_terms INDEX 1.
        IF sy-subrc IS NOT INITIAL OR ls_delivery_terms-id-base-base-content IS INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '026'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>get_data_element_text( iv_data_element = 'INCO1' ) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDIF.

      LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
        READ TABLE ls_invoice_line-delivery INTO ls_delivery INDEX 1.
        IF lv_export_data IS INITIAL.
          IF sy-subrc IS NOT INITIAL OR ls_delivery-delivery_address IS INITIAL.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '026'
                                                                              iv_msgv1 = /itetr/cl_regulative_common=>get_data_element_text( iv_data_element = 'KUNWE' ) ).
            RAISE EXCEPTION lx_exception.
          ENDIF.

          READ TABLE ls_delivery-shipment-shipment_stage INTO ls_shipment_stage INDEX 1.
          IF sy-subrc IS NOT INITIAL OR ls_shipment_stage-transport_mode_code-base-base-content IS INITIAL.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '026'
                                                                              iv_msgv1 = /itetr/cl_regulative_common=>get_data_element_text( iv_data_element = '/ITETR/COM_E_TRNTY' ) ).
            RAISE EXCEPTION lx_exception.
          ENDIF.

          READ TABLE ls_delivery-delivery_terms INTO ls_delivery_terms INDEX 1.
          IF sy-subrc IS NOT INITIAL OR ls_delivery_terms-id-base-base-content IS INITIAL.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '026'
                                                                              iv_msgv1 = /itetr/cl_regulative_common=>get_data_element_text( iv_data_element = 'INCO1' ) ).
            RAISE EXCEPTION lx_exception.
          ENDIF.
        ENDIF.

        READ TABLE ls_delivery-shipment-goods_item INTO ls_goods_item INDEX 1.
        IF sy-subrc IS NOT INITIAL OR ls_goods_item-required_customs_id-base-base-content IS INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '026'
                                                                            iv_msgv1 = /itetr/cl_regulative_common=>get_data_element_text( iv_data_element = '/ITETR/INV_E_HSCOD' ) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " <--- hkizilkaya
    "INVOICE LINE *************************************************************************************************************************************************
    LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
      lv_tabix = sy-tabix.
      IF ls_invoice_line-line_extension_amount-base-content < 0.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '077'
                                                                          iv_msgv1 = lv_tabix
                                                                          iv_msgv2 = 'line->line_extension_amount' ). "TEXT-005 ).
        RAISE EXCEPTION lx_exception.
      ENDIF.
      LOOP AT ls_invoice_line-allowance_charge INTO ls_allowance_charge.
        IF ls_allowance_charge-amount-base-content < 0.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '077'
                                                                            iv_msgv1 = lv_tabix
                                                                            iv_msgv2 = 'line->allowance_charge_amount' ). "TEXT-006 ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDLOOP.

      IF ls_invoice_line-tax_total-tax_amount-base-content < 0.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '077'
                                                                          iv_msgv1 = lv_tabix
                                                                          iv_msgv2 = 'line->tax_total->tax_amount' )."TEXT-007 ).
        RAISE EXCEPTION lx_exception.
      ENDIF.
      LOOP AT ls_invoice_line-tax_total-tax_subtotal INTO ls_tax_subtotal.
        IF ls_tax_subtotal-taxable_amount-base-content < 0.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '077'
                                                                            iv_msgv1 = lv_tabix
                                                                            iv_msgv2 = 'line->tax subtotal->taxable_amount' ). "TEXT-008 ).
          RAISE EXCEPTION lx_exception.
        ENDIF.

        IF ls_tax_subtotal-tax_amount-base-content < 0.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '077'
                                                                            iv_msgv1 = lv_tabix
                                                                            iv_msgv2 = 'line->tax_subtotal->tax_amount' ). "TEXT-009 ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDLOOP.

      IF ls_invoice_line-price-price_amount-base-content < 0.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '077'
                                                                          iv_msgv1 = lv_tabix
                                                                          iv_msgv2 = 'line->price->price_amount' ). "TEXT-010 ).
        RAISE EXCEPTION lx_exception.
      ENDIF.

      "yatırım tesvik kontrol
      IF mv_preview    IS INITIAL.
        LOOP AT ls_invoice_line-tax_total-tax_subtotal INTO ls_tax_subtotal
           WHERE tax_category-tax_exemption_reason_code-base-base-content EQ '339' OR
                 tax_category-tax_exemption_reason_code-base-base-content EQ '308'.
          lv_tax_code = ls_tax_subtotal-tax_category-tax_exemption_reason_code-base-base-content.
          EXIT.
        ENDLOOP.
        IF sy-subrc EQ 0.
          IF ( ms_invoice_ubl-part1-profile_id-base-base-content EQ 'YATIRIMTESVIK' AND
              ms_invoice_ubl-part1-invoice_type_code-base-base-content EQ 'ISTISNA'  ) OR
            ( ms_invoice_ubl-part1-profile_id-base-base-content EQ 'EARSIVFATURA' AND
              ms_invoice_ubl-part1-invoice_type_code-base-base-content EQ 'YTBISTISNA'  ).
          ELSE.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '145'
                                                                              iv_msgv1 = lv_tax_code
                                                                              iv_msgv2 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '145'
                                                                                                                                          iv_msgty = 'E'  ) ) .
            RAISE EXCEPTION lx_exception.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    "LEGAL MONETARY TOTAL *************************************************************************************************************************************
    IF ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content < 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                        iv_msgv1 = 'legal->line_extension_amount'). "TEXT-011 ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content < 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                        iv_msgv1 = 'legal->tax_exclusive_amount'). "TEXT-012 ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content < 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                        iv_msgv1 = 'legal->tax_inclusive_amount')." TEXT-013 ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-content < 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                        iv_msgv1 = 'legal->allowance_total_amount' ). "TEXT-014 ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-legal_monetary_total-charge_total_amount-base-content < 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                        iv_msgv1 = 'legal->charge_total_amount' )."TEXT-015 ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-legal_monetary_total-payable_rounding_amount-base-content < 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                        iv_msgv1 = 'legal->payable_rounding_amount' ). "TEXT-016 ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content < 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                        iv_msgv1 = 'legal->payable_amount' ). "TEXT-017 ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    "TAX TOTAL **************************************************************************************************************************************************
    LOOP AT ms_invoice_ubl-part1-tax_total INTO ls_tax_total.
      IF ls_tax_total-tax_amount-base-content < 0.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                          iv_msgv1 = 'tax_total->tax_amount' )."TEXT-018 ).
        RAISE EXCEPTION lx_exception.
      ENDIF.

      LOOP AT ls_tax_total-tax_subtotal INTO ls_tax_subtotal.
        IF ls_tax_subtotal-taxable_amount-base-content < 0.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                            iv_msgv1 = 'tax_total->tax_amount->taxable_amount' ). "TEXT-019 ).
          RAISE EXCEPTION lx_exception.
        ENDIF.

        IF ls_tax_subtotal-tax_amount-base-content < 0.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '076'
                                                                            iv_msgv1 = 'tax_total->tax_subtotal->tax_amount')."TEXT-020 ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    " hkizilkaya --->

    IF mv_preview IS INITIAL AND mv_generate_invoice_id IS NOT INITIAL AND ms_document-invno IS INITIAL.
      IF ms_document-serpr IS INITIAL.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( '029' ).
        RAISE EXCEPTION lx_exception.
      ENDIF.
      generate_invoice_id( ).
      ms_invoice_ubl-part1-id-base-base-content = ms_document-invno.
      ev_invoice_no = ms_document-invno.
    ELSEIF mv_generate_invoice_id IS NOT INITIAL AND ms_document-invno IS NOT INITIAL.
      ms_invoice_ubl-part1-id-base-base-content = ms_document-invno.
      ev_invoice_no = ms_document-invno.
    ENDIF.


    IF mv_barcode IS NOT INITIAL AND ms_document-prfid NE 'MUSTAHSIL'.
      IF ms_document-prfid NE 'EARSIV'.
        get_einvoice_barcode(
        RECEIVING
        iv_barcode = lv_barcode ).
      ELSE.
        get_earchive_barcode(
        RECEIVING
        iv_barcode = lv_barcode ).
      ENDIF.

      IF lv_barcode IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-additional_document_reference ASSIGNING <ls_document_reference>.
        <ls_document_reference>-id-base-base-content = ms_document-docui.
        CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
          INTO <ls_document_reference>-issue_date-base-content
          SEPARATED BY '-'.
        <ls_document_reference>-document_type-base-base-content = 'BARCODE'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-mime_code = 'image/jpeg'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-encoding_code = 'Base64'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-character_set_code = 'UTF-8'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-filename = 'barcode.jpeg'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-content = lv_barcode.
      ENDIF.
    ENDIF.

    exit_before_send_change_ubl( ).

    invoice_abap_to_ubl( ).
    ev_invoice_hash = mv_invoice_hash.
    ev_invoice_ubl = mv_invoice_ubl.
    es_invoice_ubl = ms_invoice_ubl.
    et_custom_parameters[] = mt_custom_parameters[].

  ENDMETHOD.


  METHOD build_invoice_data_bkpf.
    ms_accdoc_data = get_data_bkpf( iv_bukrs = ms_document-bukrs
                                        iv_belnr = ms_document-belnr
                                        iv_gjahr = ms_document-gjahr ).
    IF ms_accdoc_data-bseg_partner-dmbtr IS NOT INITIAL AND ms_accdoc_data-bseg_partner-wrbtr IS INITIAL.
      ms_accdoc_data-bkpf-waers = ms_accdoc_data-bkpf-hwaer.
      ms_accdoc_data-bseg_partner-wrbtr = ms_accdoc_data-bseg_partner-dmbtr.
    ENDIF.
    build_invoice_data_bkpf_head( ).
    build_invoice_data_bkpf_party( ).
    build_invoice_data_bkpf_item( ).
    build_invoice_data_bkpf_totals( ).
    build_invoice_data_bkpf_notes( ).
    fill_common_invoice_data( ).
  ENDMETHOD.


  METHOD build_invoice_data_bkpf_head.
    DATA: ls_payment_terms TYPE faede.
    CONCATENATE ms_accdoc_data-bkpf-bldat+0(4)
                ms_accdoc_data-bkpf-bldat+4(2)
                ms_accdoc_data-bkpf-bldat+6(2)
      INTO ms_invoice_ubl-part1-issue_date-base-content
      SEPARATED BY '-'.
    ms_invoice_ubl-part1-document_currency_code-base-base-content = ms_accdoc_data-bkpf-waers.

    IF ms_accdoc_data-bkpf-waers NE ms_accdoc_data-bkpf-hwaer.
      ms_invoice_ubl-part1-pricing_exchange_rate-source_currency_code-base-base-content = ms_accdoc_data-bkpf-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-target_currency_code-base-base-content = ms_accdoc_data-bkpf-hwaer.
      ms_invoice_ubl-part1-pricing_exchange_rate-calculation_rate-base-base-content = ms_accdoc_data-bkpf-kursf.
      CONDENSE ms_invoice_ubl-part1-pricing_exchange_rate-calculation_rate-base-base-content.
      ms_invoice_ubl-part1-pricing_exchange_rate-date-base-content = ms_invoice_ubl-part1-issue_date-base-content.
      ms_invoice_ubl-part1-pricing_currency_code-base-base-content = ms_accdoc_data-bkpf-waers.
    ENDIF.

    ls_payment_terms-shkzg = ms_accdoc_data-bseg_partner-shkzg.
    ls_payment_terms-koart = ms_accdoc_data-bseg_partner-koart.
    ls_payment_terms-zfbdt = ms_accdoc_data-bseg_partner-zfbdt.
    ls_payment_terms-zbd1t = ms_accdoc_data-bseg_partner-zbd1t.
    ls_payment_terms-zbd2t = ms_accdoc_data-bseg_partner-zbd2t.
    ls_payment_terms-zbd3t = ms_accdoc_data-bseg_partner-zbd3t.
    ls_payment_terms-bldat = ms_accdoc_data-bkpf-bldat.
    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        i_faede                    = ls_payment_terms
      IMPORTING
        e_faede                    = ls_payment_terms
      EXCEPTIONS
        account_type_not_supported = 1
        OTHERS                     = 2.
    IF sy-subrc IS INITIAL AND ls_payment_terms-netdt IS NOT INITIAL AND ls_payment_terms-netdt NE ms_accdoc_data-bkpf-bldat.
      CONCATENATE ls_payment_terms-netdt+0(4)
                  ls_payment_terms-netdt+4(2)
                  ls_payment_terms-netdt+6(2)
        INTO ms_invoice_ubl-part1-payment_terms-payment_due_date-base-content
        SEPARATED BY '-'.
    ENDIF.
  ENDMETHOD.


  METHOD build_invoice_data_bkpf_item.
    DATA: ls_t005 TYPE t005.
    collect_items_bkpf( ).
    READ TABLE ms_accdoc_data-t005
      INTO ls_t005
      WITH TABLE KEY land1 = ms_accdoc_data-t001-land1.
    build_invoice_data_common_item( ls_t005-kalsm ).
  ENDMETHOD.


  METHOD build_invoice_data_bkpf_notes.
    DATA: ls_texts         TYPE /itetr/cl_outgoing_invoice=>mty_texts,
          ls_tline         TYPE tline,
          ls_eirule_input  TYPE /itetr/inv_s_eirules_in, "hkizilkaya
          lt_eirule_output TYPE /itetr/inv_tt_eirules_out, "hkizilkaya
          ls_eirule_output TYPE /itetr/inv_s_eirules_out, "hkizilkaya
          ls_earule_input  TYPE /itetr/inv_s_earules_in, "hkizilkaya
          lt_earule_output TYPE /itetr/inv_tt_earules_out, "hkizilkaya
          ls_earule_output TYPE /itetr/inv_s_earules_out. "hkizilkaya

    FIELD-SYMBOLS: <ls_invoice_note> TYPE /itetr/com_note.
    LOOP AT ms_accdoc_data-texts INTO ls_texts.
      LOOP AT ls_texts-tline INTO ls_tline.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_tline-tdline.
      ENDLOOP.
    ENDLOOP.

    " <--- hkizilkaya
    ls_eirule_input-agent = ms_document-agent.
    ls_eirule_input-awtyp = ms_document-awtyp.
    ls_eirule_input-vtweg = ms_document-vtweg.
    ls_eirule_input-werks = ms_document-werks.
    ls_eirule_input-fidty = ms_accdoc_data-bkpf-blart.
    ls_eirule_input-kunnr = ms_document-kunnr.
    ls_eirule_input-lifnr = ms_document-lifnr.
    ls_eirule_input-ityin = ms_document-invty.
    ls_eirule_input-pidin = ms_document-prfid.

    IF ms_document-prfid NE 'EARSIV'.
      get_einvoice_rule(
        EXPORTING
          iv_rule_type   = 'N'                 " Fatura kural tipi
          is_rule_input  = ls_eirule_input     " e-Fatura kural giriş
        RECEIVING
          rt_rule_output = lt_eirule_output    " e-Fatura kural çıkış
      ).
      LOOP AT lt_eirule_output INTO ls_eirule_output.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_eirule_output-note.
      ENDLOOP.
    ELSE.
      MOVE-CORRESPONDING ls_eirule_input TO ls_earule_input.
      get_earchive_rule(
        EXPORTING
          iv_rule_type   = 'N'                 " Fatura kural tipi
          is_rule_input  = ls_earule_input     " e-Arşiv kural giriş
        RECEIVING
          rt_rule_output = lt_earule_output    " e-Arşiv kural çıkışı table type
      ).
      LOOP AT lt_earule_output INTO ls_earule_output.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_earule_output-note.
      ENDLOOP.
    ENDIF.
    " hkizilkaya --->
  ENDMETHOD.


  METHOD build_invoice_data_bkpf_party.
    DATA: ls_t005t  TYPE t005t,
          ls_t005u  TYPE t005u,
          lv_person TYPE abap_bool.
    FIELD-SYMBOLS: <ls_identification> TYPE /itetr/com_party_identificati1.
    IF ms_accdoc_data-bsec IS NOT INITIAL.
      ms_invoice_ubl-part1-accounting_customer_party-party-postal_address-street_name-base-base-content = ms_accdoc_data-bsec-stras .
      ms_invoice_ubl-part1-accounting_customer_party-party-postal_address-postal_zone-base-base-content = ms_accdoc_data-bsec-pstlz.
      IF ms_accdoc_data-bsec-land1 IS NOT INITIAL.
        READ TABLE ms_accdoc_data-t005t
          INTO ls_t005t
          WITH TABLE KEY land1 = ms_accdoc_data-bsec-land1.
        IF sy-subrc IS INITIAL.
          ms_invoice_ubl-part1-accounting_customer_party-party-postal_address-country-name-base-base-content = ls_t005t-landx.
          mv_country = ms_accdoc_data-bsec-land1."gkadioglu
        ENDIF.
      ENDIF.
      IF ms_accdoc_data-bsec-regio IS NOT INITIAL.
        READ TABLE ms_accdoc_data-t005u
          INTO ls_t005u
          WITH TABLE KEY land1 = ms_accdoc_data-bsec-land1
                         bland = ms_accdoc_data-bsec-regio.
        IF sy-subrc = 0.
          ms_invoice_ubl-part1-accounting_customer_party-party-postal_address-city_name-base-base-content = ls_t005u-bezei.
        ENDIF.
      ELSEIF ms_accdoc_data-bsec-ort01 IS NOT INITIAL.
        ms_invoice_ubl-part1-accounting_customer_party-party-postal_address-city_name-base-base-content = ms_accdoc_data-bsec-ort01.
      ENDIF.
      ms_invoice_ubl-part1-accounting_customer_party-party-postal_address-city_subdivision_name-base-base-content = ms_accdoc_data-bsec-ort01.
      ms_invoice_ubl-part1-accounting_customer_party-party-party_tax_scheme-tax_scheme-name-base-base-content = ms_accdoc_data-bsec-stcd1.

      IF strlen( ms_accdoc_data-bsec-stcd2 ) = 11 .
        lv_person = abap_true.
        ms_invoice_ubl-part1-accounting_customer_party-party-person-first_name-base-base-content = ms_accdoc_data-bsec-name1.
        ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content = ms_accdoc_data-bsec-name2.
        IF ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content IS INITIAL.
          SPLIT ms_accdoc_data-bsec-name1
            AT space
            INTO ms_invoice_ubl-part1-accounting_customer_party-party-person-first_name-base-base-content
                 ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content.
        ENDIF.
        IF ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content IS INITIAL.
          ms_invoice_ubl-part1-accounting_customer_party-party-person-first_name-base-base-content = ms_accdoc_data-bsec-name1.
          ms_invoice_ubl-part1-accounting_customer_party-party-person-family_name-base-base-content = '...'.
        ENDIF.
        ms_invoice_ubl-part1-accounting_customer_party-party-person-nationality_id-base-base-content = ms_accdoc_data-bsec-land1.
      ELSE.
        CONCATENATE ms_accdoc_data-bsec-name1
                    ms_accdoc_data-bsec-name2
          INTO ms_invoice_ubl-part1-accounting_customer_party-party-party_name-name-base-base-content
          SEPARATED BY space.
      ENDIF.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-accounting_customer_party-party-party_identification ASSIGNING <ls_identification>.
      IF ms_accdoc_data-bsec-stcd2 IS NOT INITIAL.
        <ls_identification>-id-base-base-content = ms_accdoc_data-bsec-stcd2.
      ELSEIF lv_person = abap_true.
        <ls_identification>-id-base-base-content = '11111111111'.
      ELSE.
        <ls_identification>-id-base-base-content = '1111111111'.
      ENDIF.
      IF strlen( <ls_identification>-id-base-base-content ) = 11.
        <ls_identification>-id-base-base-scheme_id = 'TCKN'.
      ELSE.
        <ls_identification>-id-base-base-scheme_id = 'VKN'.
      ENDIF.
    ELSE.
      IF sy-sysid = 'NP4' AND strlen( ms_accdoc_data-taxid ) = 10 AND ms_document-prfid = 'MUSTAHSIL'.
        CONCATENATE ms_accdoc_data-taxid '1' INTO ms_accdoc_data-taxid.
      ENDIF.
      ms_invoice_ubl-part1-accounting_customer_party-party = ubl_fill_partner_data( iv_address_number = ms_accdoc_data-address_number
                                                                                    iv_tax_id = ms_accdoc_data-taxid
                                                                                    iv_tax_office = ms_accdoc_data-tax_office
                                                                                    iv_profile_id = ms_document-prfid ).
    ENDIF.
  ENDMETHOD.


  METHOD build_invoice_data_bkpf_totals.
    DATA: ls_t005            TYPE t005,
          ls_invoice_line    TYPE /itetr/com_invoice_line,
          ls_bseg            TYPE bseg,
          ls_tax_match       TYPE /itetr/inv_taxm,
          ls_tax_data        TYPE /itetr/cl_regulative_common=>mty_tax_data,
          ls_tax_exemption   TYPE /itetr/cl_regulative_common=>mty_tax_exemption,
          ls_parent_tax_data TYPE /itetr/cl_regulative_common=>mty_tax_data,
          ls_accounts        TYPE /itetr/inv_fiac,
          lt_hkont           TYPE RANGE OF saknr,
          ls_hkont           LIKE LINE OF lt_hkont,
          lv_tax_rate        TYPE i,
          lv_base_amount     TYPE wrbtr,
          lv_amount          TYPE wrbtr.
    FIELD-SYMBOLS: <ls_tax_total>    TYPE /itetr/com_tax_total,
                   <ls_tax_subtotal> TYPE /itetr/com_tax_subtotal.

    READ TABLE ms_accdoc_data-t005
      INTO ls_t005
      WITH TABLE KEY land1 = ms_accdoc_data-t001-land1.

    " calculating line extension amount
    LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
      ADD ls_invoice_line-line_extension_amount-base-content TO ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
    ENDLOOP.

    " calculating base amount
    lv_base_amount = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.

    LOOP AT ms_accdoc_data-accounts INTO ls_accounts USING KEY by_accty WHERE accty = 'D'.
      ls_hkont-sign = 'I'.
      ls_hkont-option = 'EQ'.
      ls_hkont-low = ls_accounts-saknr.
      APPEND ls_hkont TO lt_hkont.
    ENDLOOP.
    IF lt_hkont IS NOT INITIAL.
      LOOP AT ms_accdoc_data-bseg INTO ls_bseg USING KEY by_koart WHERE koart = 'S'
                                                                    AND shkzg = 'S'.
        IF ls_bseg-lokkt IS NOT INITIAL .
          CHECK ls_bseg-lokkt IN lt_hkont .
        ELSE.
          CHECK ls_bseg-hkont IN lt_hkont .
        ENDIF.
        IF ls_bseg-wrbtr IS INITIAL AND ls_bseg-dmbtr IS NOT INITIAL.
          ls_bseg-wrbtr = ls_bseg-dmbtr.
        ENDIF.
        ADD ls_bseg-wrbtr TO ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-content.
        SUBTRACT ls_bseg-wrbtr FROM lv_base_amount.
      ENDLOOP.
    ENDIF.

    " filling VAT data
*    CLEAR lt_hkont.
*    LOOP AT ms_accdoc_data-accounts INTO ls_accounts USING KEY by_accty WHERE accty = 'O'.
*      ls_hkont-sign = 'I'.
*      ls_hkont-option = 'EQ'.
*      ls_hkont-low = ls_accounts-saknr.
*      APPEND ls_hkont TO lt_hkont.
*    ENDLOOP.
*    IF lt_hkont IS NOT INITIAL.
*      LOOP AT ms_accdoc_data-bseg INTO ls_bseg USING KEY by_koart WHERE koart = 'S'
*                                                                    AND shkzg = 'H'.
*        IF ls_bseg-lokkt IS NOT INITIAL .
*          CHECK ls_bseg-lokkt IN lt_hkont .
*        ELSE.
*          CHECK ls_bseg-hkont IN lt_hkont .
*        ENDIF.
*        IF ls_bseg-wrbtr IS INITIAL AND ls_bseg-dmbtr IS NOT INITIAL.
*          ls_bseg-wrbtr = ls_bseg-dmbtr.
*        ENDIF.
*        ls_tax_match = get_tax_match( iv_kalsm = ls_t005-kalsm
*                                      iv_mwskz = ls_bseg-mwskz ).
*        APPEND INITIAL LINE TO ms_invoice_ubl-part1-tax_total ASSIGNING <ls_tax_total>.
*        <ls_tax_total>-tax_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*        ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-taxty ). " AS 30.12.2021
*
*        IF ls_tax_match-txtyp IS INITIAL.
*          <ls_tax_total>-tax_amount-base-content = ls_bseg-wrbtr.
*
*          APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
**          ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-taxty ). " AS 30.12.2021
*          <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*          <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-taxty.
*          IF ls_bseg-wrbtr IS INITIAL OR ms_document-invty = 'IHRACKAYIT'.
*            IF ms_document-taxex IS NOT INITIAL.
*              ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ms_document-taxex ).
*              <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ms_document-taxex.
*            ELSE.
*              ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ls_tax_match-taxex ).
*              <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ls_tax_match-taxex.
*            ENDIF.
*            <ls_tax_subtotal>-tax_category-tax_exemption_reason-base-base-content = ls_tax_exemption-bezei.
*          ENDIF.
*          <ls_tax_subtotal>-taxable_amount-base-content = lv_base_amount.
*          <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*          <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
*          <ls_tax_subtotal>-tax_amount-base-content = ls_bseg-wrbtr.
*          <ls_tax_subtotal>-tax_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*        ELSE.
*          lv_amount = ( ( lv_base_amount * ls_tax_match-txrtp ) / 100 ) * ( 1 - ls_tax_match-taxrt / 100 ).
*          <ls_tax_total>-tax_amount-base-content = lv_amount.
*          APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*          ls_parent_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-txtyp ).
*          <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_parent_tax_data-ltext.
*          <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-txtyp.
*          <ls_tax_subtotal>-taxable_amount-base-content = lv_base_amount.
*          <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*          <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-txrtp.
*          lv_amount = ( lv_base_amount * ls_tax_match-txrtp ) / 100.
*          <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
*          <ls_tax_subtotal>-tax_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*
*          IF ls_tax_data-taxct = 'TEV'.
*            APPEND INITIAL LINE TO ms_invoice_ubl-part1-withholding_tax_total ASSIGNING <ls_tax_total>.
*            lv_amount = ( ( lv_base_amount * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
*            <ls_tax_total>-tax_amount-base-content = lv_amount.
*            <ls_tax_total>-tax_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*            APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*          ELSE.
*            APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*          ENDIF.
*          IF ms_document-taxty IS NOT INITIAL.
*            <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ms_document-taxty.
*            ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ms_document-taxty ).
*            <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*          ELSE.
*            <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-taxty.
*            <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*          ENDIF.
*          lv_amount = ( lv_base_amount * ls_tax_match-txrtp ) / 100.
*          <ls_tax_subtotal>-taxable_amount-base-content = lv_amount.
*          <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*          <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
*          lv_amount = ( ( lv_base_amount * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
*          <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
*          <ls_tax_subtotal>-tax_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
* Osman Şişmanoğlu vergi toplamı-> kalemden alınacak şekilde ortaklaştırıldı
    fill_common_tax_totals( ).

*    " if tax line not found then fill exemption
*    IF ms_invoice_ubl-part1-tax_total IS INITIAL.
*      IF ms_accdoc_data-bseg_partner-mwskz IS INITIAL.
*        LOOP AT ms_accdoc_data-bseg INTO ls_bseg WHERE mwskz IS NOT INITIAL.
*          EXIT.
*        ENDLOOP.
*        ls_tax_match = get_tax_match( iv_kalsm = ls_t005-kalsm
*                                      iv_mwskz = ls_bseg-mwskz ).
*      ELSE.
*        ls_tax_match = get_tax_match( iv_kalsm = ls_t005-kalsm
*                                      iv_mwskz = ms_accdoc_data-bseg_partner-mwskz ).
*      ENDIF.
*
*      APPEND INITIAL LINE TO ms_invoice_ubl-part1-tax_total ASSIGNING <ls_tax_total>.
*      <ls_tax_total>-tax_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*      <ls_tax_total>-tax_amount-base-content = 0.
*
*      APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*      ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-taxty ).
*      <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*      <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-taxty.
*
*      IF ms_document-taxex IS NOT INITIAL.
*        <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ms_document-taxex.
*        ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ms_document-taxex ).
*      ELSE.
*        <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ls_tax_match-taxex.
*        ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ls_tax_match-taxex ).
*      ENDIF.
*      <ls_tax_subtotal>-tax_category-tax_exemption_reason-base-base-content = ls_tax_exemption-bezei.
*      <ls_tax_subtotal>-taxable_amount-base-content = lv_base_amount.
*      <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*      <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
*      <ls_tax_subtotal>-tax_amount-base-content = 0.
*      <ls_tax_subtotal>-tax_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*    ENDIF.

    IF ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-content IS NOT INITIAL.
      ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
    ENDIF.
    IF ms_document-prfid <> 'MUSTAHSIL'.
      ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
      ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content = lv_base_amount.
      ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*      READ TABLE  ms_invoice_ubl-part1-withholding_tax_total TRANSPORTING NO FIELDS INDEX 1.
*      IF sy-subrc EQ 0.
        ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content =   ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content + ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content.
        ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*      ELSE.
*        ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_accdoc_data-bseg_partner-wrbtr.
*        ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
*      ENDIF.
      ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_accdoc_data-bseg_partner-wrbtr.
      ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
    ELSE.
      ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
      ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content = lv_base_amount + ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content.
      ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
      ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_accdoc_data-bseg_partner-wrbtr.
      ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
      ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_accdoc_data-bseg_partner-wrbtr + ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content.
      ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id = ms_accdoc_data-bkpf-waers.
    ENDIF.
  ENDMETHOD.


  METHOD build_invoice_data_common_item.
    DATA: lv_index           TYPE i,
          ls_invoice_items   TYPE mty_item_collect,
          lv_amount          TYPE wrbtr,
          ls_tax_match       TYPE /itetr/inv_taxm,
          ls_tax_data        TYPE /itetr/cl_regulative_common=>mty_tax_data,
          ls_parent_tax_data TYPE /itetr/cl_regulative_common=>mty_tax_data,
          ls_tax_exemption   TYPE /itetr/cl_regulative_common=>mty_tax_exemption,
          ls_delivery_party  TYPE /itetr/com_party,
          ls_item_allowance  TYPE mty_item_allowance,
          ls_item_additional TYPE mty_item_additional,
          lv_taxindex        TYPE i,
          lv_taxtype         TYPE string,
          lv_netwr           TYPE netwr,
          lv_percent         TYPE char20,
          lv_taxex           TYPE /itetr/com_e_taxex,
          ls_ytb_item        TYPE /itetr/inv_ytb_i, "gkadioglu
          lt_ytb_item        TYPE TABLE OF /itetr/inv_ytb_i,"gkadioglu
          lv_price_amt       TYPE p DECIMALS 5.

    FIELD-SYMBOLS: <ls_invoice_line>             TYPE /itetr/com_invoice_line,
                   <ls_item_identification>      TYPE /itetr/com_additional_item_ide,
                   <ls_tax_subtotal>             TYPE /itetr/com_tax_subtotal,
                   <ls_tax_total>                TYPE /itetr/com_withholding_tax_tot,
                   <ls_delivery>                 TYPE /itetr/com_delivery,
                   <ls_shipment_stage>           TYPE /itetr/com_shipment_stage,
                   <ls_delivery_terms>           TYPE /itetr/com_delivery_terms,
                   <ls_goods_item>               TYPE /itetr/com_goods_item,
                   <transport_handling_unit>     TYPE /itetr/com_transport_handling3,
                   <customs_declaration>         TYPE /itetr/com_customs_declaratio1,
                   <party_identification>        TYPE /itetr/com_party_identificati1,
                   <ls_allowance_charge>         TYPE /itetr/com_allowance_charge,
                   <ls_commodity_classification> TYPE /itetr/com_commodity_classifi1,
                   <ls_item_instance>            TYPE /itetr/com_item_instance,
                   <lv_field>                    TYPE any.

    CHECK mt_invoice_items IS NOT INITIAL.

    IF mv_item_sort IS NOT INITIAL.
      READ TABLE mt_invoice_items INTO ls_invoice_items INDEX 1.
      ASSIGN COMPONENT mv_item_sort OF STRUCTURE ls_invoice_items TO <lv_field>.
      IF sy-subrc = 0.
        SORT mt_invoice_items BY (mv_item_sort).
      ENDIF.
    ENDIF.

    SELECT * FROM /itetr/inv_ytb_i INTO TABLE lt_ytb_item WHERE docui = ms_document-docui.


    LOOP AT mt_invoice_items INTO ls_invoice_items.
      ADD 1 TO lv_index.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-invoice_line ASSIGNING <ls_invoice_line>.
      <ls_invoice_line>-id-base-base-content = lv_index.

      READ TABLE lt_ytb_item INTO ls_ytb_item WITH KEY linno = <ls_invoice_line>-id-base-base-content."gkadioglu

      IF ms_document-prfid <> 'MUSTAHSIL'.
        APPEND INITIAL LINE TO <ls_invoice_line>-item-additional_item_identification ASSIGNING <ls_item_identification>.
        <ls_item_identification>-id-base-base-scheme_id = 'POSNR'.
        <ls_item_identification>-id-base-base-content = ls_invoice_items-posnr.

        LOOP AT mt_items_additional INTO ls_item_additional WHERE matnr = ls_invoice_items-matnr.
          APPEND INITIAL LINE TO <ls_invoice_line>-item-additional_item_identification ASSIGNING <ls_item_identification>.
          <ls_item_identification>-id-base-base-scheme_id = ls_item_additional-scheme_id.
          <ls_item_identification>-id-base-base-content = ls_item_additional-content.
        ENDLOOP.
        IF sy-subrc IS NOT INITIAL.
          LOOP AT mt_items_additional INTO ls_item_additional WHERE posnr = ls_invoice_items-posnr.
            APPEND INITIAL LINE TO <ls_invoice_line>-item-additional_item_identification ASSIGNING <ls_item_identification>.
            <ls_item_identification>-id-base-base-scheme_id = ls_item_additional-scheme_id.
            <ls_item_identification>-id-base-base-content = ls_item_additional-content.
          ENDLOOP.
        ENDIF.
      ENDIF.


      IF ms_document-prfid EQ 'IDIS'.
        APPEND INITIAL LINE TO <ls_invoice_line>-item-additional_item_identification ASSIGNING <ls_item_identification>.
        <ls_item_identification>-id-base-base-scheme_id = 'ETIKETNO'.
        <ls_item_identification>-id-base-base-content = ls_invoice_items-etiketno.
      ENDIF.

*      IF ms_document-invty = 'ILAC_TIBBI'.
*        IF ls_invoice_items-ilac_gtin IS NOT INITIAL OR
*           ls_invoice_items-ilac_bn IS NOT INITIAL OR
*           ls_invoice_items-ilac_sn IS NOT INITIAL OR
*           ls_invoice_items-ilac_xd IS NOT INITIAL.
*          APPEND INITIAL LINE TO <ls_invoice_line>-item-additional_item_identification ASSIGNING <ls_item_identification>.
*          <ls_item_identification>-id-base-base-scheme_id = 'ILAC'.
*          CONCATENATE '(GTIN)' ls_invoice_items-ilac_gtin
*                      '(BN)' ls_invoice_items-ilac_bn
*                      '(SN)' ls_invoice_items-ilac_sn
*                      '(XD)' ls_invoice_items-ilac_xd
*                      INTO <ls_item_identification>-id-base-base-content.
*        ELSEIF ls_invoice_items-tibbicihaz_uno IS NOT INITIAL OR
*               ls_invoice_items-tibbicihaz_lno IS NOT INITIAL OR
*               ls_invoice_items-tibbicihaz_sno IS NOT INITIAL OR
*               ls_invoice_items-tibbicihaz_urt IS NOT INITIAL.
*          APPEND INITIAL LINE TO <ls_invoice_line>-item-additional_item_identification ASSIGNING <ls_item_identification>.
*          <ls_item_identification>-id-base-base-scheme_id = 'TIBBICIHAZ'.
*          CONCATENATE '(UNO)' ls_invoice_items-tibbicihaz_uno
*                      '(LNO)' ls_invoice_items-tibbicihaz_lno
*                      '(SNO)' ls_invoice_items-tibbicihaz_sno
*                      '(URT)' ls_invoice_items-tibbicihaz_urt
*                      INTO <ls_item_identification>-id-base-base-content.
*        ENDIF.
*      ENDIF.

      IF ls_invoice_items-matnr IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = ls_invoice_items-matnr
          IMPORTING
            output = <ls_invoice_line>-item-sellers_item_identification-id-base-base-content.
      ENDIF.
      IF ms_document-prfid = 'MUSTAHSIL' AND ls_invoice_items-matnr IS INITIAL.
        <ls_invoice_line>-item-sellers_item_identification-id-base-base-content = ls_invoice_items-kdmat.
      ELSE.
        <ls_invoice_line>-item-buyers_item_identification-id-base-base-content = ls_invoice_items-kdmat.
      ENDIF.
      <ls_invoice_line>-item-origin_country-name-base-base-content = ls_invoice_items-herkl. " menşei staskan
      <ls_invoice_line>-item-manufacturers_item_identificat-id-base-base-content = ls_invoice_items-admat.
      <ls_invoice_line>-item-name-base-base-content = ls_invoice_items-arktx.
      <ls_invoice_line>-item-description-base-base-content = ls_invoice_items-descr.
      <ls_invoice_line>-invoiced_quantity-base-base-content = ls_invoice_items-fkimg.
      <ls_invoice_line>-invoiced_quantity-base-base-unit_code = /itetr/cl_regulative_common=>get_unit_matching( ls_invoice_items-vrkme ).
      <ls_invoice_line>-line_extension_amount-base-content = ls_invoice_items-netwr.
      <ls_invoice_line>-line_extension_amount-base-currency_id = ls_invoice_items-waers.
      CONDENSE ls_invoice_items-netpr.
      IF ls_invoice_items-netpr IS INITIAL OR ls_invoice_items-netpr = '0.00' OR ls_invoice_items-netpr = '0'.
*        <ls_invoice_line>-price-price_amount-base-content = ls_invoice_items-netwr / ls_invoice_items-fkimg.
* Osman Şişmanoğlu kalemdeki birim fiyata iskonto/artırım uygulanmamış olmalı
        lv_price_amt = ( ls_invoice_items-netwr + ls_invoice_items-distr - ls_invoice_items-surrt ) / ls_invoice_items-fkimg.
        <ls_invoice_line>-price-price_amount-base-content = lv_price_amt.
        <ls_invoice_line>-price-price_amount-base-currency_id = ls_invoice_items-waers.
      ELSE.
        "gkadioglu peinh 0 a bolunme hatası begin
        IF ( ls_invoice_items-peinh = 0 OR  ls_invoice_items-peinh IS INITIAL ) AND
             mv_fix_quantity EQ abap_true.
          ls_invoice_items-peinh = 1.
          CONDENSE ls_invoice_items-peinh NO-GAPS.
        ENDIF.
        "gkadioglu peinh 0 a bolunme hatası end
        <ls_invoice_line>-price-price_amount-base-content = ls_invoice_items-netpr / ls_invoice_items-peinh.
        <ls_invoice_line>-price-price_amount-base-currency_id = ls_invoice_items-netwa.
      ENDIF.

      IF ms_document-prfid = 'IHRACAT'.
        APPEND INITIAL LINE TO <ls_invoice_line>-delivery ASSIGNING <ls_delivery>.
        APPEND INITIAL LINE TO <ls_delivery>-shipment-shipment_stage ASSIGNING <ls_shipment_stage>.
        APPEND INITIAL LINE TO <ls_delivery>-delivery_terms ASSIGNING <ls_delivery_terms>.
        <ls_delivery>-shipment-id-base-base-content = ` `.
        ls_delivery_party = ubl_fill_partner_data( iv_address_number = ls_invoice_items-adrwe
                                                   iv_profile_id = ms_document-prfid ).
        <ls_delivery>-delivery_address = ls_delivery_party-postal_address.
        <ls_delivery_terms>-id-base-base-scheme_id = 'INCOTERMS'.
        <ls_delivery_terms>-id-base-base-content = ls_invoice_items-inco1.
        <ls_shipment_stage>-transport_mode_code-base-base-content = ls_invoice_items-trnty.
        <ls_delivery>-shipment-id-base-base-content = ` `.
        APPEND INITIAL LINE TO <ls_delivery>-shipment-goods_item ASSIGNING <ls_goods_item>.
        <ls_goods_item>-required_customs_id-base-base-content = ls_invoice_items-hscod.

        IF ls_invoice_items-kwrfr IS NOT INITIAL.
          <ls_delivery>-shipment-declared_for_carriage_value_am-base-content = ls_invoice_items-kwrfr.
          <ls_delivery>-shipment-declared_for_carriage_value_am-base-currency_id = ls_invoice_items-waers.
        ENDIF.
        IF ls_invoice_items-kwrin IS NOT INITIAL.
          <ls_delivery>-shipment-insurance_value_amount-base-content = ls_invoice_items-kwrin.
          <ls_delivery>-shipment-insurance_value_amount-base-currency_id = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

***      IF ms_document-invty = 'IHRACKAYIT' AND ms_document-taxex = '702'.
****        APPEND INITIAL LINE TO <ls_invoice_line>-delivery ASSIGNING <ls_delivery>.
****        APPEND INITIAL LINE TO <ls_delivery>-shipment-transport_handling_unit ASSIGNING <transport_handling_unit>.
****        APPEND INITIAL LINE TO <transport_handling_unit>-customs_declaration ASSIGNING <customs_declaration>.
****        APPEND INITIAL LINE TO <customs_declaration>-issuer_party-party_identification ASSIGNING  <party_identification>.
****        <ls_delivery>-shipment-id-base-base-content = <ls_invoice_line>-id-base-base-content.
****        APPEND INITIAL LINE TO <ls_delivery>-shipment-goods_item ASSIGNING <ls_goods_item>.
****        <ls_goods_item>-required_customs_id-base-base-content = ls_invoice_items-hscod.
****        <customs_declaration>-id-base-base-content = <ls_invoice_line>-id-base-base-content.
****        <party_identification>-id-base-base-scheme_id = 'DIBSATIRKOD'.
****        <party_identification>-id-base-base-content = ls_invoice_items-diib.
***
***        APPEND INITIAL LINE TO <ls_invoice_line>-delivery ASSIGNING <ls_delivery>.
***        APPEND INITIAL LINE TO <ls_delivery>-shipment-transport_handling_unit ASSIGNING <transport_handling_unit>.
***        APPEND INITIAL LINE TO <transport_handling_unit>-customs_declaration ASSIGNING <customs_declaration>.
***        APPEND INITIAL LINE TO <customs_declaration>-issuer_party-party_identification ASSIGNING  <party_identification>.
***        <ls_delivery>-shipment-id-base-base-content = <ls_invoice_line>-id-base-base-content.
***        APPEND INITIAL LINE TO <ls_delivery>-shipment-goods_item ASSIGNING <ls_goods_item>.
***        <ls_goods_item>-required_customs_id-base-base-content = ls_invoice_items-hscod.
***        <customs_declaration>-id-base-base-content = <ls_invoice_line>-id-base-base-content.
***        <party_identification>-id-base-base-scheme_id = 'SATICIDIBSATIRKOD'.
***        <party_identification>-id-base-base-content = ls_invoice_items-sellerdiib.
***
***        APPEND INITIAL LINE TO <ls_invoice_line>-delivery ASSIGNING <ls_delivery>.
***        APPEND INITIAL LINE TO <ls_delivery>-shipment-transport_handling_unit ASSIGNING <transport_handling_unit>.
***        APPEND INITIAL LINE TO <transport_handling_unit>-customs_declaration ASSIGNING <customs_declaration>.
***        APPEND INITIAL LINE TO <customs_declaration>-issuer_party-party_identification ASSIGNING  <party_identification>.
***        <ls_delivery>-shipment-id-base-base-content = <ls_invoice_line>-id-base-base-content.
***        APPEND INITIAL LINE TO <ls_delivery>-shipment-goods_item ASSIGNING <ls_goods_item>.
***        <ls_goods_item>-required_customs_id-base-base-content = ls_invoice_items-hscod.
***        <customs_declaration>-id-base-base-content = <ls_invoice_line>-id-base-base-content.
***        <party_identification>-id-base-base-scheme_id = 'ALICIDIBSATIRKOD'.
***        <party_identification>-id-base-base-content = ls_invoice_items-buyerdiib.
***      ENDIF.


      IF ls_invoice_items-distr IS NOT INITIAL OR ls_invoice_items-disrt IS NOT INITIAL.
        IF ms_document-itmcl = abap_false AND mv_sepallowance IS NOT INITIAL.
          LOOP AT mt_items_allowance INTO ls_item_allowance WHERE posnr EQ ls_invoice_items-posnr AND ( distr IS NOT INITIAL OR disrt IS NOT INITIAL ).
            APPEND INITIAL LINE TO <ls_invoice_line>-allowance_charge ASSIGNING <ls_allowance_charge>.
            <ls_allowance_charge>-charge_indicator-base-content = abap_false.
            IF ls_item_allowance-distr IS NOT INITIAL.
              <ls_allowance_charge>-amount-base-content = ls_item_allowance-distr.
            ENDIF.
            IF ls_item_allowance-disrt IS NOT INITIAL.
              <ls_allowance_charge>-multiplier_factor_numeric-base-base-content = ls_item_allowance-disrt.
            ENDIF.
            <ls_allowance_charge>-amount-base-currency_id = ls_invoice_items-waers.
          ENDLOOP.
        ELSE.
          APPEND INITIAL LINE TO <ls_invoice_line>-allowance_charge ASSIGNING <ls_allowance_charge>.
          <ls_allowance_charge>-charge_indicator-base-content = abap_false.
          IF ls_invoice_items-distr IS NOT INITIAL.
            <ls_allowance_charge>-amount-base-content = ls_invoice_items-distr.
          ENDIF.
          IF ls_invoice_items-disrt IS NOT INITIAL.
            <ls_allowance_charge>-multiplier_factor_numeric-base-base-content = ls_invoice_items-disrt.
          ENDIF.
          <ls_allowance_charge>-amount-base-currency_id = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

      IF ls_invoice_items-surtr IS NOT INITIAL OR ls_invoice_items-surrt IS NOT INITIAL.
        IF ms_document-itmcl = abap_false AND mv_sepallowance IS NOT INITIAL.
          LOOP AT mt_items_allowance INTO ls_item_allowance WHERE posnr EQ ls_invoice_items-posnr AND ( surtr IS NOT INITIAL OR surrt IS NOT INITIAL ).
            APPEND INITIAL LINE TO <ls_invoice_line>-allowance_charge ASSIGNING <ls_allowance_charge>.
            <ls_allowance_charge>-charge_indicator-base-content = abap_true.
            IF ls_item_allowance-surtr IS NOT INITIAL.
              <ls_allowance_charge>-amount-base-content = ls_item_allowance-surtr.
            ENDIF.
            IF ls_item_allowance-surrt IS NOT INITIAL.
              <ls_allowance_charge>-multiplier_factor_numeric-base-base-content = ls_item_allowance-surrt.
            ENDIF.
            <ls_allowance_charge>-amount-base-currency_id = ls_invoice_items-waers.
          ENDLOOP.
        ELSE.
          APPEND INITIAL LINE TO <ls_invoice_line>-allowance_charge ASSIGNING <ls_allowance_charge>.
          <ls_allowance_charge>-charge_indicator-base-content = abap_true.
          IF ls_invoice_items-surtr IS NOT INITIAL.
            <ls_allowance_charge>-amount-base-content = ls_invoice_items-surtr.
          ENDIF.
          IF ls_invoice_items-surrt IS NOT INITIAL.
            <ls_allowance_charge>-multiplier_factor_numeric-base-base-content = ls_invoice_items-surrt.
          ENDIF.
          <ls_allowance_charge>-amount-base-currency_id = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

      CHECK ls_invoice_items-mwskz IS NOT INITIAL.
      ls_tax_match = get_tax_match( iv_kalsm = iv_kalsm
                                    iv_mwskz  = ls_invoice_items-mwskz ).
      IF ms_document-taxty IS NOT INITIAL.
        ls_tax_match-taxty = ms_document-taxty.
      ENDIF.
      <ls_invoice_line>-tax_total-tax_amount-base-currency_id = ls_invoice_items-waers.
      ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-taxty ).

      IF ls_tax_match-txtyp IS INITIAL.
        IF ls_invoice_items-mwsbp IS INITIAL. "as
          lv_amount = ls_invoice_items-netwr * ls_tax_match-taxrt / 100.
          <ls_invoice_line>-tax_total-tax_amount-base-content = lv_amount.
        ELSE.
          <ls_invoice_line>-tax_total-tax_amount-base-content = ls_invoice_items-mwsbp + ls_invoice_items-othtx + ls_invoice_items-dgrtx."gkadioglu
*          <ls_invoice_line>-tax_total-tax_amount-base-content = ls_invoice_items-mwsbp.
        ENDIF.

        APPEND INITIAL LINE TO <ls_invoice_line>-tax_total-tax_subtotal ASSIGNING <ls_tax_subtotal>.
        IF ms_document-prfid = 'MUSTAHSIL'.
          CASE ls_tax_data-taxty.
            WHEN '0003'.
              ls_tax_data-ltext = 'GV STOPAJI'.
            WHEN '8001'.
              ls_tax_data-ltext = 'BORSA TES.ÜC.'.
            WHEN 'SGK_PRIM'.
              ls_tax_data-ltext = 'SGK PRİM KESİNTİSİ'.
            WHEN '9040'.
              ls_tax_data-ltext = 'MERA FONU'.
          ENDCASE.
        ENDIF.
        <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
        <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_data-taxty.
        CONDENSE <ls_invoice_line>-tax_total-tax_amount-base-content.
        IF <ls_invoice_line>-tax_total-tax_amount-base-content EQ '0.00' OR <ls_invoice_line>-tax_total-tax_amount-base-content IS INITIAL OR ms_document-invty = 'IHRACKAYIT'.
          IF ms_document-taxex IS NOT INITIAL.
            <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ms_document-taxex.
            ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ms_document-taxex ).
          ELSE.
            <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ls_tax_match-taxex.
            ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ls_tax_match-taxex ).
          ENDIF.
          <ls_tax_subtotal>-tax_category-tax_exemption_reason-base-base-content = ls_tax_exemption-bezei.
        ENDIF.
        <ls_tax_subtotal>-taxable_amount-base-content = ls_invoice_items-netwr.
        <ls_tax_subtotal>-taxable_amount-base-currency_id = ls_invoice_items-waers.
        <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
        IF ls_invoice_items-mwsbp IS INITIAL. "as
          lv_amount = ls_invoice_items-netwr * ls_tax_match-taxrt / 100.
          <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
        ELSE.
          <ls_tax_subtotal>-tax_amount-base-content = ls_invoice_items-mwsbp.
        ENDIF.
        <ls_tax_subtotal>-tax_amount-base-currency_id = ls_invoice_items-waers.

        IF ls_tax_exemption-taxex IS NOT INITIAL AND
           ( ms_document-prfid = 'YATIRIMTES' AND ms_document-invty = 'ISTISNA'    ) OR
           ( ms_document-prfid = 'EARSIV'     AND ms_document-invty = 'YTBISTISNA' ) .

          fill_common_tax_ytb(   EXPORTING  is_invoice_line   = <ls_invoice_line>
                                            is_invoice_items  = ls_invoice_items
                                            is_item_ytb       = ls_ytb_item
                                            iv_kalsm          = iv_kalsm
                                 CHANGING   cs_tax_subtotal = <ls_tax_subtotal> ).
        ENDIF.

      ELSE.
        lv_amount = ( ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100 ) * ( 1 - ls_tax_match-taxrt / 100 ).
        <ls_invoice_line>-tax_total-tax_amount-base-content = lv_amount.
        APPEND INITIAL LINE TO <ls_invoice_line>-tax_total-tax_subtotal ASSIGNING <ls_tax_subtotal>.
        ls_parent_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-txtyp ).
        <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_parent_tax_data-ltext.
        <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-txtyp.
        <ls_tax_subtotal>-taxable_amount-base-content = ls_invoice_items-netwr.
        <ls_tax_subtotal>-taxable_amount-base-currency_id = ls_invoice_items-waers.
        <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-txrtp.
        lv_amount = ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100.
        <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
        <ls_tax_subtotal>-tax_amount-base-currency_id = ls_invoice_items-waers.
        IF ms_document-invty EQ 'TEVIADE' OR ms_document-invty = 'YTBTEVIADE'.
          <ls_tax_subtotal>-tax_amount-base-content = <ls_invoice_line>-tax_total-tax_amount-base-content.
        ELSE.
          IF ls_tax_data-taxct = 'TEV'.
            APPEND INITIAL LINE TO <ls_invoice_line>-withholding_tax_total ASSIGNING <ls_tax_total>.
            lv_amount = ( ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
            <ls_tax_total>-tax_amount-base-content = lv_amount.
            <ls_tax_total>-tax_amount-base-currency_id = ls_invoice_items-waers.
            APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
          ELSE.
            APPEND INITIAL LINE TO <ls_invoice_line>-withholding_tax_total ASSIGNING <ls_tax_total>."dump staskan
            APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
          ENDIF.
          IF ms_document-taxty IS NOT INITIAL.
            <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ms_document-taxty.
            ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ms_document-taxty ).
            <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
          ELSE.
            <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-taxty.
            <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
          ENDIF.
          lv_amount = ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100.
          <ls_tax_subtotal>-taxable_amount-base-content = lv_amount.
          <ls_tax_subtotal>-taxable_amount-base-currency_id = ls_invoice_items-waers.
          <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
          lv_amount = ( ( ls_invoice_items-netwr * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
          <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
          <ls_tax_subtotal>-tax_amount-base-currency_id = ls_invoice_items-waers.
        ENDIF.
      ENDIF.

      IF ls_invoice_items-othtx IS NOT INITIAL.
        ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_invoice_items-othtt ).
        APPEND INITIAL LINE TO <ls_invoice_line>-tax_total-tax_subtotal ASSIGNING <ls_tax_subtotal>.
        <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
        <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_invoice_items-othtt.
        <ls_tax_subtotal>-taxable_amount-base-content = ls_invoice_items-netwr.
        <ls_tax_subtotal>-taxable_amount-base-currency_id = ls_invoice_items-waers.
        <ls_tax_subtotal>-percent-base-base-content = ls_invoice_items-othtr.
        <ls_tax_subtotal>-tax_amount-base-content = ls_invoice_items-othtx.
        <ls_tax_subtotal>-tax_amount-base-currency_id = ls_invoice_items-waers.
      ENDIF.
      "gkadioglu diger kdv bilgisi ekleme
      IF ls_invoice_items-dgrtx IS NOT INITIAL.
        ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_invoice_items-dgrtt ).
        APPEND INITIAL LINE TO <ls_invoice_line>-tax_total-tax_subtotal ASSIGNING <ls_tax_subtotal>.
        <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
        <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_invoice_items-dgrtt.
        <ls_tax_subtotal>-taxable_amount-base-content = ls_invoice_items-netwr.
        <ls_tax_subtotal>-taxable_amount-base-currency_id = ls_invoice_items-waers.
        <ls_tax_subtotal>-percent-base-base-content = ls_invoice_items-dgrtr.
        <ls_tax_subtotal>-tax_amount-base-content = ls_invoice_items-dgrtx.
        <ls_tax_subtotal>-tax_amount-base-currency_id = ls_invoice_items-waers.
      ENDIF.

      IF ms_document-invty = 'IHRACKAYIT' AND ( ms_document-taxex = '702' OR ls_tax_match-taxex = '702' ).
        APPEND INITIAL LINE TO <ls_invoice_line>-delivery ASSIGNING <ls_delivery>.
        APPEND INITIAL LINE TO <ls_delivery>-shipment-transport_handling_unit ASSIGNING <transport_handling_unit>.
        APPEND INITIAL LINE TO <transport_handling_unit>-customs_declaration ASSIGNING <customs_declaration>.
        APPEND INITIAL LINE TO <customs_declaration>-issuer_party-party_identification ASSIGNING  <party_identification>.
        <ls_delivery>-shipment-id-base-base-content = <ls_invoice_line>-id-base-base-content.
        APPEND INITIAL LINE TO <ls_delivery>-shipment-goods_item ASSIGNING <ls_goods_item>.
        <ls_goods_item>-required_customs_id-base-base-content = ls_invoice_items-hscod.
        <customs_declaration>-id-base-base-content = <ls_invoice_line>-id-base-base-content.
        <party_identification>-id-base-base-scheme_id = 'SATICIDIBSATIRKOD'.
        <party_identification>-id-base-base-content = ls_invoice_items-sellerdiib.

        APPEND INITIAL LINE TO <ls_invoice_line>-delivery ASSIGNING <ls_delivery>.
        APPEND INITIAL LINE TO <ls_delivery>-shipment-transport_handling_unit ASSIGNING <transport_handling_unit>.
        APPEND INITIAL LINE TO <transport_handling_unit>-customs_declaration ASSIGNING <customs_declaration>.
        APPEND INITIAL LINE TO <customs_declaration>-issuer_party-party_identification ASSIGNING  <party_identification>.
        <ls_delivery>-shipment-id-base-base-content = <ls_invoice_line>-id-base-base-content.
        APPEND INITIAL LINE TO <ls_delivery>-shipment-goods_item ASSIGNING <ls_goods_item>.
        <ls_goods_item>-required_customs_id-base-base-content = ls_invoice_items-hscod.
        <customs_declaration>-id-base-base-content = <ls_invoice_line>-id-base-base-content.
        <party_identification>-id-base-base-scheme_id = 'ALICIDIBSATIRKOD'.
        <party_identification>-id-base-base-content = ls_invoice_items-buyerdiib.
      ENDIF.

      IF mv_invtype EQ abap_true AND ms_document-invty NE 'YTBISTISNA'.
        IF ls_tax_match-taxrt EQ 0 AND ( ls_tax_match-taxex IS NOT INITIAL OR ms_document-taxex IS NOT INITIAL ).
          ms_document-invty = 'ISTISNA'.
        ENDIF.
      ENDIF.


      "yatırım tesvik
      IF  ms_document-prfid = 'YATIRIMTES' OR
        ( ms_document-prfid = 'EARSIV' AND ms_document-invty+0(3) EQ 'YTB' ).

        APPEND INITIAL LINE TO <ls_invoice_line>-item-commodity_classification ASSIGNING <ls_commodity_classification>.

        IF ls_ytb_item IS NOT INITIAL.
          <ls_commodity_classification>-item_classification_code-base-base-content = ls_ytb_item-cls_code.
          IF  <ls_commodity_classification>-item_classification_code-base-base-content EQ '01'.
            <ls_invoice_line>-item-model_name-base-base-content = ls_ytb_item-model_name.
            APPEND INITIAL LINE TO <ls_invoice_line>-item-item_instance ASSIGNING <ls_item_instance>.
            <ls_item_instance>-serial_id-base-base-content = ls_ytb_item-serial_id.
            <ls_item_instance>-product_trace_id-base-base-content = ls_ytb_item-prd_trace_id.
          ENDIF.
        ELSE.
          <ls_commodity_classification>-item_classification_code-base-base-content = ls_invoice_items-classification_code.
          IF  <ls_commodity_classification>-item_classification_code-base-base-content EQ '01'.
            <ls_invoice_line>-item-model_name-base-base-content = ls_invoice_items-model_name.
            APPEND INITIAL LINE TO <ls_invoice_line>-item-item_instance ASSIGNING <ls_item_instance>.
            <ls_item_instance>-serial_id-base-base-content = ls_invoice_items-serial_id.
            <ls_item_instance>-product_trace_id-base-base-content = ls_invoice_items-product_trace_id.
          ENDIF.
        ENDIF.

      ENDIF.


      "DİĞER İŞLEM TÜRÜ
      IF ms_document-taxex = '555' OR ls_tax_match-taxex = '555'.
        lv_taxex = '555'.
        ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( lv_taxex ).
        <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = lv_taxex.
        <ls_tax_subtotal>-tax_category-tax_exemption_reason-base-base-content = ls_tax_exemption-bezei.
      ENDIF.


      "müstahsil özel vergiler - Regülasyona göre bu vergiler bulunması gerekiyor
      "eğer belge altında ilgili vergi tanımlanamıyorsa, burada ilgili vergiler hesaplanacak
      "uyarlamaya bağlanabilir, çünkü 8001 vergisi değişiklik gösterebiliyor, 5-15 arası bir değer olabiliyormuş!!!
      IF ms_document-prfid = 'MUSTAHSIL'.
        lv_taxindex = 1.
        WHILE lv_taxindex LE 3.
          CLEAR: lv_taxtype, lv_netwr, lv_percent.
          CASE lv_taxindex.
            WHEN 1.
              lv_taxtype = '8001'.
              ls_tax_data-ltext = 'BORSA TES.ÜC.'.
              lv_percent = '10'.
              READ TABLE <ls_invoice_line>-tax_total-tax_subtotal
                WITH KEY tax_category-tax_scheme-tax_type_code-base-base-content = '0003'
                INTO DATA(ls_exlude).
              lv_netwr = ls_exlude-taxable_amount-base-content - ls_exlude-tax_amount-base-content.
            WHEN 2.
              lv_taxtype = 'SGK_PRIM'.
              ls_tax_data-ltext = 'SGK PRİM KESİNTİSİ'.
              lv_percent = '8'.
              lv_netwr = ls_invoice_items-netwr.
            WHEN 3.
              lv_taxtype = '9040'.
              ls_tax_data-ltext = 'MERA FONU'.
              lv_percent = '5'.
              lv_netwr = ls_invoice_items-netwr.
          ENDCASE.
          READ TABLE <ls_invoice_line>-tax_total-tax_subtotal
            WITH KEY tax_category-tax_scheme-tax_type_code-base-base-content = lv_taxtype
            TRANSPORTING NO FIELDS.
          IF sy-subrc NE 0.
            APPEND INITIAL LINE TO <ls_invoice_line>-tax_total-tax_subtotal ASSIGNING <ls_tax_subtotal>.
            <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
            <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = lv_taxtype.
            <ls_tax_subtotal>-taxable_amount-base-content = lv_netwr.
            <ls_tax_subtotal>-taxable_amount-base-currency_id = ls_invoice_items-waers.
            <ls_tax_subtotal>-percent-base-base-content = lv_percent.
            <ls_tax_subtotal>-tax_amount-base-content = ( lv_netwr * lv_percent ) / 100.
            <ls_tax_subtotal>-tax_amount-base-currency_id = ls_invoice_items-waers.

            ADD <ls_tax_subtotal>-tax_amount-base-content TO <ls_invoice_line>-tax_total-tax_amount-base-content.
          ENDIF.

          ADD 1 TO lv_taxindex.
        ENDWHILE.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  method BUILD_INVOICE_DATA_FICA.

  ms_fica_data = get_data_fica( iv_bukrs = ms_document-bukrs
                                iv_belnr = ms_document-belnr_fica
                                iv_gjahr = ms_document-gjahr
                                iv_gpart = ms_document-gpart ).

  build_invoice_data_fica_head( ).
  build_invoice_data_fica_party( ).
  build_invoice_data_fica_item( ).
  build_invoice_data_fica_totals( ).
  build_invoice_data_fica_notes( ).
  fill_common_invoice_data( ).

  endmethod.


  method BUILD_INVOICE_DATA_FICA_HEAD.

    CONCATENATE ms_fica_data-oginv-bldat+0(4)
                ms_fica_data-oginv-bldat+4(2)
                ms_fica_data-oginv-bldat+6(2)
      INTO ms_invoice_ubl-part1-issue_date-base-content
      SEPARATED BY '-'.

    ms_invoice_ubl-part1-document_currency_code-base-base-content = ms_fica_data-oginv-waers.

    IF ms_fica_data-oginv-waers NE ms_fica_data-t001-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-source_currency_code-base-base-content = ms_fica_data-oginv-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-target_currency_code-base-base-content = ms_fica_data-t001-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-calculation_rate-base-base-content = ms_fica_data-oginv-kursf.
*      ms_invoice_ubl-part1-pricing_exchange_rate-date-base-content = ms_invoice_ubl-part1-issue_date-base-content.
      ms_invoice_ubl-part1-pricing_currency_code-base-base-content = ms_fica_data-oginv-waers.
    ENDIF.
   CONCATENATE ms_fica_data-dfkkop-faedn+0(4)
                ms_fica_data-dfkkop-faedn+4(2)
                ms_fica_data-dfkkop-faedn+6(2)
      INTO ms_invoice_ubl-part1-payment_terms-payment_due_date-base-content
      SEPARATED BY '-'.

  endmethod.


  METHOD build_invoice_data_fica_item.

    DATA: ls_t005 TYPE t005.
    collect_items_fica( ).
    READ TABLE ms_fica_data-t005
      INTO ls_t005
      WITH TABLE KEY land1 = ms_fica_data-t001-land1.
    build_invoice_data_common_item( ls_t005-kalsm ).


  ENDMETHOD.


  METHOD build_invoice_data_fica_notes.

    DATA: ls_texts TYPE /itetr/cl_outgoing_invoice=>mty_texts,
          ls_tline TYPE tline.
    FIELD-SYMBOLS: <ls_invoice_note> TYPE /itetr/com_note.

    LOOP AT ms_fica_data-texts INTO ls_texts.
      LOOP AT ls_texts-tline INTO ls_tline.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_tline-tdline.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD build_invoice_data_fica_party.


        ms_invoice_ubl-part1-accounting_customer_party-party = ubl_fill_partner_data( iv_address_number = ms_fica_data-t001-adrnr
                                                                                          iv_tax_id     = ms_document-taxid
                                                                                          iv_tax_office = ms_fica_data-tax_office
                                                                                          iv_profile_id = ms_document-prfid ).


  ENDMETHOD.


  METHOD build_invoice_data_fica_totals.

*    TYPES BEGIN OF ty_tax_total.
*    TYPES tax_code   TYPE string.
*    TYPES tax_name   TYPE string.
*    TYPES tax_rate   TYPE string.
*    TYPES exp_code   TYPE string.
*    TYPES exp_name   TYPE string.
*    TYPES tax_total  TYPE wrbtr.
*    TYPES tax_amount TYPE wrbtr.
*    TYPES tax_base   TYPE wrbtr.
*    TYPES witholding TYPE xfeld.
*    TYPES END OF ty_tax_total .
*
*    DATA: lt_tax_total    TYPE TABLE OF ty_tax_total,
*          ls_tax_total    TYPE ty_tax_total,
*          lv_base_amount  TYPE wrbtr,
*          lv_odenecek_top TYPE wrbtr,
*
*          ls_tax_data     TYPE /itetr/cl_regulative_common=>mty_tax_data,
*          ls_tax_match    TYPE /itetr/inv_taxm,
*
*          ls_t005         TYPE t005,
*          ls_invoice_line TYPE /itetr/com_invoice_line,
*          ls_dfkkopk      TYPE dfkkopk,
*          ls_vergi        TYPE dfkkopk,
*
*          ls_tax_subtotal    TYPE /itetr/com_tax_subtotal,
*          ls_line_tax_total  TYPE /itetr/com_withholding_tax_tot,
*          ls_tax_exemption   TYPE /itetr/cl_regulative_common=>mty_tax_exemption.
*
*    FIELD-SYMBOLS: <ls_tax_total>    TYPE /itetr/com_withholding_tax_tot,
*                   <ls_tax_subtotal> TYPE /itetr/com_tax_subtotal.
*
*    READ TABLE ms_fica_data-t005
*      INTO ls_t005
*      WITH TABLE KEY land1 = ms_fica_data-t001-land1.
*
*    LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
*      ADD ls_invoice_line-line_extension_amount-base-content TO ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
*    ENDLOOP.
*
*    lv_base_amount = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
*
*    LOOP AT ms_fica_data-dfkkopk INTO ls_dfkkopk.
*
*      LOOP AT ms_fica_data-t030k TRANSPORTING NO FIELDS
*        WHERE ktopl EQ ms_fica_data-t001-ktopl
*          AND konts EQ ls_dfkkopk-hkont.
*        EXIT.
*      ENDLOOP.
*      IF sy-subrc EQ 0.
*        MOVE-CORRESPONDING ls_dfkkopk TO ls_vergi.
*        ADD ls_dfkkopk-betrh TO lv_odenecek_top.
*        CONTINUE.
*      ENDIF.
*        ADD ls_dfkkopk-betrh TO lv_odenecek_top.
*      ls_tax_match = get_tax_match( iv_kalsm = ls_t005-kalsm
*                                    iv_mwskz  = ls_vergi-mwskz ).
*      APPEND INITIAL LINE TO ms_invoice_ubl-part1-tax_total ASSIGNING <ls_tax_total>.
*      <ls_tax_total>-tax_amount-base-currency_id = ms_fica_data-dfkkop-waers.
*      <ls_tax_total>-tax_amount-base-content = LS_VERGI-BETRH.
*
*      APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*      ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-taxty ).
*      <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*      <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-taxty.
*
*      IF ms_document-taxex IS NOT INITIAL.
*        <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ms_document-taxex.
*        ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ms_document-taxex ).
*      ELSE.
*        <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ls_tax_match-taxex.
*        ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ls_tax_match-taxex ).
*      ENDIF.
*      <ls_tax_subtotal>-tax_category-tax_exemption_reason-base-base-content = ls_tax_exemption-bezei.
*      <ls_tax_subtotal>-taxable_amount-base-content = lv_base_amount.
*
*      <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_fica_data-dfkkop-waers.
*      <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
*      <ls_tax_subtotal>-tax_amount-base-content = LS_VERGI-BETRH.
*      <ls_tax_subtotal>-tax_amount-base-currency_id = ms_fica_data-dfkkop-waers.
*
*    ENDLOOP.
*
*    LOOP AT ls_invoice_line-tax_total-tax_subtotal INTO ls_tax_subtotal.
*      ls_tax_total-tax_code  = ls_tax_subtotal-tax_category-tax_scheme-tax_type_code-base-base-content.
*      ls_tax_total-tax_name  = ls_tax_subtotal-tax_category-tax_scheme-name-base-base-content.
*      ls_tax_total-tax_rate  = ls_tax_subtotal-percent-base-base-content.
*      ls_tax_total-exp_code  = ls_tax_subtotal-tax_category-tax_exemption_reason_code-base-base-content.
*      ls_tax_total-exp_name  = ls_tax_subtotal-tax_category-tax_exemption_reason-base-base-content.
*      ls_tax_total-tax_amount = ls_tax_subtotal-tax_amount-base-content.
*      ls_tax_total-tax_total = ls_line_tax_total-tax_amount-base-content.
*      ls_tax_total-tax_base  = ls_tax_subtotal-taxable_amount-base-content.
*      ls_tax_total-witholding = 'X'.
*      COLLECT ls_tax_total INTO lt_tax_total.
*    ENDLOOP.
*
*    ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-currency_id = ms_fica_data-dfkkko-waers.
*    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content = lv_base_amount.
*    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-currency_id = ms_fica_data-dfkkko-waers.
**    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_fica_data-dfkkopk_partner-betrh.
*    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = lv_odenecek_top.
*    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-currency_id = ms_fica_data-dfkkko-waers.
**    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_fica_data-dfkkopk_partner-betrh.
*    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = lv_odenecek_top.
*    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id = ms_fica_data-dfkkko-waers.

    TYPES BEGIN OF ty_tax_total.
    TYPES tax_code   TYPE string.
    TYPES tax_name   TYPE string.
    TYPES tax_rate   TYPE string.
    TYPES exp_code   TYPE string.
    TYPES exp_name   TYPE string.
    TYPES tax_total  TYPE string.
    TYPES tax_amount TYPE wrbtr.
    TYPES tax_base   TYPE wrbtr.
    TYPES witholding TYPE xfeld.
    TYPES END OF ty_tax_total .
    DATA: lt_tax_total        TYPE TABLE OF ty_tax_total,
          ls_tax_total        TYPE ty_tax_total,
          ls_tax_total_ubl    TYPE /itetr/com_tax_total,
          ls_invoice_line     TYPE /itetr/com_invoice_line,
          ls_allowance_charge TYPE /itetr/com_allowance_charge,
          ls_tax_subtotal     TYPE /itetr/com_tax_subtotal,
          ls_line_tax_total   TYPE /itetr/com_withholding_tax_tot.
    FIELD-SYMBOLS: <ls_tax_total>    TYPE /itetr/com_withholding_tax_tot,
                   <ls_tax_subtotal> TYPE /itetr/com_tax_subtotal.

    LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
      ADD ls_invoice_line-line_extension_amount-base-content TO ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
      LOOP AT ls_invoice_line-allowance_charge INTO ls_allowance_charge.
        IF ls_allowance_charge-charge_indicator-base-content = abap_false.
          ADD ls_allowance_charge-amount-base-content      TO ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-content.
          ADD ls_allowance_charge-amount-base-content      TO ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
        ELSE.
          ADD ls_allowance_charge-amount-base-content      TO ms_invoice_ubl-part1-legal_monetary_total-charge_total_amount-base-content.
          SUBTRACT ls_allowance_charge-amount-base-content FROM ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
        ENDIF.
      ENDLOOP.
    ENDLOOP.


    fill_common_tax_totals( ).



    ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-currency_id = ms_fica_data-dfkkko-waers.
    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-currency_id = ms_fica_data-dfkkko-waers.
    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-currency_id = ms_fica_data-dfkkko-waers.
    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id = ms_fica_data-dfkkko-waers.

    LOOP AT ms_invoice_ubl-part1-tax_total INTO ls_tax_total_ubl.
      ADD ls_tax_total_ubl-tax_amount-base-content TO ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content.
      ADD ls_tax_total_ubl-tax_amount-base-content TO ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content.
    ENDLOOP.
  ENDMETHOD.


  METHOD build_invoice_data_rmrp.
    ms_invrec_data = get_data_rmrp( iv_belnr = ms_document-belnr
                                    iv_gjahr = ms_document-gjahr ).
    build_invoice_data_rmrp_head( ).
    build_invoice_data_rmrp_ref( ).
    build_invoice_data_rmrp_party( ).
    build_invoice_data_rmrp_item( ).
    build_invoice_data_rmrp_totals( ).
    build_invoice_data_rmrp_notes( ).
    fill_common_invoice_data( ).
  ENDMETHOD.


  METHOD build_invoice_data_rmrp_export.


    DATA: ls_maw1       TYPE maw1,
          ls_marc       TYPE marc,
          ls_ekko       TYPE ekko,
          ls_ekpo       TYPE ekpo,
          lv_vsart      TYPE ekko-vsart,
          ls_lfa1       TYPE lfa1.

    IF is_itemdata IS NOT INITIAL.

      rs_data-kunwe = is_headerdata-diff_inv.

      SELECT SINGLE adrnr FROM lfa1
        INTO CORRESPONDING FIELDS OF ls_lfa1
       WHERE lifnr EQ  is_headerdata-diff_inv.
      IF  sy-subrc IS INITIAL.
        rs_data-adrwe = ls_lfa1-adrnr.
      ENDIF.

      CLEAR ls_ekko.
      READ TABLE ms_invrec_data-ekko
      INTO ls_ekko
      WITH TABLE KEY ebeln = is_itemdata-po_number.

      rs_data-inco1 = ls_ekko-inco1.
      lv_vsart      = ls_ekko-vsart.

      IF lv_vsart IS NOT INITIAL.
        SELECT SINGLE trnty
          FROM /itetr/com_trmm
          INTO rs_data-trnty
          WHERE vsart = lv_vsart.
      ENDIF.

      CLEAR ls_ekpo.

      READ TABLE ms_invrec_data-ekpo
      INTO ls_ekpo
      WITH KEY ebeln = is_itemdata-po_number
               ebelp = is_itemdata-po_item.

      IF sy-subrc EQ 0 .

        READ TABLE ms_invrec_data-maw1
        INTO ls_maw1
        WITH TABLE KEY matnr = ls_ekpo-matnr.

        IF sy-subrc IS INITIAL.
          rs_data-hscod = ls_maw1-wstaw.
        ELSE.
          READ TABLE ms_invrec_data-marc
            INTO ls_marc
            WITH TABLE KEY matnr = ls_ekpo-matnr
                           werks = ls_ekpo-werks.
          IF sy-subrc IS INITIAL.
            rs_data-hscod = ls_marc-stawn.
          ENDIF.
        ENDIF.
      ENDIF.


    ENDIF.

    IF is_materialdata IS NOT INITIAL.

      rs_data-kunwe = is_headerdata-diff_inv.

      SELECT SINGLE adrnr FROM lfa1
        INTO CORRESPONDING FIELDS OF ls_lfa1
       WHERE lifnr EQ is_headerdata-diff_inv.
      IF  sy-subrc IS INITIAL.
        rs_data-adrwe = ls_lfa1-adrnr.
      ENDIF.

* Malzeme yönlü olanlarda satın alma belgesi olmadığından inco1 vsart alanlarını bulamıyoruz.
*Bu tarz bir madde çıktığında müşterinin sistemine göre exitlerde geliştirme yapılmalı


*      rs_data-inco1 = ????.
*      lv_vsart      = ????.

*      IF lv_vsart IS NOT INITIAL.
*        SELECT SINGLE trnty
*          FROM /itetr/com_trmm
*          INTO rs_data-trnty
*          WHERE vsart = lv_vsart.
*      ENDIF.

      READ TABLE ms_invrec_data-maw1
      INTO ls_maw1
      WITH TABLE KEY matnr = is_materialdata-material.

      IF sy-subrc IS INITIAL.
        rs_data-hscod = ls_maw1-wstaw.
      ELSE.
        READ TABLE ms_invrec_data-marc
          INTO ls_marc
          WITH TABLE KEY matnr = is_materialdata-material
                         werks = is_materialdata-val_area.
        IF sy-subrc IS INITIAL.
          rs_data-hscod = ls_marc-stawn.
        ENDIF.
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD build_invoice_data_rmrp_head.
    CONCATENATE ms_invrec_data-headerdata-doc_date+0(4)
                ms_invrec_data-headerdata-doc_date+4(2)
                ms_invrec_data-headerdata-doc_date+6(2)
      INTO ms_invoice_ubl-part1-issue_date-base-content
      SEPARATED BY '-'.
    ms_invoice_ubl-part1-document_currency_code-base-base-content = ms_invrec_data-headerdata-currency.

    IF ms_invrec_data-headerdata-currency NE ms_invrec_data-t001-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-source_currency_code-base-base-content = ms_invrec_data-headerdata-currency.
      ms_invoice_ubl-part1-pricing_exchange_rate-target_currency_code-base-base-content = ms_invrec_data-t001-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-calculation_rate-base-base-content = ms_invrec_data-headerdata-exch_rate.
      CONDENSE ms_invoice_ubl-part1-pricing_exchange_rate-calculation_rate-base-base-content.
      ms_invoice_ubl-part1-pricing_exchange_rate-date-base-content = ms_invoice_ubl-part1-issue_date-base-content.
      ms_invoice_ubl-part1-pricing_currency_code-base-base-content = ms_invrec_data-headerdata-currency.
    ENDIF.
  ENDMETHOD.


  METHOD build_invoice_data_rmrp_ihrac.
    DATA: ls_maw1 TYPE maw1,
          ls_marc TYPE marc,
          ls_ekko TYPE ekko,
          ls_ekpo TYPE ekpo.

    IF is_itemdata IS NOT INITIAL.

      CLEAR ls_ekpo.

      READ TABLE ms_invrec_data-ekpo
      INTO ls_ekpo
      WITH KEY ebeln = is_itemdata-po_number
               ebelp = is_itemdata-po_item.

      IF sy-subrc EQ 0 .

        READ TABLE ms_invrec_data-maw1
        INTO ls_maw1
        WITH TABLE KEY matnr = ls_ekpo-matnr.

        IF sy-subrc IS INITIAL.
          rv_hscode = ls_maw1-wstaw.
        ELSE.
          READ TABLE ms_invrec_data-marc
            INTO ls_marc
            WITH TABLE KEY matnr = ls_ekpo-matnr
                           werks = ls_ekpo-werks.
          IF sy-subrc IS INITIAL.
            rv_hscode = ls_marc-stawn.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF is_materialdata IS NOT INITIAL.

      READ TABLE ms_invrec_data-maw1
           INTO ls_maw1
           WITH TABLE KEY matnr = is_materialdata-material.

      IF sy-subrc IS INITIAL.
        rv_hscode = ls_maw1-wstaw.
      ELSE.
        READ TABLE ms_invrec_data-marc
          INTO ls_marc
          WITH TABLE KEY matnr = is_materialdata-material
                         werks = is_materialdata-val_area.
        IF sy-subrc IS INITIAL.
          rv_hscode = ls_marc-stawn.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD build_invoice_data_rmrp_item.
    DATA: ls_t005 TYPE t005.
    collect_items_rmrp( ).
    READ TABLE ms_invrec_data-t005
      INTO ls_t005
      WITH TABLE KEY land1 = ms_invrec_data-t001-land1.
    build_invoice_data_common_item( ls_t005-kalsm ).
  ENDMETHOD.


  METHOD build_invoice_data_rmrp_notes.
    DATA: ls_texts         TYPE /itetr/cl_outgoing_invoice=>mty_texts,
          ls_tline         TYPE tline,
          ls_eirule_input  TYPE /itetr/inv_s_eirules_in, "hkizilkaya
          lt_eirule_output TYPE /itetr/inv_tt_eirules_out, "hkizilkaya
          ls_eirule_output TYPE /itetr/inv_s_eirules_out, "hkizilkaya
          ls_earule_input  TYPE /itetr/inv_s_earules_in, "hkizilkaya
          lt_earule_output TYPE /itetr/inv_tt_earules_out, "hkizilkaya
          ls_earule_output TYPE /itetr/inv_s_earules_out. "hkizilkaya
    FIELD-SYMBOLS: <ls_invoice_note> TYPE /itetr/com_note.

    LOOP AT ms_invrec_data-texts INTO ls_texts.
      LOOP AT ls_texts-tline INTO ls_tline.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_tline-tdline.
      ENDLOOP.
    ENDLOOP.

    " <--- hkizilkaya
    ls_eirule_input-agent = ms_document-agent.
    ls_eirule_input-awtyp = ms_document-awtyp.
*    ls_eirule_input-mmdty = ms_accdoc_data
    ls_eirule_input-lifnr = ms_document-lifnr.
    ls_eirule_input-werks = ms_document-werks.
    ls_eirule_input-ityin = ms_document-invty.
    ls_eirule_input-pidin = ms_document-prfid.

    IF ms_document-prfid NE 'EARSIV'.
      get_einvoice_rule(
        EXPORTING
          iv_rule_type   = 'N'                 " Fatura kural tipi
          is_rule_input  = ls_eirule_input     " e-Fatura kural giriş
        RECEIVING
          rt_rule_output = lt_eirule_output    " e-Fatura kural çıkış
      ).
      LOOP AT lt_eirule_output INTO ls_eirule_output.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_eirule_output-note.
      ENDLOOP.
    ELSE.
      MOVE-CORRESPONDING ls_eirule_input TO ls_earule_input.
      get_earchive_rule(
        EXPORTING
          iv_rule_type   = 'N'                 " Fatura kural tipi
          is_rule_input  = ls_earule_input     " e-Arşiv kural giriş
        RECEIVING
          rt_rule_output = lt_earule_output    " e-Arşiv kural çıkışı table type
      ).
      LOOP AT lt_earule_output INTO ls_earule_output.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_earule_output-note.
      ENDLOOP.
    ENDIF.
    " hkizilkaya --->

  ENDMETHOD.


  METHOD build_invoice_data_rmrp_party.
    CASE ms_document-prfid.
      WHEN 'IHRACAT'.
        ms_invoice_ubl-part1-accounting_customer_party-party = ubl_fill_other_party_data( iv_prtty = 'C' ).
        ms_invoice_ubl-part1-buyer_customer_party-party = ubl_fill_partner_data( iv_address_number = ms_invrec_data-address_number
                                                                                 iv_tax_office     = ms_invrec_data-tax_office
                                                                                 iv_tax_id         = ms_invrec_data-taxid
                                                                                 iv_profile_id     = ms_document-prfid ).
      WHEN OTHERS.
        ms_invoice_ubl-part1-accounting_customer_party-party = ubl_fill_partner_data( iv_address_number = ms_invrec_data-address_number
                                                                                          iv_tax_id     = ms_invrec_data-taxid
                                                                                          iv_tax_office = ms_invrec_data-tax_office
                                                                                          iv_profile_id = ms_document-prfid ).
    ENDCASE.
  ENDMETHOD.


  METHOD build_invoice_data_rmrp_ref.
    DATA: ls_ekbe TYPE ekbe,
          ls_mkpf TYPE mkpf,
          lv_len  TYPE i.
    FIELD-SYMBOLS: <ls_desdoc_ref> TYPE /itetr/com_despatch_document_r.

    "gkadioglu
    LOOP AT ms_invrec_data-mkpf INTO ls_mkpf.
      lv_len = strlen(  ls_mkpf-xblnr ).
      IF lv_len = 16.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-despatch_document_reference ASSIGNING <ls_desdoc_ref>.
        <ls_desdoc_ref>-id-base-base-content = ls_mkpf-xblnr.
        CONCATENATE ls_mkpf-budat+0(4)
                    ls_mkpf-budat+4(2)
                    ls_mkpf-budat+6(2)
        INTO <ls_desdoc_ref>-issue_date-base-content
        SEPARATED BY '-'.
      ENDIF.
      CLEAR:lv_len.
    ENDLOOP.

    IF ms_invoice_ubl-part1-despatch_document_reference[] IS INITIAL.
      LOOP AT ms_invrec_data-ekbe INTO ls_ekbe.
        CHECK ls_ekbe-vgabe = '1' AND ls_ekbe-menge IS NOT INITIAL.
        READ TABLE ms_invrec_data-mseg
          WITH TABLE KEY mblnr = ls_ekbe-belnr
                         mjahr = ls_ekbe-gjahr
                         zeile = ls_ekbe-buzei
                         TRANSPORTING NO FIELDS.
        CHECK sy-subrc IS INITIAL.

        APPEND INITIAL LINE TO ms_invoice_ubl-part1-despatch_document_reference ASSIGNING <ls_desdoc_ref>.
        IF ls_ekbe-xblnr IS NOT INITIAL.
          <ls_desdoc_ref>-id-base-base-content = ls_ekbe-xblnr.
        ELSE.
          <ls_desdoc_ref>-id-base-base-content = ls_ekbe-belnr.
        ENDIF.
        CONCATENATE ls_ekbe-budat+0(4)
                    ls_ekbe-budat+4(2)
                    ls_ekbe-budat+6(2)
          INTO <ls_desdoc_ref>-issue_date-base-content
          SEPARATED BY '-'.
      ENDLOOP.
    ENDIF.

    SORT ms_invoice_ubl-part1-despatch_document_reference BY id-base-base-content.
    DELETE ADJACENT DUPLICATES FROM ms_invoice_ubl-part1-despatch_document_reference COMPARING id-base-base-content.

  ENDMETHOD.


  METHOD build_invoice_data_rmrp_totals.
    DATA lv_amount TYPE wrbtr.
    DATA: ls_t005            TYPE t005,
          ls_invoice_line    TYPE /itetr/com_invoice_line,
          ls_taxdata         TYPE bapi_incinv_detail_tax,
          ls_tax_match       TYPE /itetr/inv_taxm,
          ls_tax_data        TYPE /itetr/cl_regulative_common=>mty_tax_data,
          ls_tax_exemption   TYPE /itetr/cl_regulative_common=>mty_tax_exemption,
          ls_parent_tax_data TYPE /itetr/cl_regulative_common=>mty_tax_data.
    FIELD-SYMBOLS: <ls_tax_total>    TYPE /itetr/com_tax_total,
                   <ls_tax_subtotal> TYPE /itetr/com_tax_subtotal.

    READ TABLE ms_invrec_data-t005
      INTO ls_t005
      WITH TABLE KEY land1 = ms_invrec_data-t001-land1.

    LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
      ADD ls_invoice_line-line_extension_amount-base-content TO ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
    ENDLOOP.

*    LOOP AT ms_invrec_data-taxdata INTO ls_taxdata.
*      lv_amount = ls_taxdata-tax_amount.
*      ls_tax_match = get_tax_match( iv_kalsm = ls_t005-kalsm iv_mwskz = ls_taxdata-tax_code ).
*      APPEND INITIAL LINE TO ms_invoice_ubl-part1-tax_total ASSIGNING <ls_tax_total>.
*      <ls_tax_total>-tax_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*      ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-taxty ).
*      IF ls_tax_match-txtyp IS INITIAL.
*        <ls_tax_total>-tax_amount-base-content = lv_amount.
*
*        APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*        <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*        <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-taxty.
*        IF lv_amount IS INITIAL OR ms_document-invty = 'IHRACKAYIT'.
*          IF ms_document-taxex IS NOT INITIAL.
*            ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ms_document-taxex ).
*            <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ms_document-taxex.
*          ELSE.
*            ls_tax_exemption = /itetr/cl_regulative_common=>get_tax_exemption( ls_tax_match-taxex ).
*            <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ls_tax_match-taxex.
*          ENDIF.
*          <ls_tax_subtotal>-tax_category-tax_exemption_reason-base-base-content = ls_tax_exemption-bezei.
*        ENDIF.
*        <ls_tax_subtotal>-taxable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
*        <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*        <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
*        <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
*        <ls_tax_subtotal>-tax_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*      ELSE.
*        lv_amount = ( ( ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content * ls_tax_match-txrtp ) / 100 ) * ( 1 - ls_tax_match-taxrt / 100 ).
*        <ls_tax_total>-tax_amount-base-content = lv_amount.
*        APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*        ls_parent_tax_data = /itetr/cl_regulative_common=>get_tax_data( ls_tax_match-txtyp ).
*        <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_parent_tax_data-ltext.
*        <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-txtyp.
*        <ls_tax_subtotal>-taxable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
*        <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*        <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-txrtp.
*        lv_amount = ( ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content * ls_tax_match-txrtp ) / 100.
*        <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
*        <ls_tax_subtotal>-tax_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*
*        IF ls_tax_data-taxct = 'TEV'.
*          APPEND INITIAL LINE TO ms_invoice_ubl-part1-withholding_tax_total ASSIGNING <ls_tax_total>.
*          lv_amount = ( ( ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
*          <ls_tax_total>-tax_amount-base-content = lv_amount.
*          <ls_tax_total>-tax_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*          APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*        ELSE.
*          APPEND INITIAL LINE TO ms_invoice_ubl-part1-withholding_tax_total ASSIGNING <ls_tax_total>.
*          APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
*        ENDIF.
*        IF ms_document-taxty IS NOT INITIAL.
*          <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ms_document-taxty.
*          ls_tax_data = /itetr/cl_regulative_common=>get_tax_data( ms_document-taxty ).
*          <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*        ELSE.
*          <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_match-taxty.
*          <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_data-ltext.
*        ENDIF.
*        lv_amount = ( ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content * ls_tax_match-txrtp ) / 100.
*        <ls_tax_subtotal>-taxable_amount-base-content = lv_amount.
*        <ls_tax_subtotal>-taxable_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*        <ls_tax_subtotal>-percent-base-base-content = ls_tax_match-taxrt.
*        lv_amount = ( ( ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content * ls_tax_match-txrtp ) / 100 ) * ( ls_tax_match-taxrt / 100 ).
*        <ls_tax_subtotal>-tax_amount-base-content = lv_amount.
*        <ls_tax_subtotal>-tax_amount-base-currency_id = ms_invrec_data-headerdata-currency.
*      ENDIF.
*    ENDLOOP.
* Osman Şişmanoğlu vergi toplamı-> kalemden alınacak şekilde ortaklaştırıldı
    fill_common_tax_totals( ).

    ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-currency_id = ms_invrec_data-headerdata-currency.
    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-currency_id = ms_invrec_data-headerdata-currency.
    lv_amount = ms_invrec_data-headerdata-gross_amnt.
    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content + ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content.
*    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = lv_amount.
    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-currency_id = ms_invrec_data-headerdata-currency.
    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = lv_amount.
    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id = ms_invrec_data-headerdata-currency.
  ENDMETHOD.


  METHOD build_invoice_data_vbrk.
    ms_billing_data = get_data_vbrk( iv_vbeln = ms_document-belnr ).
    build_invoice_data_vbrk_head( ).
    build_invoice_data_vbrk_ref( ).
    build_invoice_data_vbrk_party( ).
    build_invoice_data_vbrk_item( ).
    build_invoice_data_vbrk_totals( ).
    build_invoice_data_vbrk_notes( ).
    fill_common_invoice_data( ).
  ENDMETHOD.


  METHOD build_invoice_data_vbrk_export.
    DATA: ls_vbpa       TYPE vbpavb,
          ls_likp       TYPE likp,
          lv_vsart      TYPE likp-vsart,
          ls_vbak       TYPE vbak,
          ls_vbkd       TYPE vbkd,
          ls_maw1       TYPE maw1,
          ls_marc       TYPE marc,
          ls_conditions TYPE /itetr/inv_cond,
          ls_konv       TYPE komv.
    READ TABLE ms_billing_data-vbpa
      INTO ls_vbpa
      WITH TABLE KEY by_parvw
      COMPONENTS parvw = 'WE'.
    IF sy-subrc IS INITIAL.
      rs_data-kunwe = ls_vbpa-kunnr.
      rs_data-adrwe = ls_vbpa-adrnr.
    ENDIF.

    rs_data-inco1 = ms_billing_data-vbrk-inco1.

    READ TABLE ms_billing_data-likp
      INTO ls_likp
      WITH TABLE KEY vbeln = is_vbrp-vgbel.
    IF ls_likp-vsart IS NOT INITIAL.
      lv_vsart = ls_likp-vsart.
    ELSE.
      READ TABLE ms_billing_data-vbak
        INTO ls_vbak
        WITH TABLE KEY vbeln = is_vbrp-aubel.
      IF sy-subrc IS INITIAL.
        READ TABLE ms_billing_data-vbkd
          INTO ls_vbkd
          WITH TABLE KEY vbeln = ls_vbak-vbeln
                         posnr = '000000'.
        IF sy-subrc IS INITIAL AND ls_vbkd-vsart IS NOT INITIAL.
          lv_vsart = ls_vbkd-vsart.
        ENDIF.
      ENDIF.
    ENDIF.


    IF lv_vsart IS NOT INITIAL.
      SELECT SINGLE trnty
        FROM /itetr/com_trmm
        INTO rs_data-trnty
        WHERE vsart = lv_vsart.
    ENDIF.

    IF lv_vsart IS INITIAL AND rs_data-trnty IS INITIAL  .
*-- Export faturalarda gönderim şekli .
      SELECT SINGLE expvz FROM eikp INTO rs_data-trnty
        WHERE exnum = ms_billing_data-vbrk-exnum .
    ENDIF.


    READ TABLE ms_billing_data-maw1
      INTO ls_maw1
      WITH TABLE KEY matnr = is_vbrp-matnr.
    IF sy-subrc IS INITIAL.
      rs_data-hscod = ls_maw1-wstaw.
    ELSE.
      READ TABLE ms_billing_data-marc
        INTO ls_marc
        WITH TABLE KEY matnr = is_vbrp-matnr
                       werks = is_vbrp-werks.
      IF sy-subrc IS INITIAL.
        rs_data-hscod = ls_marc-stawn.
      ENDIF.
    ENDIF.

    READ TABLE ms_billing_data-conditions
      INTO ls_conditions
      WITH TABLE KEY by_cndty
      COMPONENTS cndty = 'F'.
    IF sy-subrc IS INITIAL.
      READ TABLE ms_billing_data-konv
        INTO ls_konv
        WITH TABLE KEY by_kschl
        COMPONENTS kposn = is_vbrp-posnr
                   kschl = ls_conditions-kschl
                   kinak = space.
      IF sy-subrc IS INITIAL.
        rs_data-kwrfr = abs( ls_konv-kwert ).
      ENDIF.
    ENDIF.

    READ TABLE ms_billing_data-conditions
      INTO ls_conditions
      WITH TABLE KEY by_cndty
      COMPONENTS cndty = 'I'.
    IF sy-subrc IS INITIAL.
      READ TABLE ms_billing_data-konv
        INTO ls_konv
        WITH TABLE KEY by_kschl
        COMPONENTS kposn = is_vbrp-posnr
                   kschl = ls_conditions-kschl
                   kinak = space.
      IF sy-subrc IS INITIAL.
        rs_data-kwrin = abs( ls_konv-kwert ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD build_invoice_data_vbrk_head.
    DATA: lt_top_text TYPE TABLE OF vtopis,
          ls_top_text TYPE vtopis.

    CONCATENATE ms_billing_data-vbrk-fkdat+0(4)
                ms_billing_data-vbrk-fkdat+4(2)
                ms_billing_data-vbrk-fkdat+6(2)
      INTO ms_invoice_ubl-part1-issue_date-base-content
      SEPARATED BY '-'.
    ms_invoice_ubl-part1-document_currency_code-base-base-content = ms_billing_data-vbrk-waerk.
    IF ms_billing_data-vbrk-zterm IS NOT INITIAL.
      CALL FUNCTION 'SD_PRINT_TERMS_OF_PAYMENT'
        EXPORTING
          bldat                        = ms_billing_data-vbrk-fkdat
          budat                        = ms_billing_data-vbrk-fkdat
          cpudt                        = ms_billing_data-vbrk-erdat
          language                     = sy-langu
          terms_of_payment             = ms_billing_data-vbrk-zterm
          document_currency            = ms_billing_data-vbrk-waerk
        TABLES
          top_text                     = lt_top_text
        EXCEPTIONS
          terms_of_payment_not_in_t052 = 1
          OTHERS                       = 2.
      IF sy-subrc IS INITIAL.
        READ TABLE lt_top_text INTO ls_top_text INDEX 1.
        IF sy-subrc IS INITIAL.
          CONCATENATE ls_top_text-hdatum+0(4)
                      ls_top_text-hdatum+4(2)
                      ls_top_text-hdatum+6(2)
            INTO ms_invoice_ubl-part1-payment_terms-payment_due_date-base-content
            SEPARATED BY '-'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF ms_billing_data-vbrk-waerk NE ms_billing_data-t001-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-source_currency_code-base-base-content = ms_billing_data-vbrk-waerk.
      ms_invoice_ubl-part1-pricing_exchange_rate-target_currency_code-base-base-content = ms_billing_data-t001-waers.
      ms_invoice_ubl-part1-pricing_exchange_rate-calculation_rate-base-base-content = ms_billing_data-vbrk-kurrf.
      CONDENSE ms_invoice_ubl-part1-pricing_exchange_rate-calculation_rate-base-base-content.
      CONCATENATE ms_billing_data-vbrk-kurrf_dat+0(4)
                  ms_billing_data-vbrk-kurrf_dat+4(2)
                  ms_billing_data-vbrk-kurrf_dat+6(2)
        INTO ms_invoice_ubl-part1-pricing_exchange_rate-date-base-content
        SEPARATED BY '-'.
      ms_invoice_ubl-part1-pricing_currency_code-base-base-content = ms_billing_data-vbrk-waerk.
    ENDIF.
  ENDMETHOD.


  METHOD build_invoice_data_vbrk_item.
    DATA: ls_t005 TYPE t005.
    collect_items_vbrk( ).
    summarize_items( ).
    READ TABLE ms_billing_data-t005
      INTO ls_t005
      WITH TABLE KEY land1 = ms_billing_data-t001-land1.
    build_invoice_data_common_item( ls_t005-kalsm ).

  ENDMETHOD.


  METHOD build_invoice_data_vbrk_notes.
    DATA: ls_texts         TYPE /itetr/cl_outgoing_invoice=>mty_texts,
          ls_tline         TYPE tline,
          ls_vbrp          TYPE vbrp,
          ls_eirule_input  TYPE /itetr/inv_s_eirules_in, "hkizilkaya
          lt_eirule_output TYPE /itetr/inv_tt_eirules_out, "hkizilkaya
          ls_eirule_output TYPE /itetr/inv_s_eirules_out, "hkizilkaya
          ls_earule_input  TYPE /itetr/inv_s_earules_in, "hkizilkaya
          lt_earule_output TYPE /itetr/inv_tt_earules_out, "hkizilkaya
          ls_earule_output TYPE /itetr/inv_s_earules_out. "hkizilkaya

    FIELD-SYMBOLS: <ls_invoice_note> TYPE /itetr/com_note.
    LOOP AT ms_billing_data-texts INTO ls_texts.
      LOOP AT ls_texts-tline INTO ls_tline.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_tline-tdline.
      ENDLOOP.
    ENDLOOP.

    READ TABLE ms_billing_data-vbrp INTO ls_vbrp INDEX 1.
    IF sy-subrc = 0.
      ls_eirule_input-pstyv = ls_vbrp-pstyv.
    ENDIF.

    " <--- hkizilkaya
    ls_eirule_input-agent = ms_document-agent.
    ls_eirule_input-awtyp = ms_document-awtyp.
    ls_eirule_input-sddty = ms_billing_data-vbrk-fkart.
    ls_eirule_input-kunnr = ms_document-kunnr.
    ls_eirule_input-vkorg = ms_document-vkorg.
    ls_eirule_input-vtweg = ms_document-vtweg.
    ls_eirule_input-werks = ms_document-werks.
    ls_eirule_input-ktgrd = ms_billing_data-vbrk-ktgrd.
    ls_eirule_input-kalsm = ms_billing_data-vbrk-kalsm.
    ls_eirule_input-vbeln = ms_billing_data-vbrk-vbeln.
    ls_eirule_input-ityin = ms_document-invty.
    ls_eirule_input-pidin = ms_document-prfid.

    IF ms_document-prfid NE 'EARSIV'.
      get_einvoice_rule(
        EXPORTING
          iv_rule_type   = 'N'                 " Fatura kural tipi
          is_rule_input  = ls_eirule_input     " e-Fatura kural giriş
        RECEIVING
          rt_rule_output = lt_eirule_output    " e-Fatura kural çıkış
      ).
      LOOP AT lt_eirule_output INTO ls_eirule_output.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_eirule_output-note.
      ENDLOOP.
    ELSE.
      MOVE-CORRESPONDING ls_eirule_input TO ls_earule_input.
      get_earchive_rule(
        EXPORTING
          iv_rule_type   = 'N'                 " Fatura kural tipi
          is_rule_input  = ls_earule_input     " e-Arşiv kural giriş
        RECEIVING
          rt_rule_output = lt_earule_output    " e-Arşiv kural çıkışı table type
      ).
      LOOP AT lt_earule_output INTO ls_earule_output.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_earule_output-note.
      ENDLOOP.
    ENDIF.
    " hkizilkaya --->
  ENDMETHOD.


  METHOD build_invoice_data_vbrk_party.


    DATA : ls_adress TYPE /itetr/com_party.
    DATA : lv_adrnr TYPE kna1-adrnr,
           lv_name  TYPE text255.


    CASE ms_document-prfid.
      WHEN 'IHRACAT'.
        ms_invoice_ubl-part1-accounting_customer_party-party = ubl_fill_other_party_data( iv_prtty = 'C' ).
        ms_invoice_ubl-part1-buyer_customer_party-party = ubl_fill_partner_data( iv_address_number = ms_billing_data-address_number
                                                                                 iv_tax_office = ms_billing_data-tax_office
                                                                                 iv_tax_id = ms_billing_data-taxid
                                                                                 iv_profile_id = ms_document-prfid ).
      WHEN 'YOLCU'.
        ms_invoice_ubl-part1-accounting_customer_party-party = ubl_fill_other_party_data( iv_prtty = 'C' ).
        ms_invoice_ubl-part1-buyer_customer_party-party = ubl_fill_partner_data( iv_address_number = ms_billing_data-address_number
                                                                                 iv_tax_office = ms_billing_data-tax_office
                                                                                 iv_tax_id = ms_billing_data-taxid
                                                                                 iv_profile_id = ms_document-prfid ).
      WHEN OTHERS.
        ms_invoice_ubl-part1-accounting_customer_party-party = ubl_fill_partner_data( iv_address_number = ms_billing_data-address_number
                                                                                      iv_tax_office = ms_billing_data-tax_office
                                                                                      iv_tax_id = ms_billing_data-taxid
                                                                                      iv_profile_id = ms_document-prfid ).
    ENDCASE.


    IF mv_shipto_address IS NOT INITIAL.
      lv_adrnr = mv_shipto_address.

      CLEAR ls_adress.
      ls_adress = ubl_fill_partner_data( iv_address_number = lv_adrnr ).
      ms_invoice_ubl-part1-accounting_customer_party-party-physical_location-address = ls_adress-postal_address.

      IF ls_adress-person-first_name-base-base-content IS NOT INITIAL.
        CONCATENATE ls_adress-person-first_name-base-base-content
                    ls_adress-person-family_name-base-base-content INTO ms_invoice_ubl-part1-accounting_customer_party-party-physical_location-id-base-base-content.
      ELSE.
        ms_invoice_ubl-part1-accounting_customer_party-party-physical_location-id-base-base-content = ls_adress-party_name-name-base-base-content.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD build_invoice_data_vbrk_ref.
    DATA: ls_vbak  TYPE vbak,
          ls_vbkd  TYPE vbkd,
          ls_likp  TYPE likp,
          lv_wadat TYPE datum.
    FIELD-SYMBOLS: <ls_desdoc_ref> TYPE /itetr/com_despatch_document_r.

    READ TABLE ms_billing_data-vbak INTO ls_vbak INDEX 1.
    IF sy-subrc IS INITIAL.
      READ TABLE ms_billing_data-vbkd
        INTO ls_vbkd
        WITH TABLE KEY vbeln = ls_vbak-vbeln
                       posnr = '000000'.
      IF ls_vbkd-bstkd IS NOT INITIAL.
        ms_invoice_ubl-part1-order_reference-id-base-base-content = ls_vbkd-bstkd.
      ELSE.
        ms_invoice_ubl-part1-order_reference-id-base-base-content = ls_vbak-vbeln.
      ENDIF.
      CONCATENATE ls_vbak-audat+0(4)
                  ls_vbak-audat+4(2)
                  ls_vbak-audat+6(2)
        INTO ms_invoice_ubl-part1-order_reference-issue_date-base-content
        SEPARATED BY '-'.
    ENDIF.
    LOOP AT ms_billing_data-likp INTO ls_likp.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-despatch_document_reference ASSIGNING <ls_desdoc_ref>.
      IF ls_likp-xblnr IS NOT INITIAL.
        <ls_desdoc_ref>-id-base-base-content = ls_likp-xblnr.
      ELSEIF ls_likp-lifex IS NOT INITIAL.
        <ls_desdoc_ref>-id-base-base-content = ls_likp-lifex.
      ELSE.
        <ls_desdoc_ref>-id-base-base-content = ls_likp-vbeln.
      ENDIF.
      IF ls_likp-wadat_ist IS NOT INITIAL.
        lv_wadat = ls_likp-wadat_ist.
      ELSE.
        lv_wadat = ls_likp-bldat.
      ENDIF.
      CONCATENATE lv_wadat+0(4)
                  lv_wadat+4(2)
                  lv_wadat+6(2)
        INTO <ls_desdoc_ref>-issue_date-base-content
        SEPARATED BY '-'.
    ENDLOOP.
  ENDMETHOD.


  METHOD build_invoice_data_vbrk_totals.
    TYPES BEGIN OF ty_tax_total.
    TYPES tax_code   TYPE string.
    TYPES tax_name   TYPE string.
    TYPES tax_rate   TYPE string.
    TYPES exp_code   TYPE string.
    TYPES exp_name   TYPE string.
    TYPES tax_total  TYPE string.
    TYPES tax_amount TYPE wrbtr.
    TYPES tax_base   TYPE wrbtr.
    TYPES witholding TYPE xfeld.
    TYPES END OF ty_tax_total .
    DATA: lt_tax_total        TYPE TABLE OF ty_tax_total,
          ls_tax_total        TYPE ty_tax_total,
          ls_invoice_line     TYPE /itetr/com_invoice_line,
          ls_allowance_charge TYPE /itetr/com_allowance_charge,
          ls_tax_subtotal     TYPE /itetr/com_tax_subtotal,
          ls_line_tax_total   TYPE /itetr/com_withholding_tax_tot.
    FIELD-SYMBOLS: <ls_tax_total>    TYPE /itetr/com_withholding_tax_tot,
                   <ls_tax_subtotal> TYPE /itetr/com_tax_subtotal.

    LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
      ADD ls_invoice_line-line_extension_amount-base-content TO ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
      LOOP AT ls_invoice_line-allowance_charge INTO ls_allowance_charge.
        IF ls_allowance_charge-charge_indicator-base-content = abap_false.
          ADD ls_allowance_charge-amount-base-content      TO ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-content.
* Osman Şişmanoğlu genel toplamdaki mal hizmet tutarı iskonto düşülmemiş hali olmalı.
          ADD ls_allowance_charge-amount-base-content      TO ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
        ELSE.
          ADD ls_allowance_charge-amount-base-content      TO ms_invoice_ubl-part1-legal_monetary_total-charge_total_amount-base-content.
* Osman Şişmanoğlu genel toplamdaki mal hizmet tutarı artırım eklenmemiş hali olmalı.
          SUBTRACT ls_allowance_charge-amount-base-content FROM ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
* Osman Şişmanoğlu vergi toplamı-> kalemden alınacak şekilde ortaklaştırıldı
    fill_common_tax_totals( ).

    ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-currency_id = ms_billing_data-vbrk-waerk.
    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content = ms_billing_data-vbrk-netwr.
    ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-currency_id = ms_billing_data-vbrk-waerk.
    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content + ms_invoice_ubl-part1-legal_monetary_total-tax_exclusive_amount-base-content.
*    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content + ms_billing_data-vbrk-netwr.
    ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-currency_id = ms_billing_data-vbrk-waerk.
    IF ms_document-invty NE 'IHRACKAYIT'.
     " ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content.
      ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content + ms_billing_data-vbrk-netwr.
    ELSE.
      ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_billing_data-vbrk-netwr.
    ENDIF.
    ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id = ms_billing_data-vbrk-waerk.
    IF ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-content IS NOT INITIAL.
      ms_invoice_ubl-part1-legal_monetary_total-allowance_total_amount-base-currency_id = ms_billing_data-vbrk-waerk.
    ENDIF.
    IF ms_invoice_ubl-part1-legal_monetary_total-charge_total_amount-base-content IS NOT INITIAL.
      ms_invoice_ubl-part1-legal_monetary_total-charge_total_amount-base-currency_id = ms_billing_data-vbrk-waerk.
    ENDIF.
  ENDMETHOD.


  METHOD check_enerji_profile_type.
    "[MAI | 2026-08-20] Schematron InvoiceTypeCodeCheck (madde 17) — ENERJI profili ile SARJ/SARJANLIK
    "fatura tipi birbirini karsilikli gerektirir (biconditional): biri varsa digeri de olmali.
    "[MAI | 2026-08-27] raise_custom_error (serbest metin) yerine gercek mesaj numarasi 164 (&1/&2 ile
    "ProfileID/InvoiceTypeCode dinamik olarak T100 metnine gecirilir) kullanilir.
    DATA: lv_is_enerji TYPE abap_bool,
          lv_is_sarj   TYPE abap_bool,
          lx_exception TYPE REF TO /itetr/cx_regulative_exception.

    lv_is_enerji = COND abap_bool( WHEN iv_profile_id = 'ENERJI' THEN abap_true ELSE abap_false ).
    lv_is_sarj   = COND abap_bool( WHEN iv_invoice_type_code = 'SARJ' OR iv_invoice_type_code = 'SARJANLIK'
                                    THEN abap_true ELSE abap_false ).

    IF lv_is_enerji NE lv_is_sarj.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '164'
                                                                        iv_msgv1 = iv_profile_id
                                                                        iv_msgv2 = iv_invoice_type_code ).
      RAISE EXCEPTION lx_exception.
    ENDIF.
  ENDMETHOD.


  METHOD check_ihrackayitli_702_lines.
    "[MAI | 2026-08-20] Schematron TaxExemptionReasonCodeCheck IHRACKAYITLI+702 alt kurali (madde 6).
    "InvoiceTypeCode=IHRACKAYITLI ve TaxExemptionReasonCode=702 ise HER InvoiceLine'da GTIP (RequiredCustomsID,
    "12 hane) ve AliciSatirKodu (PartyIdentification[schemeID=ALICIDIBSATIRKOD], 11 hane) zorunludur.
    "KULLANICI KARARI (2026-08-20): Bu metod BUILD_INVOICE_DATA icinde HENUZ CAGRILMIYOR (bilincli olarak).
    "ALICIDIBSATIRKOD/RequiredCustomsID alanlarini dolduran hicbir kod bulunamadi (field-symbol'ler
    "build_invoice_data_rmrp_ihrac'ta tanimli ama atanmiyor) - veri kaynagi netlesmeden canliya baglanmayacak.
    "[MAI | 2026-08-27] raise_custom_error (serbest metin) yerine gercek mesaj numarasi 163 kullanilir.
    DATA: lx_exception TYPE REF TO /itetr/cx_regulative_exception.

    CHECK iv_invoice_type_code = 'IHRACKAYITLI' AND iv_exemption_reason_code = '702'.

    IF iv_matching_lines NE iv_total_lines.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '163'
                                                                        iv_msgv1 = /itetr/cl_regulative_common=>message_text_build( iv_msgno = '163'
                                                                                                                                    iv_msgty = 'E'  ) ) .
      RAISE EXCEPTION lx_exception.
    ENDIF.
  ENDMETHOD.


  METHOD collect_items_bkpf.
    DATA: lt_hkont      TYPE RANGE OF saknr,
          ls_hkont      LIKE LINE OF lt_hkont,
          ls_items      TYPE mty_item_collect,
          ls_bseg_lines TYPE bseg,
          ls_skat       TYPE skat,
          ls_accounts   TYPE /itetr/inv_fiac.

    LOOP AT ms_accdoc_data-accounts INTO ls_accounts.
      ls_hkont-sign = 'I'.
      ls_hkont-option = 'EQ'.
      ls_hkont-low = ls_accounts-saknr.
      APPEND ls_hkont TO lt_hkont.
    ENDLOOP.

    LOOP AT ms_accdoc_data-bseg INTO ls_bseg_lines  WHERE ( koart = 'S' OR
                                                                koart = 'A' )
                                                          AND shkzg = 'H' .
      IF ls_bseg_lines-lokkt IS NOT INITIAL.
        ls_bseg_lines-hkont = ls_bseg_lines-lokkt.
      ENDIF.
      CHECK ls_bseg_lines-hkont NOT IN lt_hkont.
      IF ls_bseg_lines-wrbtr IS INITIAL AND ls_bseg_lines-dmbtr IS NOT INITIAL.
        ls_bseg_lines-wrbtr = ls_bseg_lines-dmbtr.
      ENDIF.

      READ TABLE ms_accdoc_data-accounts
        WITH TABLE KEY saknr = ls_bseg_lines-hkont
        TRANSPORTING NO FIELDS.
      CHECK sy-subrc IS NOT INITIAL.

      CLEAR ls_items.
      ls_items-posnr = ls_bseg_lines-buzei.
      ls_items-matnr = ls_bseg_lines-matnr.
      ls_items-kdmat = ls_bseg_lines-hkont.

      IF ls_bseg_lines-sgtxt IS INITIAL AND ms_accdoc_data-bseg_partner-sgtxt IS INITIAL.
        READ TABLE ms_accdoc_data-skat
          INTO ls_skat
          WITH TABLE KEY saknr = ls_bseg_lines-hkont.
      ENDIF.
      IF ls_bseg_lines-sgtxt IS NOT INITIAL.
        ls_items-arktx = ls_bseg_lines-sgtxt.
      ELSEIF ms_accdoc_data-bseg_partner-sgtxt IS NOT INITIAL.
        ls_items-arktx = ms_accdoc_data-bseg_partner-sgtxt.
      ELSE.
        ls_items-arktx = ls_skat-txt50.
      ENDIF.
      IF ls_bseg_lines-menge IS NOT INITIAL.
        ls_items-fkimg = ls_bseg_lines-menge.
      ELSE.
        ls_items-fkimg = 1.
      ENDIF.
      IF ls_bseg_lines-meins IS NOT INITIAL.
        ls_items-vrkme = ls_bseg_lines-meins.
      ELSE.
        ls_items-vrkme = 'ST'.
      ENDIF.
      ls_items-netwr = ls_bseg_lines-wrbtr.
      ls_items-mwskz = ls_bseg_lines-mwskz.
      ls_items-waers = ms_accdoc_data-bkpf-waers.
      IF ms_document-itmcl IS NOT INITIAL.
        CLEAR ls_items-posnr.
        COLLECT ls_items INTO mt_invoice_items.
      ELSE.
        APPEND ls_items TO mt_invoice_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD collect_items_fica.

    DATA : ls_dfkkopk TYPE dfkkopk,
           ls_items   TYPE mty_item_collect.

*    LOOP AT ms_fica_data-dfkkopk INTO ls_dfkkopk WHERE gsber EQ '0001'.
    LOOP AT ms_fica_data-dfkkopk INTO ls_dfkkopk .
      CHECK ls_dfkkopk-kschl IS INITIAL.
      ls_items-posnr = ls_dfkkopk-opupk.
      ls_items-arktx = ms_fica_data-dfkkop-optxt.
      ls_items-kdmat = ms_fica_data-dfkkop-hkont.

      IF ls_items-arktx IS INITIAL.
        SELECT SINGLE txt50 INTO ls_items-arktx
            FROM skat
            WHERE spras EQ sy-langu
            AND   ktopl EQ ms_fica_data-t001-ktopl
            AND   saknr EQ ls_dfkkopk-hkont.
      ENDIF.

      ls_items-netwr = ls_dfkkopk-betrw.
      ls_items-mwskz = ls_dfkkopk-mwskz.
      ls_items-waers = ms_fica_data-dfkkko-waers.

      IF ls_dfkkopk-menge IS NOT INITIAL.
        ls_items-fkimg = ls_dfkkopk-menge.
      ELSE.
        ls_items-fkimg = 1.
      ENDIF.

      IF ls_dfkkopk-meins IS NOT INITIAL.
        ls_items-vrkme = ls_dfkkopk-meins.
      ELSE.
        ls_items-vrkme = 'ST'.
      ENDIF.

      IF ms_document-itmcl IS NOT INITIAL.
        CLEAR ls_items-posnr.
        COLLECT ls_items INTO mt_invoice_items.
      ELSE.
        APPEND ls_items TO mt_invoice_items.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD collect_items_rmrp.
    DATA: ls_invoice_items TYPE mty_item_collect,
          ls_itemdata      TYPE bapi_incinv_detail_item,
          ls_ekpo          TYPE ekpo,
          ls_makt          TYPE makt,
          ls_glaccountdata TYPE bapi_incinv_detail_gl_account,
          ls_materialdata  TYPE bapi_incinv_detail_material,
          ls_export_data   TYPE /itetr/cl_outgoing_invoice=>mty_export_spec_data.

    LOOP AT ms_invrec_data-itemdata INTO ls_itemdata.
      CLEAR ls_invoice_items.
      ls_invoice_items-posnr = ls_itemdata-invoice_doc_item.
      READ TABLE ms_invrec_data-ekpo
        INTO ls_ekpo
        WITH TABLE KEY ebeln = ls_itemdata-po_number
                       ebelp = ls_itemdata-po_item.
      IF sy-subrc IS INITIAL.
        READ TABLE ms_invrec_data-makt
          INTO ls_makt
          WITH TABLE KEY matnr = ls_ekpo-matnr.
      ENDIF.
      IF ls_makt-maktx IS NOT INITIAL.
        ls_invoice_items-arktx = ls_makt-maktx.
      ELSEIF ls_ekpo-txz01 IS NOT INITIAL.
        ls_invoice_items-arktx = ls_ekpo-txz01.
      ELSE.
        ls_invoice_items-arktx = ls_itemdata-item_text.
      ENDIF.
      ls_invoice_items-matnr = ls_ekpo-matnr.
      ls_invoice_items-fkimg = ls_itemdata-quantity.
      ls_invoice_items-vrkme = ls_itemdata-po_unit.
      ls_invoice_items-netwr = ls_itemdata-item_amount.
      ls_invoice_items-mwskz = ls_itemdata-tax_code.
      ls_invoice_items-waers = ms_invrec_data-headerdata-currency.

      IF ms_document-prfid = 'IHRACAT'.
        ls_export_data = build_invoice_data_rmrp_export(  is_headerdata = ms_invrec_data-headerdata
                                                          is_itemdata   = ls_itemdata                ).
        MOVE-CORRESPONDING ls_export_data TO ls_invoice_items.
      ENDIF.

      IF ms_document-invty = 'IHRACKAYIT' AND ms_document-taxex = '702'.
        ls_invoice_items-hscod = build_invoice_data_rmrp_ihrac(  is_headerdata = ms_invrec_data-headerdata
                                                                 is_itemdata   = ls_itemdata                ).
      ENDIF.

      IF ms_document-itmcl IS NOT INITIAL.
        COLLECT ls_invoice_items INTO mt_invoice_items.
      ELSE.
        APPEND ls_invoice_items TO mt_invoice_items.
      ENDIF.
    ENDLOOP.

    LOOP AT ms_invrec_data-glaccountdata INTO ls_glaccountdata.
      CLEAR ls_invoice_items.
      ls_invoice_items-posnr = ls_itemdata-invoice_doc_item.
      ls_invoice_items-arktx = ls_glaccountdata-item_text.
      ls_invoice_items-fkimg = 1.
      ls_invoice_items-vrkme = 'ST'.
      ls_invoice_items-netwr = ls_glaccountdata-item_amount.
      ls_invoice_items-mwskz = ls_glaccountdata-tax_code.
      ls_invoice_items-waers = ms_invrec_data-headerdata-currency.
      IF ms_document-itmcl IS NOT INITIAL.
        COLLECT ls_invoice_items INTO mt_invoice_items.
      ELSE.
        APPEND ls_invoice_items TO mt_invoice_items.
      ENDIF.
    ENDLOOP.

    LOOP AT ms_invrec_data-materialdata INTO ls_materialdata.
      CLEAR ls_invoice_items.
      ls_invoice_items-posnr = ls_itemdata-invoice_doc_item.
      READ TABLE ms_invrec_data-makt
        INTO ls_makt
        WITH TABLE KEY matnr = ls_materialdata-material.
      IF sy-subrc IS INITIAL.
        ls_invoice_items-arktx = ls_makt-maktx.
      ENDIF.
      ls_invoice_items-matnr = ls_materialdata-material.
      ls_invoice_items-fkimg = ls_materialdata-quantity.
      ls_invoice_items-vrkme = ls_materialdata-base_uom.
      ls_invoice_items-netwr = ls_materialdata-item_amount.
      ls_invoice_items-mwskz = ls_materialdata-tax_code.
      ls_invoice_items-waers = ms_invrec_data-headerdata-currency.

      IF ms_document-prfid = 'IHRACAT'.
        ls_export_data = build_invoice_data_rmrp_export(  is_headerdata   = ms_invrec_data-headerdata
                                                          is_materialdata = ls_materialdata            ).
        MOVE-CORRESPONDING ls_export_data TO ls_invoice_items.
      ENDIF.

      IF ms_document-invty = 'IHRACKAYIT' AND ms_document-taxex = '702'.
        ls_invoice_items-hscod = build_invoice_data_rmrp_ihrac(  is_headerdata   = ms_invrec_data-headerdata
                                                                 is_materialdata = ls_materialdata            ).
      ENDIF.


      IF ms_document-itmcl IS NOT INITIAL.
        CLEAR ls_invoice_items-posnr.
        COLLECT ls_invoice_items INTO mt_invoice_items.
      ELSE.
        APPEND ls_invoice_items TO mt_invoice_items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD collect_items_vbrk.
    DATA: ls_items               TYPE mty_item_collect,
          ls_items_zero          TYPE mty_item_collect,
          lv_taxrt               TYPE /itetr/inv_taxm-taxrt,
          ls_vbrp                TYPE vbrpvb,
          ls_vbap                TYPE vbap,
          ls_conditions          TYPE /itetr/inv_cond,
          ls_konv                TYPE komv,
          ls_maw1                TYPE maw1,
          lv_herkl               TYPE maw1-wherl,
          ls_marc                TYPE marc,
          ls_t005t               TYPE t005t,
          ls_export_data         TYPE /itetr/cl_outgoing_invoice=>mty_export_spec_data,
          ls_item_allowance      TYPE mty_item_allowance,
          ls_item_allowance_zero TYPE mty_item_allowance,
          ls_sddt                TYPE /itetr/inv_sddt,
          lt_sddt                TYPE TABLE OF  /itetr/inv_sddt,
          lv_summarize_text      TYPE text255.


    SELECT * FROM /itetr/inv_sddt INTO TABLE lt_sddt WHERE ( fkart =  ms_billing_data-vbrk-fkart OR fkart = space ) AND
                                                             summarize NE space.
    SORT lt_sddt BY fkart DESCENDING summarize DESCENDING.

    LOOP AT lt_sddt INTO ls_sddt WHERE ( fkart =  ms_billing_data-vbrk-fkart OR fkart = space ) AND
                                         summarize NE space. .
      EXIT.
    ENDLOOP.

    LOOP AT ms_billing_data-vbrp INTO ls_vbrp.
      CHECK ls_vbrp-fkimg IS NOT INITIAL.
      CLEAR ls_items.

      ls_items = CORRESPONDING #( ls_vbrp ).


      READ TABLE ms_billing_data-vbap
        INTO ls_vbap
        WITH TABLE KEY vbeln = ls_vbrp-aubel
                       posnr = ls_vbrp-aupos.
      IF sy-subrc IS INITIAL.
        ls_items-kdmat = ls_vbap-kdmat.
      ENDIF.


      READ TABLE ms_billing_data-conditions
        WITH TABLE KEY by_cndty
        COMPONENTS cndty = 'P'
        TRANSPORTING NO FIELDS.

      IF sy-subrc IS INITIAL.
        LOOP AT ms_billing_data-conditions INTO ls_conditions USING KEY by_cndty WHERE cndty = 'P'.
          READ TABLE ms_billing_data-konv
            INTO ls_konv
            WITH TABLE KEY by_kschl
            COMPONENTS kposn = ls_vbrp-posnr
                       kschl = ls_conditions-kschl
                       kinak = space.
          CHECK sy-subrc IS INITIAL.
          IF ls_konv-waers = ms_billing_data-vbrk-waerk.
            ls_items-netpr = ls_konv-kbetr.
          ELSE.
            ls_items-netpr = ls_konv-kbetr * ls_konv-kkurs.
          ENDIF.

          ls_items-peinh = ls_konv-kpein.
          ls_items-netwa = ms_billing_data-vbrk-waerk.
          IF ls_konv-kkurs IS NOT INITIAL AND
             ms_billing_data-vbrk-waerk NE ls_konv-waers AND
             ms_billing_data-vbrk-waerk EQ ms_billing_data-t001-waers.
            ms_billing_data-vbrk-kurrf = ls_konv-kkurs.
            ms_billing_data-vbrk-stwae = ls_konv-waers.
          ENDIF.

          EXIT.
        ENDLOOP.
      ENDIF.

      ls_items-waers = ms_billing_data-vbrk-waerk.
      CLEAR lv_summarize_text.
      CASE ls_sddt-summarize.
        WHEN '1'.
          IF ls_vbrp-uepos IS INITIAL.
            lv_summarize_text = ls_vbrp-posnr.
          ELSE.
            LOOP AT mt_invoice_items INTO ls_items_zero WHERE posnr = ls_vbrp-uepos.
              ls_items_zero-waers = ls_items-waers.
              ls_items_zero-netwa = ls_items-netwa.
              ls_items_zero-netwr = '0.00'.
              ls_items_zero-netpr = '0.00'.
              ls_items_zero-distr = '0.00'.
              ls_items_zero-surtr = '0.00'.
              ls_items_zero-mwsbp = '0.00'.
              ls_items_zero-kwrfr = '0.00'.
              ls_items_zero-othtx = '0.00'.
              ls_items_zero-dgrtx = '0.00'.
              MODIFY mt_invoice_items FROM ls_items_zero.
            ENDLOOP.
            LOOP AT mt_items_allowance INTO ls_item_allowance_zero WHERE posnr = ls_vbrp-uepos.
              ls_item_allowance_zero-distr = '0.00'.
              ls_item_allowance_zero-surtr = '0.00'.
              MODIFY mt_items_allowance FROM ls_item_allowance_zero.
            ENDLOOP.
            lv_summarize_text = ls_vbrp-uepos.
            CLEAR : ls_items-fkimg.
            CLEAR : ls_items-peinh.
          ENDIF.
        WHEN '2'. lv_summarize_text = ls_vbrp-matnr.
        WHEN '3'. lv_summarize_text = ls_vbrp-arktx.
*        WHEN '2'. lv_summarize_text = ls_vbrp-arktx.
*      WHEN '3'. lv_summarize_text = ls_item-sgtxt.
        WHEN '4'. lv_summarize_text = ls_vbrp-charg.
        WHEN '5'.
          IF ls_vbrp-uecha IS NOT INITIAL.
            lv_summarize_text = ls_vbrp-uecha.
          ELSE.
            lv_summarize_text = ls_vbrp-posnr.
          ENDIF.

        WHEN '6'.
          IF ls_vbrp-uepos IS INITIAL.
            lv_summarize_text = ls_vbrp-posnr.
            CLEAR : ls_items-fkimg.
            CLEAR : ls_items-peinh.
          ELSE.
            LOOP AT mt_invoice_items INTO ls_items_zero WHERE posnr = ls_vbrp-uepos.
              ls_items_zero-waers = ls_items-waers.
              ls_items_zero-netwa = ls_items-netwa.
              ls_items_zero-netwr = '0.00'.
              ls_items_zero-netpr = '0.00'.
              ls_items_zero-distr = '0.00'.
              ls_items_zero-surtr = '0.00'.
              ls_items_zero-mwsbp = '0.00'.
              ls_items_zero-kwrfr = '0.00'.
              ls_items_zero-othtx = '0.00'.
              ls_items_zero-dgrtx = '0.00'.
              MODIFY mt_invoice_items FROM ls_items_zero.
            ENDLOOP.
            LOOP AT mt_items_allowance INTO ls_item_allowance_zero WHERE posnr = ls_vbrp-uepos.
              ls_item_allowance_zero-distr = '0.00'.
              ls_item_allowance_zero-surtr = '0.00'.
              MODIFY mt_items_allowance FROM ls_item_allowance_zero.
            ENDLOOP.
            lv_summarize_text = ls_vbrp-uepos.
          ENDIF.
      ENDCASE.

      ls_items-summr = lv_summarize_text.


      READ TABLE ms_billing_data-maw1
        INTO ls_maw1
        WITH TABLE KEY matnr = ls_vbrp-matnr.
      IF sy-subrc IS INITIAL.
        lv_herkl = ls_maw1-wherl.
      ELSE.
        READ TABLE ms_billing_data-marc
          INTO ls_marc
          WITH TABLE KEY matnr = ls_vbrp-matnr
                         werks = ls_vbrp-werks.
        IF sy-subrc IS INITIAL.
          lv_herkl = ls_marc-herkl.
        ENDIF.
      ENDIF.

      IF lv_herkl IS NOT INITIAL.
        READ TABLE ms_billing_data-t005t
          INTO ls_t005t
          WITH TABLE KEY land1 = lv_herkl.
        IF sy-subrc IS INITIAL.
          ls_items-herkl = ls_t005t-landx.
        ENDIF.
      ENDIF.

      DATA lv_kbetr TYPE p DECIMALS 3.
      LOOP AT ms_billing_data-konv INTO ls_konv WHERE kposn = ls_vbrp-posnr
                                                  AND koaid = 'A'
                                                  AND kinak = space.
        .
*        CHECK ms_billing_data-conditions IS NOT INITIAL.
*        READ TABLE ms_billing_data-conditions
*          WITH TABLE KEY kschl = ls_konv-kschl
*            COMPONENTS cndty = 'D'
*          TRANSPORTING NO FIELDS.
        READ TABLE ms_billing_data-conditions
          WITH TABLE KEY by_kschl
          COMPONENTS kschl = ls_konv-kschl
                     cndty = 'D'
          TRANSPORTING NO FIELDS.
        CHECK sy-subrc EQ 0.
*          IF sy-subrc IS NOT INITIAL.
*            READ TABLE ms_billing_data-conditions
*              WITH TABLE KEY by_cndty
*              COMPONENTS cndty = 'D'
*              TRANSPORTING NO FIELDS.
*            CHECK sy-subrc IS NOT INITIAL.
*          ENDIF.
*        ENDIF.
        ls_item_allowance-summr = lv_summarize_text.

        CLEAR ls_item_allowance.
        ls_item_allowance-posnr = ls_vbrp-posnr.
        IF ls_konv-kwert LT 0.
          ls_konv-kwert = abs( ls_konv-kwert ).
          ADD ls_konv-kwert TO ls_items-distr.
          ls_item_allowance-distr = ls_konv-kwert.
        ELSEIF ls_konv-kwert GT 0.
          ADD ls_konv-kwert TO ls_items-surtr.
          ls_item_allowance-surtr = ls_konv-kwert.
        ENDIF.
*-- STASKAN BEGIN
        IF ls_konv-krech EQ 'A'. "gkadioglu
          IF ls_konv-kbetr LT 0 .
            lv_kbetr =  abs( ls_konv-kbetr )   / 1000 .
            ADD lv_kbetr TO ls_items-disrt.
            ls_item_allowance-disrt = lv_kbetr.
          ELSEIF ls_konv-kbetr GT 0.
            lv_kbetr =  ls_konv-kbetr   / 1000 .
            ADD lv_kbetr TO ls_items-surrt.
            ls_item_allowance-surrt = lv_kbetr.
          ENDIF.
        ENDIF.

        IF ms_document-itmcl = abap_false AND mv_sepallowance IS NOT INITIAL.
          APPEND ls_item_allowance TO mt_items_allowance.
        ENDIF.
**--- STASKAN END
      ENDLOOP.

*      READ TABLE ms_billing_data-conditions
*        INTO ls_conditions
*        WITH TABLE KEY by_cndty
*        COMPONENTS cndty = 'V'.
      LOOP AT ms_billing_data-conditions INTO ls_conditions USING KEY by_cndty WHERE cndty = 'V'.
        READ TABLE ms_billing_data-konv
          INTO ls_konv
          WITH TABLE KEY by_kschl
          COMPONENTS kposn = ls_vbrp-posnr
                     kschl = ls_conditions-kschl
                     kinak = space.
        IF sy-subrc IS INITIAL.
          ls_items-mwskz = ls_konv-mwsk1.
          ls_items-mwsbp = ls_konv-kwert.
        ENDIF.
      ENDLOOP.
      IF ls_items-mwskz IS INITIAL.
        READ TABLE ms_billing_data-konv
          INTO ls_konv
          WITH TABLE KEY by_koaid
          COMPONENTS kposn = ls_vbrp-posnr
                     koaid = 'D'
                     kinak = space.
        IF sy-subrc IS INITIAL.
          ls_items-mwskz = ls_konv-mwsk1.
          ls_items-mwsbp = ls_konv-kwert.
        ENDIF.
      ENDIF.

      LOOP AT ms_billing_data-conditions INTO ls_conditions USING KEY by_cndty WHERE cndty = 'O'.
        READ TABLE ms_billing_data-konv
          INTO ls_konv
          WITH TABLE KEY by_kschl
          COMPONENTS kposn = ls_vbrp-posnr
                     kschl = ls_conditions-kschl
                     kinak = space.
        CHECK sy-subrc IS INITIAL.
        ls_items-othtx = ls_konv-kwert.
        ls_items-othtt = ls_conditions-taxty.
        lv_taxrt = ls_konv-kbetr.
        ls_items-othtr = lv_taxrt.
        EXIT.
      ENDLOOP.
      "Diğer vergi alanı begin
      LOOP AT ms_billing_data-conditions INTO ls_conditions USING KEY by_cndty WHERE cndty = 'Z'.
        READ TABLE ms_billing_data-konv
          INTO ls_konv
          WITH TABLE KEY by_kschl
          COMPONENTS kposn = ls_vbrp-posnr
                     kschl = ls_conditions-kschl
                     kinak = space.
        CHECK sy-subrc IS INITIAL.
        ls_items-dgrtx = ls_konv-kwert.
        ls_items-dgrtt = ls_conditions-taxty.
        lv_taxrt = ls_konv-kbetr.
        ls_items-dgrtr = lv_taxrt.
        EXIT.
      ENDLOOP.
      "Diğer vergi alanı end

      IF ms_document-prfid = 'IHRACAT'.
        ls_export_data = build_invoice_data_vbrk_export( is_vbrp = ls_vbrp ).
        MOVE-CORRESPONDING ls_export_data TO ls_items.
      ENDIF.

      IF ms_document-invty = 'IHRACKAYIT' AND ms_document-taxex = '702'.
        READ TABLE ms_billing_data-maw1
             INTO ls_maw1
             WITH TABLE KEY matnr = ls_vbrp-matnr.
        IF sy-subrc IS INITIAL.
          ls_items-hscod = ls_maw1-wstaw.
        ELSE.
          READ TABLE ms_billing_data-marc
            INTO ls_marc
            WITH TABLE KEY matnr = ls_vbrp-matnr
                           werks = ls_vbrp-werks.
          IF sy-subrc IS INITIAL.
            ls_items-hscod = ls_marc-stawn.
          ENDIF.
        ENDIF.
      ENDIF.

      CONDENSE: ls_items-netpr, ls_items-peinh, ls_items-disrt, ls_items-surrt, ls_items-othtr.
      ls_items-waers = ms_billing_data-vbrk-waerk.

      collect_items_vbrk_change_item(
        EXPORTING
          is_vbrp = ls_vbrp
        CHANGING
          cs_item = ls_items ).

      IF ms_document-itmcl = abap_false.
        ls_items-posnr = ls_vbrp-posnr.
        APPEND ls_items TO mt_invoice_items.
      ELSE.
        CLEAR ls_items-posnr."AS
        COLLECT ls_items INTO mt_invoice_items.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD collect_items_vbrk_change_item.
    CHECK is_vbrp IS NOT INITIAL.
  ENDMETHOD.


  method EXIT_AFTER_SEND_INVOICE.
  endmethod.


  method EXIT_BEFORE_SEND_CHANGE_UBL.
  endmethod.


  METHOD factory.
    DATA: lx_exception           TYPE REF TO /itetr/cx_regulative_exception,
          lx_create_object_error TYPE REF TO cx_sy_create_object_error,
          lv_reference_class     TYPE /itetr/com_refcl-refcl,
          ls_document            TYPE /itetr/inv_oginv.
    SELECT SINGLE *
      FROM /itetr/inv_oginv
      INTO ls_document
      WHERE docui = iv_document_uuid.
    IF sy-subrc IS NOT INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '005' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    SELECT SINGLE refcl
      INTO lv_reference_class
      FROM /itetr/com_refcl
      WHERE bukrs = ls_document-bukrs
        AND prncl = '/ITETR/CL_OUTGOING_INVOICE'.  "AS 01.01.2022

    IF lv_reference_class IS INITIAL.
      lv_reference_class = '/ITETR/CL_OUTGOING_INVOICE'.
    ENDIF.

    TRY .
        CREATE OBJECT ro_object TYPE (lv_reference_class).
        ro_object->set_initial_data( is_document = ls_document
                                     iv_preview = iv_preview ).
      CATCH cx_sy_create_object_error INTO lx_create_object_error.
        lx_exception = /itetr/cx_regulative_exception=>create_by_exception( lx_create_object_error ).
        RAISE EXCEPTION lx_exception.
    ENDTRY.
  ENDMETHOD.


  METHOD fill_common_invoice_data.
    CONSTANTS lv_ayrac TYPE string VALUE '!#'.
    DATA: lt_text_lines        TYPE TABLE OF tline,
          lx_etr_exception     TYPE REF TO /itetr/cx_regulative_exception,
          ls_text_lines        TYPE tline,
          lo_xslt_obj          TYPE REF TO cl_o2_api_xsltdesc,
          lv_xslt_source       TYPE string,
          lv_xslt_xsource      TYPE xstring,
          lv_text_name         TYPE tdobname,
          lv_payable_amount    TYPE wrbtr,
          ls_amount_in_words   TYPE spell,
          lv_currency          TYPE waers,
          lv_currency_text     TYPE char5,
          lv_cent_text         TYPE char5,
          lv_xslt_raw          TYPE string,
          lcl_descr_ref        TYPE REF TO cl_abap_typedescr,
          lv_intid             TYPE /itetr/com_e_intid,
          ls_eipi              TYPE /itetr/inv_eipi,
          ls_identification    TYPE /itetr/com_party_identificati1,
          lv_taxid             TYPE stcd2,
          lv_tax_office        TYPE /itetr/com_e_taxof,
          lv_adrnr             TYPE adrnr,
          lt_stxh              TYPE TABLE OF stxh,
          ls_stxh              TYPE stxh,
          lv_langu             TYPE sy-langu,
          lv_count             TYPE i,
          ls_iban              TYPE /itetr/inv_iban,
          ls_banka             TYPE mst_banka_info,
          ls_inv_eicp          TYPE /itetr/inv_eicp,
          ls_contract_doc      TYPE mty_contract_document,
          lt_header_ytb        TYPE TABLE OF /itetr/inv_ytb_h,
          ls_header_ytb        TYPE /itetr/inv_ytb_h,
          ls_contract_document TYPE /itetr/com_contract_document_r,
          ls_xslt              TYPE /itetr/com_xslt,
          lv_qnb_api           TYPE xfeld. "gkadioglu

    FIELD-SYMBOLS: <ls_party_identification> TYPE /itetr/com_party_identificati1,
                   <ls_signature>            TYPE /itetr/com_signature,
                   <ls_invoice_note>         TYPE /itetr/com_note,
                   <ls_document_reference>   TYPE /itetr/com_additional_document,
                   <ls_custom_parameter>     TYPE /itetr/com_s_custom_param,
                   <ls_payment_means>        TYPE /itetr/com_payment_means.

    SELECT SINGLE intid
      FROM /itetr/inv_einp
      INTO lv_intid
      WHERE bukrs EQ ms_document-bukrs.

    ms_invoice_ubl-part1-ublversion_id-base-base-content = '2.1'.

    IF lv_intid EQ 'SOV'.
      ms_invoice_ubl-part1-customization_id-base-base-content = 'TR1.2'.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-additional_document_reference ASSIGNING <ls_document_reference>.
      <ls_document_reference>-id-base-base-content = 'ELEKTRONIK'.
      <ls_document_reference>-document_type_code-base-base-content = 'EREPSENDT'.
      CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
        INTO <ls_document_reference>-issue_date-base-content
        SEPARATED BY '-'.
    ELSE.
      ms_invoice_ubl-part1-customization_id-base-base-content = 'TR1.2.1'.
    ENDIF.

    IF lv_intid EQ 'HTK' AND ms_document-prfid EQ 'EARSIV'.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-additional_document_reference ASSIGNING <ls_document_reference>.
      <ls_document_reference>-id-base-base-content = 'ELEKTRONIK'.
      <ls_document_reference>-document_type_code-base-base-content = 'GONDERIM_SEKLI'.
      <ls_document_reference>-document_type-base-base-content = 'ELEKTRONIK'.
      CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
        INTO <ls_document_reference>-issue_date-base-content
        SEPARATED BY '-'.
    ENDIF.

    lcl_descr_ref  = cl_abap_typedescr=>describe_by_data( ms_invoice_ubl-part1-issue_time-base-content ).

    CASE lcl_descr_ref->type_kind.. "staskan
      WHEN  'T'. " Times 6Char
        ms_invoice_ubl-part1-issue_time-base-content = sy-uzeit+0(2) && sy-uzeit+2(2) &&  sy-uzeit+4(2).
      WHEN OTHERS.
        ms_invoice_ubl-part1-issue_time-base-content = sy-uzeit+0(2) && ':' &&
                                                       sy-uzeit+2(2) && ':' &&
                                                       sy-uzeit+4(2).
    ENDCASE.

    CALL FUNCTION 'CONVERSION_EXIT_YYPRF_OUTPUT'
      EXPORTING
        input  = ms_document-prfid
      IMPORTING
        output = ms_invoice_ubl-part1-profile_id-base-base-content.
    CALL FUNCTION 'CONVERSION_EXIT_YYINT_OUTPUT'
      EXPORTING
        input  = ms_document-invty
      IMPORTING
        output = ms_invoice_ubl-part1-invoice_type_code-base-base-content.
    ms_invoice_ubl-part1-uuid-base-base-content = ms_document-invui.

    ms_invoice_ubl-part1-accounting_supplier_party-party = ubl_fill_company_data( iv_bukrs = ms_document-bukrs ).
    READ TABLE ms_invoice_ubl-part1-accounting_supplier_party-party-party_identification
      WITH KEY id-base-base-scheme_id = 'VKN'
      TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-accounting_supplier_party-party-party_identification ASSIGNING <ls_party_identification>.
      <ls_party_identification>-id-base-base-scheme_id = 'VKN'.
      <ls_party_identification>-id-base-base-content = mv_company_taxid.
    ENDIF.

    IF ms_document-agent IS NOT INITIAL.
      ms_invoice_ubl-part1-accounting_supplier_party-party-agent_party = ubl_fill_agent_data( iv_bukrs = ms_document-bukrs
                                                                                              iv_agent = ms_document-agent ).
    ENDIF.

    "qnb preview
    IF  ms_document-xsltt IS NOT INITIAL AND
        mv_preview         IS NOT INITIAL.
      SELECT SINGLE * FROM /itetr/com_xslt INTO ls_xslt WHERE xsltt = ms_document-xsltt.
      IF ls_xslt-qnb_api EQ 'X' AND lv_intid EQ 'EFN'.
        lv_qnb_api = 'X'.
      ENDIF.
    ENDIF.

    IF mv_add_signature IS NOT INITIAL OR lv_qnb_api = 'X'.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-signature ASSIGNING <ls_signature>.
      <ls_signature>-id-base-base-scheme_id = 'VKN_TCKN'.
      <ls_signature>-id-base-base-content = mv_company_taxid.
      <ls_signature>-signatory_party = ms_invoice_ubl-part1-accounting_supplier_party-party.
    ENDIF.

*****    IF mv_preview IS INITIAL AND mv_generate_invoice_id IS NOT INITIAL AND ms_document-invno IS INITIAL.
*****      IF ms_document-serpr IS INITIAL.
*****        lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( '029' ).
*****        RAISE EXCEPTION lx_etr_exception.
*****      ENDIF.
*****      generate_invoice_id( ).
*****      ms_invoice_ubl-part1-id-base-base-content = ms_document-invno.
*****    ELSEIF mv_generate_invoice_id IS NOT INITIAL AND ms_document-invno IS NOT INITIAL.
*****      ms_invoice_ubl-part1-id-base-base-content = ms_document-invno.
*****    ENDIF.
    " AS 06.01.2022
    IF ms_document-prfid = 'IHRACAT'.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-payment_means ASSIGNING <ls_payment_means>.
      <ls_payment_means>-payment_means_code-base-base-content = 'ZZZ'.
      <ls_payment_means>-payment_due_date-base-content = ms_invoice_ubl-part1-payment_terms-payment_due_date-base-content.

      SELECT SINGLE value
        INTO <ls_payment_means>-payee_financial_account-id-base-base-content
        FROM /itetr/com_cmppi
        WHERE bukrs = ms_document-bukrs
          AND prtid = 'IBAN'.
      SELECT SINGLE value
        INTO <ls_payment_means>-payee_financial_account-currency_code-base-base-content
        FROM /itetr/com_cmppi
        WHERE bukrs = ms_document-bukrs
          AND prtid = 'PARA_BIRIM'.
    ENDIF.

    IF ms_document-prfid EQ 'KAMU'.
      READ TABLE ms_invoice_ubl-part1-accounting_customer_party-party-party_identification INTO ls_identification WITH KEY id-base-base-scheme_id = 'VKN'.
      IF sy-subrc EQ 0.
        lv_taxid = ls_identification-id-base-base-content.
      ELSE.
        READ TABLE ms_invoice_ubl-part1-accounting_customer_party-party-party_identification INTO ls_identification WITH KEY id-base-base-scheme_id = 'TCKN'.
        IF sy-subrc EQ 0.
          lv_taxid = ls_identification-id-base-base-content.
        ENDIF.
      ENDIF.
      SELECT SINGLE *
        FROM /itetr/inv_eipi
        INTO ls_eipi
       WHERE taxid = lv_taxid.
      IF ls_eipi-kunnr IS INITIAL.
        ms_invoice_ubl-part1-buyer_customer_party = ms_invoice_ubl-part1-accounting_customer_party.
      ELSE.
        mo_invoice_operations->get_customer_taxid(
          EXPORTING
            iv_kunnr      = ls_eipi-kunnr
          IMPORTING
            ev_taxid      = lv_taxid
            ev_tax_office = lv_tax_office
            ev_adrnr      = lv_adrnr ).

        ms_invoice_ubl-part1-buyer_customer_party-party = ubl_fill_partner_data( iv_address_number = lv_adrnr
                                                                                 iv_tax_office     = lv_tax_office
                                                                                 iv_tax_id         = lv_taxid
                                                                                 iv_profile_id     = ms_document-prfid ).
      ENDIF.

*      IF ls_eipi-iban IS INITIAL.
*        lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( '098' ).
*        RAISE EXCEPTION lx_etr_exception.
*      ENDIF.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-payment_means ASSIGNING <ls_payment_means>.
      <ls_payment_means>-payment_means_code-base-base-content = ls_eipi-payment.
      <ls_payment_means>-payee_financial_account-id-base-base-content = ls_eipi-iban.
      <ls_payment_means>-payee_financial_account-currency_code-base-base-content = ms_invoice_ubl-part1-document_currency_code-base-base-content.
    ENDIF.

    " AS 06.01.2022
    lv_text_name = ms_document-bukrs.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'INVG'
        language                = sy-langu
        name                    = lv_text_name
        object                  = '/ITETR/INV'
      TABLES
        lines                   = lt_text_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc IS INITIAL AND lt_text_lines IS NOT INITIAL.
      LOOP AT lt_text_lines INTO ls_text_lines.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_text_lines-tdline.
      ENDLOOP.
    ENDIF.



    REFRESH lt_text_lines.
    lv_text_name = ms_document-docui.

    SELECT tdobject tdname tdid tdspras
      FROM stxh
      INTO CORRESPONDING FIELDS OF TABLE lt_stxh
     WHERE tdobject EQ '/ITETR/INV'
       AND tdid     EQ 'INVI'
       AND tdname   EQ  lv_text_name.

    DESCRIBE TABLE lt_stxh LINES lv_count.
    CLEAR : lv_langu.
    IF lv_count > 1.
      lv_langu = sy-langu.
    ELSE.
      CLEAR ls_stxh.
      READ TABLE lt_stxh INTO ls_stxh INDEX 1.
      IF sy-subrc EQ 0.
        lv_langu = ls_stxh-tdspras.
      ELSE.
        lv_langu = sy-langu.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'INVI'
        language                = lv_langu
        name                    = lv_text_name
        object                  = '/ITETR/INV'
      TABLES
        lines                   = lt_text_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc IS INITIAL AND lt_text_lines IS NOT INITIAL.
      LOOP AT lt_text_lines INTO ls_text_lines.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = ls_text_lines-tdline.
      ENDLOOP.
    ENDIF.

    IF ms_document-xsltt IS NOT INITIAL.

      CALL FUNCTION '/ITETR/COM_F_GET_XSLT'
        EXPORTING
          iv_design_name = ms_document-xsltt
        IMPORTING
          e_xslt_data    = lv_xslt_source
          e_xslt_x_data  = lv_xslt_xsource.

      IF lv_xslt_source IS INITIAL.
        cl_o2_api_xsltdesc=>load(
          EXPORTING
            p_xslt_desc                  = ms_document-xsltt
*          p_gen_flag                   = abap_true
          IMPORTING
            p_obj = lo_xslt_obj
          EXCEPTIONS
            error_occured                = 1
            not_existing                 = 2
            permission_failure           = 3
            version_not_found            = 4
            OTHERS                       = 5 ).
        IF sy-subrc IS INITIAL AND lo_xslt_obj IS NOT INITIAL.
          lv_xslt_source = lo_xslt_obj->get_source_string( ).
**        IF lv_xslt_source IS NOT INITIAL.
**          APPEND INITIAL LINE TO ms_invoice_ubl-part1-additional_document_reference ASSIGNING <ls_document_reference>.
**          <ls_document_reference>-id-base-base-content = ms_document-docui.
**          CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
**            INTO <ls_document_reference>-issue_date-base-content
**            SEPARATED BY '-'.
**          <ls_document_reference>-document_type-base-base-content = 'XSLT'.
**          <ls_document_reference>-attachment-embedded_document_binary_objec-base-mime_code = 'application/xml'.
**          <ls_document_reference>-attachment-embedded_document_binary_objec-base-encoding_code = 'Base64'.
**          <ls_document_reference>-attachment-embedded_document_binary_objec-base-character_set_code = 'UTF-8'.
**          IF lv_intid EQ 'SOV'.
**            CONCATENATE ms_invoice_ubl-part1-uuid-base-base-content '.xslt' INTO <ls_document_reference>-attachment-embedded_document_binary_objec-base-filename.
**          ELSE.
**            CONCATENATE ms_document-xsltt '.xslt' INTO <ls_document_reference>-attachment-embedded_document_binary_objec-base-filename.
**          ENDIF.
**          <ls_document_reference>-attachment-embedded_document_binary_objec-base-content = /itetr/cl_regulative_common=>encode_base64( lv_xslt_source ).
**        ENDIF.
          DATA: lv_64.
          lv_64 = 'X'.
        ENDIF.
      ENDIF.

      IF lv_xslt_source IS NOT INITIAL.

        APPEND INITIAL LINE TO ms_invoice_ubl-part1-additional_document_reference ASSIGNING <ls_document_reference>.
        <ls_document_reference>-id-base-base-content = ms_document-docui.
        CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
          INTO <ls_document_reference>-issue_date-base-content
          SEPARATED BY '-'.

        <ls_document_reference>-document_type-base-base-content = 'XSLT'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-mime_code = 'application/xml'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-encoding_code = 'Base64'.
        <ls_document_reference>-attachment-embedded_document_binary_objec-base-character_set_code = 'UTF-8'.

        IF lv_intid EQ 'SOV'.
          CONCATENATE ms_invoice_ubl-part1-uuid-base-base-content '.xslt' INTO <ls_document_reference>-attachment-embedded_document_binary_objec-base-filename.
        ELSE.
          CONCATENATE ms_document-xsltt '.xslt' INTO <ls_document_reference>-attachment-embedded_document_binary_objec-base-filename.
        ENDIF.

        IF lv_64 IS NOT INITIAL.
          <ls_document_reference>-attachment-embedded_document_binary_objec-base-content = /itetr/cl_regulative_common=>encode_base64( EXPORTING iv_input_string = lv_xslt_source ).
        ELSE.
          <ls_document_reference>-attachment-embedded_document_binary_objec-base-content = lv_xslt_source.
        ENDIF.
      ENDIF.





    ENDIF.

    lv_payable_amount = ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content.
    lv_currency = ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id.
    CASE lv_currency.
      WHEN 'TRY'.
        lv_currency_text = 'TL'.
        lv_cent_text = 'KURUŞ'.
      WHEN OTHERS.
        lv_currency_text = lv_currency.
        lv_cent_text = 'CENT'.
    ENDCASE.
    CALL FUNCTION 'SPELL_AMOUNT'
      EXPORTING
        amount    = lv_payable_amount
        currency  = lv_currency
        language  = sy-langu
      IMPORTING
        in_words  = ls_amount_in_words
      EXCEPTIONS
        not_found = 1
        too_large = 2
        OTHERS    = 3.
    IF sy-subrc IS INITIAL.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
      CONCATENATE 'YAZI İLE' ` ` ls_amount_in_words-word ` ` lv_currency_text INTO <ls_invoice_note>-base-base-content.
      IF ls_amount_in_words-decimal IS NOT INITIAL.
        CONCATENATE <ls_invoice_note>-base-base-content ` ` ls_amount_in_words-decword ` ` lv_cent_text INTO <ls_invoice_note>-base-base-content.
      ENDIF.
    ENDIF.

    READ TABLE mt_inv_eicp INTO ls_inv_eicp WITH KEY cuspa = 'WRITE_TL'.
    IF ls_inv_eicp-value EQ abap_false.
      DATA lv_netwr_try TYPE /itetr/com_e_wrbtr .
      IF ms_document-prfid EQ 'EARSIV' " TRY dışı kesilen faturaların TRY Dönüşümü
        OR ms_document-prfid EQ  'TEMEL'
        OR  ms_document-prfid EQ 'TICARI'.
        IF lv_currency NE 'TRY'.
          lv_netwr_try =   ms_document-kursf * ms_document-wrbtr .
          CALL FUNCTION 'SPELL_AMOUNT'
            EXPORTING
              amount    = lv_netwr_try
              currency  = 'TRY'
              language  = sy-langu
            IMPORTING
              in_words  = ls_amount_in_words
            EXCEPTIONS
              not_found = 1
              too_large = 2
              OTHERS    = 3.
          IF sy-subrc IS INITIAL.
            APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
            CONCATENATE 'YAZI İLE' ` ` ls_amount_in_words-word ` ` 'TL' INTO <ls_invoice_note>-base-base-content.
            IF ls_amount_in_words-decimal IS NOT INITIAL.
              CONCATENATE <ls_invoice_note>-base-base-content ` ` ls_amount_in_words-decword ` ` 'KURUŞ' INTO <ls_invoice_note>-base-base-content.
            ENDIF.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

    ms_invoice_ubl-part1-line_count_numeric-base-base-content = lines( ms_invoice_ubl-part1-invoice_line ).

    IF ms_document-prfid = 'EARSIV'.
      IF ms_document-intsl IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = 'Bu satış internet üzerinden yapılmıştır.'. "TEXT-001.
      ENDIF.
      IF ms_document-eatyp IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        CONCATENATE 'Gönderim Şekli:' ms_document-eatyp INTO <ls_invoice_note>-base-base-content.
*        CONCATENATE TEXT-002 ms_document-eatyp INTO <ls_invoice_note>-base-base-content.
      ELSEIF ms_invoice_ubl-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = 'Gönderim Şekli:ELEKTRONIK'."TEXT-003.
      ELSE.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_invoice_note>-base-base-content = 'Gönderim Şekli:KAGIT'."TEXT-004.
      ENDIF.

      IF ms_invoice_ubl-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content IS NOT INITIAL.
        APPEND INITIAL LINE TO mt_custom_parameters ASSIGNING <ls_custom_parameter>.
        <ls_custom_parameter>-cuspa = 'MAIL'.
        <ls_custom_parameter>-value = ms_invoice_ubl-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content.
      ENDIF.

      IF ms_invoice_ubl-part1-accounting_customer_party-party-contact-telephone-base-base-content IS NOT INITIAL.
        APPEND INITIAL LINE TO mt_custom_parameters ASSIGNING <ls_custom_parameter>.
        <ls_custom_parameter>-cuspa = 'TEL'.
        <ls_custom_parameter>-value = ms_invoice_ubl-part1-accounting_customer_party-party-contact-telephone-base-base-content.
      ENDIF.
    ENDIF.


    IF ms_document-prfid = 'EARSIV' AND lv_intid EQ 'LOG'.
      APPEND INITIAL LINE TO ms_invoice_ubl-part1-additional_document_reference ASSIGNING <ls_document_reference>.
      <ls_document_reference>-id-base-base-content = 'gonderimSekli'.
      CONCATENATE sy-datum(4) sy-datum+4(2) sy-datum+6(2)
          INTO <ls_document_reference>-issue_date-base-content SEPARATED BY '-'.
      IF ms_document-eatyp IS NOT INITIAL.
        CONCATENATE TEXT-002 ms_document-eatyp INTO <ls_document_reference>-document_type-base-base-content.
      ELSEIF ms_invoice_ubl-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content IS NOT INITIAL.
        <ls_document_reference>-document_type-base-base-content = 'ELEKTRONIK'.
      ELSE.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
        <ls_document_reference>-document_type-base-base-content = 'KAGIT'.
      ENDIF.
    ENDIF.



    SELECT * FROM /itetr/inv_iban INTO TABLE mt_iban WHERE bukrs = ms_document-bukrs.
    IF ms_document-prfid EQ 'KAMU'.
      DELETE mt_iban[] WHERE kamu NE abap_true.
    ENDIF.
    IF mt_iban[] IS NOT INITIAL.
      SELECT t~hbkid
             t~hktid
             b~banka
             b~brnch
             t~waers
             it~iban
             b~swift
      INTO TABLE mt_banka FROM bnka AS b INNER JOIN t012k AS t  ON b~bankl  = t~bnkn2
                                         INNER JOIN tiban AS it ON it~bankl = t~bnkn2 AND
                                                                   it~bankn = t~bankn
      FOR ALL ENTRIES IN mt_iban WHERE t~hbkid = mt_iban-hbkid AND
                                       t~hktid = mt_iban-hktid AND
                                       t~bukrs = ms_document-bukrs.
      lv_currency = ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-currency_id.
      LOOP AT mt_iban INTO ls_iban.
        READ TABLE mt_banka INTO ls_banka WITH KEY hbkid =  ls_iban-hbkid
                                                   hktid =  ls_iban-hktid.
        IF sy-subrc EQ 0.
          IF ls_iban-banka NE abap_true.
            CLEAR ls_banka-banka.
          ENDIF.
          IF ls_iban-branch NE abap_true.
            CLEAR ls_banka-brnch.
          ENDIF.
          "Swift Türkiye dışında kalanlar için olmalı
          IF ls_iban-swift NE abap_true OR mv_country EQ 'TR'.
            CLEAR ls_banka-swift.
          ENDIF.
          IF lv_currency IS NOT INITIAL AND ls_iban-currency EQ abap_true.
            IF lv_currency NE ls_banka-waers.
              CLEAR ls_banka.
            ENDIF.
          ENDIF.

          IF ls_banka IS NOT INITIAL.
            APPEND INITIAL LINE TO ms_invoice_ubl-part1-note ASSIGNING <ls_invoice_note>.
            CONCATENATE ls_iban-tag ls_banka-banka lv_ayrac ls_banka-brnch lv_ayrac ls_banka-waers lv_ayrac ls_banka-iban lv_ayrac
                        ls_banka-swift INTO  <ls_invoice_note>-base-base-content SEPARATED BY space.
          ENDIF.
          CLEAR: ls_banka.
        ENDIF.
      ENDLOOP.
    ENDIF.

    DATA: ls_return_ref   LIKE LINE OF ms_invrec_data-return_ref..
    DATA: ls_billing_ref  TYPE /itetr/com_billing_reference.

    IF ms_document-invty = 'IADE'    OR ms_document-invty = 'TEVIADE' OR
       ms_document-invty = 'YTBIADE' OR ms_document-invty = 'YTBTEVIADE'.

      DELETE ADJACENT DUPLICATES FROM ms_invrec_data-return_ref.
      LOOP AT ms_invrec_data-return_ref INTO ls_return_ref.
        ls_billing_ref-invoice_document_reference-id-base-base-content                 = ls_return_ref-return_ref_no.
        ls_billing_ref-invoice_document_reference-issue_date-base-content              = ls_return_ref-return_ref_date.
        ls_billing_ref-invoice_document_reference-document_type_code-base-base-content = 'IADE'.
        ls_billing_ref-invoice_document_reference-document_type-base-base-content      = 'İade Edilen Fatura'.
        APPEND ls_billing_ref TO ms_invoice_ubl-part1-billing_reference.
      ENDLOOP.

      DELETE ADJACENT DUPLICATES FROM ms_accdoc_data-return_ref.
      LOOP AT ms_accdoc_data-return_ref INTO ls_return_ref.
        ls_billing_ref-invoice_document_reference-id-base-base-content                 = ls_return_ref-return_ref_no.
        ls_billing_ref-invoice_document_reference-issue_date-base-content              = ls_return_ref-return_ref_date.
        ls_billing_ref-invoice_document_reference-document_type_code-base-base-content = 'IADE'.
        ls_billing_ref-invoice_document_reference-document_type-base-base-content      = 'İade Edilen Fatura'.
        APPEND ls_billing_ref TO ms_invoice_ubl-part1-billing_reference.
      ENDLOOP.

      DELETE ADJACENT DUPLICATES FROM ms_billing_data-return_ref.
      LOOP AT ms_billing_data-return_ref INTO ls_return_ref .
        ls_billing_ref-invoice_document_reference-id-base-base-content                 = ls_return_ref-return_ref_no.
        ls_billing_ref-invoice_document_reference-issue_date-base-content              = ls_return_ref-return_ref_date.
        ls_billing_ref-invoice_document_reference-document_type_code-base-base-content = 'IADE'.
        ls_billing_ref-invoice_document_reference-document_type-base-base-content      = 'İade Edilen Fatura'.
        APPEND ls_billing_ref TO ms_invoice_ubl-part1-billing_reference.
      ENDLOOP.

    ENDIF.

    APPEND INITIAL LINE TO ms_invoice_ubl-part1-additional_document_reference ASSIGNING <ls_document_reference>.
    <ls_document_reference>-id-base-base-content = ms_document-belnr.
    CONCATENATE ms_document-bldat(4) ms_document-bldat+4(2) ms_document-bldat+6(2)
      INTO <ls_document_reference>-issue_date-base-content
      SEPARATED BY '-'.
    <ls_document_reference>-document_type-base-base-content = 'BELNR'.


    IF  ms_document-prfid = 'YATIRIMTES' OR
      ( ms_document-prfid = 'EARSIV' AND  ms_document-invty+0(3) EQ 'YTB' ).

      SELECT *
         FROM /itetr/inv_ytb_h
         INTO TABLE lt_header_ytb
         WHERE docui = ms_document-docui.

      IF lt_header_ytb[] IS NOT INITIAL.
        CLEAR:mt_contract_document[].
        LOOP AT lt_header_ytb INTO ls_header_ytb.
          ls_contract_doc-schemeid = 'YTBNO'.
          ls_contract_doc-id = ls_header_ytb-ytb_no.
          CONCATENATE ls_header_ytb-ytb_date(4) ls_header_ytb-ytb_date+4(2) ls_header_ytb-ytb_date+6(2)
                 INTO ls_contract_doc-issue_date  SEPARATED BY '-'.
          COLLECT ls_contract_doc INTO mt_contract_document.
          CLEAR:ls_contract_doc.
        ENDLOOP.
      ENDIF.


      SORT mt_contract_document BY id issue_date.
      DELETE ADJACENT DUPLICATES FROM mt_contract_document COMPARING id issue_date.
      LOOP AT mt_contract_document INTO ls_contract_doc.
        ls_contract_document-id-base-base-scheme_id = ls_contract_doc-schemeid.
        ls_contract_document-id-base-base-content = ls_contract_doc-id.
        ls_contract_document-issue_date-base-content    = ls_contract_doc-issue_date.
        APPEND ls_contract_document TO ms_invoice_ubl-part1-contract_document_reference.
      ENDLOOP.
    ENDIF.



  ENDMETHOD.


  METHOD fill_common_tax_totals.
    CONSTANTS:lc_gv_stpj TYPE string VALUE '0003',
              lc_kv_stpj TYPE string VALUE '0011',
              lc_mm_bors TYPE string VALUE '8001',      "Müstahsil özel kesinti
              lc_mm_mera TYPE string VALUE '9040',      "Müstahsil özel kesinti
              lc_mm_sgkp TYPE string VALUE 'SGK_PRIM'.  "Müstahsil özel kesinti
    TYPES BEGIN OF ty_tax_total.
    TYPES tax_code   TYPE string.
    TYPES tax_name   TYPE string.
    TYPES tax_rate   TYPE string.
    TYPES exp_code   TYPE string.
    TYPES exp_name   TYPE string.
    TYPES tax_total  TYPE wrbtr.
    TYPES tax_amount TYPE wrbtr.
    TYPES tax_base   TYPE wrbtr.
    TYPES calc_rate TYPE string. " gkadioglu
    TYPES witholding TYPE xfeld.
    TYPES END OF ty_tax_total .
    DATA: lt_tax_total      TYPE TABLE OF ty_tax_total,
          ls_tax_total      TYPE ty_tax_total,
          ls_invoice_line   TYPE /itetr/com_invoice_line,
          ls_tax_subtotal   TYPE /itetr/com_tax_subtotal,
          ls_line_tax_total TYPE /itetr/com_withholding_tax_tot,
          lv_count_0015     TYPE i. "gkadioglu
    FIELD-SYMBOLS: <ls_tax_total>    TYPE /itetr/com_withholding_tax_tot,
                   <ls_tax_subtotal> TYPE /itetr/com_tax_subtotal.



    LOOP AT ms_invoice_ubl-part1-invoice_line INTO ls_invoice_line.
      LOOP AT ls_invoice_line-tax_total-tax_subtotal INTO ls_tax_subtotal.
        ls_tax_total-tax_code  = ls_tax_subtotal-tax_category-tax_scheme-tax_type_code-base-base-content.
        ls_tax_total-tax_name  = ls_tax_subtotal-tax_category-tax_scheme-name-base-base-content.
        ls_tax_total-tax_rate  = ls_tax_subtotal-percent-base-base-content.
        ls_tax_total-exp_code  = ls_tax_subtotal-tax_category-tax_exemption_reason_code-base-base-content.
        ls_tax_total-exp_name  = ls_tax_subtotal-tax_category-tax_exemption_reason-base-base-content.
        ls_tax_total-tax_amount = ls_tax_subtotal-tax_amount-base-content.
        READ TABLE ls_invoice_line-withholding_tax_total TRANSPORTING NO FIELDS INDEX 1.
        IF sy-subrc EQ 0.
          ls_tax_total-tax_total = ls_invoice_line-tax_total-tax_amount-base-content.
        ELSE.
          ls_tax_total-tax_total = ls_tax_subtotal-tax_amount-base-content.
        ENDIF.
        ls_tax_total-tax_base  = ls_tax_subtotal-taxable_amount-base-content.
        IF ls_tax_subtotal-calculation_sequence_numeric-base-base-content EQ '-1'. "gkadioglu
          "yatırım tesvik istisna tax amount 0 olur
          ls_tax_total-calc_rate = ls_tax_subtotal-calculation_sequence_numeric-base-base-content."gkadioglu
          CLEAR:ls_tax_total-tax_total.
        ENDIF.
        COLLECT ls_tax_total INTO lt_tax_total.
        CLEAR ls_tax_total.
      ENDLOOP.



      LOOP AT ls_invoice_line-withholding_tax_total INTO ls_line_tax_total.
        LOOP AT ls_line_tax_total-tax_subtotal INTO ls_tax_subtotal.
          ls_tax_total-tax_code  = ls_tax_subtotal-tax_category-tax_scheme-tax_type_code-base-base-content.
          ls_tax_total-tax_name  = ls_tax_subtotal-tax_category-tax_scheme-name-base-base-content.
          ls_tax_total-tax_rate  = ls_tax_subtotal-percent-base-base-content.
          ls_tax_total-exp_code  = ls_tax_subtotal-tax_category-tax_exemption_reason_code-base-base-content.
          ls_tax_total-exp_name  = ls_tax_subtotal-tax_category-tax_exemption_reason-base-base-content.
          ls_tax_total-tax_amount = ls_tax_subtotal-tax_amount-base-content.
          ls_tax_total-tax_total = ls_line_tax_total-tax_amount-base-content.
          ls_tax_total-tax_base  = ls_tax_subtotal-taxable_amount-base-content.
          ls_tax_total-witholding = 'X'.
          COLLECT ls_tax_total INTO lt_tax_total.
          CLEAR ls_tax_total.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.


    LOOP AT lt_tax_total INTO ls_tax_total.
      IF ls_tax_total-witholding IS NOT INITIAL.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-withholding_tax_total ASSIGNING <ls_tax_total>.
      ELSE.
        APPEND INITIAL LINE TO ms_invoice_ubl-part1-tax_total ASSIGNING <ls_tax_total>.
        IF ls_tax_total-calc_rate NE '-1'. "gkadioglu
          ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content + ls_tax_total-tax_amount.
        ENDIF.
        "stopaj dusurulur
        IF ls_tax_total-tax_code EQ lc_gv_stpj OR ls_tax_total-tax_code EQ lc_kv_stpj.
          ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content - ls_tax_total-tax_amount.
        ELSEIF ( ls_tax_total-tax_code EQ lc_mm_bors OR
                 ls_tax_total-tax_code EQ lc_mm_mera OR
                 ls_tax_total-tax_code EQ lc_mm_sgkp ) AND ms_document-prfid EQ 'MUSTAHSIL'.
          ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content - ls_tax_total-tax_amount.
        ELSE.
          IF ls_tax_total-calc_rate NE '-1'. "gkadioglu
            ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content = ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content + ls_tax_total-tax_total.
          ENDIF.
        ENDIF.



      ENDIF.
      <ls_tax_total>-tax_amount-base-content = ls_tax_total-tax_total.
      <ls_tax_total>-tax_amount-base-currency_id = ms_invoice_ubl-part1-document_currency_code-base-base-content.

      APPEND INITIAL LINE TO <ls_tax_total>-tax_subtotal ASSIGNING <ls_tax_subtotal>.
      <ls_tax_subtotal>-tax_category-tax_scheme-name-base-base-content = ls_tax_total-tax_name.
      <ls_tax_subtotal>-tax_category-tax_scheme-tax_type_code-base-base-content = ls_tax_total-tax_code.
      <ls_tax_subtotal>-tax_category-tax_exemption_reason_code-base-base-content = ls_tax_total-exp_code.
      <ls_tax_subtotal>-tax_category-tax_exemption_reason-base-base-content = ls_tax_total-exp_name.
      <ls_tax_subtotal>-taxable_amount-base-content = ls_tax_total-tax_base.
      <ls_tax_subtotal>-taxable_amount-base-currency_id =  ms_invoice_ubl-part1-document_currency_code-base-base-content.
      <ls_tax_subtotal>-percent-base-base-content = ls_tax_total-tax_rate.
      <ls_tax_subtotal>-tax_amount-base-content = ls_tax_total-tax_amount.
      <ls_tax_subtotal>-tax_amount-base-currency_id =  ms_invoice_ubl-part1-document_currency_code-base-base-content.
      IF ls_tax_total-calc_rate EQ '-1'.
        <ls_tax_subtotal>-calculation_sequence_numeric-base-base-content = ls_tax_total-calc_rate."gkadioglu
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD fill_common_tax_ytb.
    DATA: ls_inv_ytb     TYPE /itetr/inv_ytb,
          lv_mwsk1       TYPE mwskz,
          lv_matnr       TYPE matnr,
          lv_master_data TYPE flag,
          lv_wrbtr       TYPE  bseg-wrbtr,
          lv_currency    TYPE  bkpf-waers,
          lt_mwdat       TYPE TABLE OF rtax1u15,
          ls_mwdat       TYPE rtax1u15,
          lv_percent     TYPE i,
          ls_tax_match   TYPE /itetr/inv_taxm,
          lv_taxm1       TYPE mlan-taxm1,
          lv_knumh       TYPE a002-knumh.

    CLEAR:lt_mwdat[], ls_mwdat,ls_tax_match,lv_currency , lv_wrbtr ,lv_mwsk1.


    lv_currency = is_invoice_line-line_extension_amount-base-currency_id.
    lv_wrbtr    = is_invoice_line-line_extension_amount-base-content.


    SELECT SINGLE * FROM /itetr/inv_ytb INTO ls_inv_ytb WHERE bukrs = ms_document-bukrs AND
                                                              awtyp = ms_document-awtyp.

    IF sy-subrc EQ 0 AND ms_document-awtyp EQ 'VBRK'.

      IF ls_inv_ytb-master_data IS NOT INITIAL AND ls_inv_ytb-kschl IS NOT INITIAL.

        IF is_invoice_line-item-sellers_item_identification-id-base-base-content IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
            EXPORTING
              input  = is_invoice_line-item-sellers_item_identification-id-base-base-content
            IMPORTING
              output = lv_matnr.
        ENDIF.

        CLEAR:lv_taxm1,lv_knumh.

        SELECT SINGLE taxm1
          FROM mlan
          INTO lv_taxm1
          WHERE matnr = lv_matnr AND
                aland = 'TR'.
        IF lv_taxm1 IS NOT INITIAL.
          SELECT SINGLE knumh
            FROM a002
            INTO lv_knumh
          WHERE kappl = 'V'
            AND aland = 'TR'
            AND kschl = ls_inv_ytb-kschl
            AND taxk1 = '1'
            AND taxm1 = lv_taxm1
            AND datab <= sy-datum
            AND datbi >= sy-datum.
          IF lv_knumh IS NOT INITIAL.
            SELECT SINGLE mwsk1
                   FROM konp
                   INTO lv_mwsk1
                WHERE knumh = lv_knumh.
          ENDIF.
        ENDIF.

        "A002 buffer table o nedenle join kaldırıldı
***        SELECT SINGLE konp~mwsk1
***          INTO lv_mwsk1
***          FROM konp AS konp
***          INNER JOIN a002 AS a002 ON a002~knumh = konp~knumh
***          INNER JOIN mlan AS mlan ON mlan~taxm1 = a002~taxm1
***          WHERE mlan~matnr = lv_matnr         AND
***                mlan~aland = 'TR'             AND
***                a002~kappl = 'V'              AND
***                a002~aland = 'TR'             AND
***                a002~kschl = ls_inv_ytb-kschl AND
***                a002~taxk1 = '1'              AND
***                a002~datab <= sy-datum        AND
***                a002~datbi >= sy-datum.

      ENDIF.

      IF  lv_mwsk1 IS NOT INITIAL.
        IF ls_inv_ytb-gross_amount EQ 'X'."brüt tutar üzerinden kdv hesaplanır

          CALL FUNCTION 'CALCULATE_TAX_FROM_GROSSAMOUNT'
            EXPORTING
              i_bukrs                   = ms_document-bukrs
              i_mwskz                   = lv_mwsk1
              i_waers                   = lv_currency
              i_wrbtr                   = lv_wrbtr
            TABLES
              t_mwdat                   = lt_mwdat
            EXCEPTIONS
              bukrs_not_found           = 1
              country_not_found         = 2
              mwskz_not_defined         = 3
              mwskz_not_valid           = 4
              account_not_found         = 5
              different_discount_base   = 6
              different_tax_base        = 7
              txjcd_not_valid           = 8
              not_found                 = 9
              ktosl_not_found           = 10
              kalsm_not_found           = 11
              parameter_error           = 12
              knumh_not_found           = 13
              kschl_not_found           = 14
              unknown_error             = 15
              amounts_too_large_for_tax = 16
              OTHERS                    = 17.

        ELSE."net tutar üzerinden kdv hesaplanır

          CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
            EXPORTING
              i_bukrs           = ms_document-bukrs
              i_mwskz           = lv_mwsk1
              i_waers           = lv_currency
              i_wrbtr           = lv_wrbtr
            TABLES
              t_mwdat           = lt_mwdat
            EXCEPTIONS
              bukrs_not_found   = 1
              country_not_found = 2
              mwskz_not_defined = 3
              mwskz_not_valid   = 4
              ktosl_not_found   = 5
              kalsm_not_found   = 6
              parameter_error   = 7
              knumh_not_found   = 8
              kschl_not_found   = 9
              OTHERS            = 10.

        ENDIF.
      ENDIF.
    ENDIF.

    IF lv_mwsk1 IS INITIAL.

      IF is_item_ytb-mwskz IS NOT INITIAL .

        lv_mwsk1 = is_item_ytb-mwskz.

        CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
          EXPORTING
            i_bukrs           = ms_document-bukrs
            i_mwskz           = lv_mwsk1
            i_waers           = lv_currency
            i_wrbtr           = lv_wrbtr
          TABLES
            t_mwdat           = lt_mwdat
          EXCEPTIONS
            bukrs_not_found   = 1
            country_not_found = 2
            mwskz_not_defined = 3
            mwskz_not_valid   = 4
            ktosl_not_found   = 5
            kalsm_not_found   = 6
            parameter_error   = 7
            knumh_not_found   = 8
            kschl_not_found   = 9
            OTHERS            = 10.

      ELSEIF is_item_ytb-taxrt IS NOT INITIAL.
        ls_mwdat-wmwst =  lv_wrbtr * is_item_ytb-taxrt / 100.
        ls_mwdat-msatz = is_item_ytb-taxrt.
        APPEND ls_mwdat TO lt_mwdat.
      ENDIF.
    ENDIF.


    READ TABLE lt_mwdat INTO ls_mwdat INDEX 1.
    IF  sy-subrc EQ 0.
      IF cs_tax_subtotal-taxable_amount-base-content IS INITIAL OR cs_tax_subtotal-taxable_amount-base-content EQ '0.00'.
        cs_tax_subtotal-taxable_amount-base-content = lv_wrbtr.
        cs_tax_subtotal-taxable_amount-base-currency_id = lv_currency.
      ENDIF.
      cs_tax_subtotal-tax_amount-base-currency_id = lv_currency.
      cs_tax_subtotal-tax_amount-base-content = ls_mwdat-wmwst.
      ls_tax_match = get_tax_match( iv_kalsm  = iv_kalsm
                                    iv_mwskz  = lv_mwsk1 ).
      IF ls_tax_match-taxrt IS NOT INITIAL.
        cs_tax_subtotal-percent-base-base-content =  ls_tax_match-taxrt.
      ELSE.
        cs_tax_subtotal-percent-base-base-content = lv_percent = ls_mwdat-msatz.
      ENDIF.
      cs_tax_subtotal-calculation_sequence_numeric-base-base-content = '-1'.
    ENDIF.

  ENDMETHOD.


  METHOD generate_invoice_id.
    DATA: ls_serial        TYPE /itetr/inv_eisr,
          lv_max_date      TYPE d,
          lx_etr_exception TYPE REF TO /itetr/cx_regulative_exception,
          lv_number_object TYPE nrobj,
          lv_gjahr         TYPE gjahr,
          lv_aktif_parelel TYPE /itetr/com_cmpcp-value.
    lv_gjahr = ms_document-bldat(4).



    SELECT SINGLE value FROM /itetr/com_cmpcp INTO  lv_aktif_parelel WHERE ( bukrs = ms_document-bukrs OR bukrs = space ) AND
                                                                            cuspa =  'ACT_NUMBER'.

    CASE ms_document-prfid.
      WHEN 'EARSIV'.
        lv_number_object = '/ITETR/EAR'.
        SELECT SINGLE *
          FROM /itetr/inv_easr
          INTO ls_serial
          WHERE bukrs = ms_document-bukrs
            AND serpr = ms_document-serpr.
      WHEN 'MUSTAHSIL'.
        lv_number_object = '/ITETR/EMM'.
        SELECT SINGLE *
          FROM /itetr/inv_emsr
          INTO ls_serial
          WHERE bukrs = ms_document-bukrs
            AND serpr = ms_document-serpr.
      WHEN OTHERS.
        lv_number_object = '/ITETR/EIN'.
        SELECT SINGLE *
          FROM /itetr/inv_eisr
          INTO ls_serial
          WHERE bukrs = ms_document-bukrs
            AND serpr = ms_document-serpr.
    ENDCASE.
    IF sy-subrc IS NOT INITIAL.
      lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '030'
                                                                            iv_msgv1 = ms_document-serpr ).
      RAISE EXCEPTION lx_etr_exception.
    ENDIF.

    DATA lv_invoice_no TYPE c LENGTH 16.
    DATA lv_days TYPE i.
    DATA lv_days_num TYPE n LENGTH 1.

    CASE mv_generate_invoice_id.
      WHEN 'X'.
        WHILE ms_document-invno IS INITIAL.
          CONCATENATE ls_serial-serpr lv_gjahr '%' INTO lv_invoice_no.
          SELECT MAX( bldat )
            FROM /itetr/inv_oginv                   "#EC CI_NOFIELD
            INTO lv_max_date
            WHERE bukrs = ms_document-bukrs
              AND invno LIKE lv_invoice_no.
          IF sy-subrc IS NOT INITIAL OR lv_max_date IS INITIAL OR lv_max_date LE ms_document-bldat.

            IF lv_aktif_parelel IS NOT INITIAL.
              CALL FUNCTION '/ITETR/COM_CREATE_NUMBER'
                EXPORTING
                  nr_range_nr = ls_serial-numrn
                  object      = lv_number_object
                  quantity    = '1'
                  toyear      = lv_gjahr
                  bukrs       = ms_document-bukrs
                IMPORTING
                  number      = ms_document-invno.

              IF ms_document-invno IS INITIAL.

                CALL FUNCTION 'NUMBER_GET_NEXT'
                  EXPORTING
                    nr_range_nr             = ls_serial-numrn
                    object                  = lv_number_object
                    quantity                = '1'
                    subobject               = ms_document-bukrs
                    toyear                  = lv_gjahr
                  IMPORTING
                    number                  = ms_document-invno
                  EXCEPTIONS
                    interval_not_found      = 1
                    number_range_not_intern = 2
                    object_not_found        = 3
                    quantity_is_0           = 4
                    quantity_is_not_1       = 5
                    interval_overflow       = 6
                    buffer_overflow         = 7
                    OTHERS                  = 8.
                IF sy-subrc IS NOT INITIAL.
                  lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgid = sy-msgid
                                                                                        iv_msgno = sy-msgno
                                                                                        iv_msgv1 = sy-msgv1
                                                                                        iv_msgv2 = sy-msgv2
                                                                                        iv_msgv3 = sy-msgv3
                                                                                        iv_msgv4 = sy-msgv4 ).
                  RAISE EXCEPTION lx_etr_exception.
                ELSE.
                  ms_document-invno(3) = ls_serial-serpr.
                  ms_document-invno+3(4) = lv_gjahr.
                ENDIF.


              ELSE.

                ms_document-invno(3) = ls_serial-serpr.
                ms_document-invno+3(4) = lv_gjahr.


              ENDIF.

            ELSE.

              CALL FUNCTION 'NUMBER_GET_NEXT'
                EXPORTING
                  nr_range_nr             = ls_serial-numrn
                  object                  = lv_number_object
                  quantity                = '1'
                  subobject               = ms_document-bukrs
                  toyear                  = lv_gjahr
                IMPORTING
                  number                  = ms_document-invno
                EXCEPTIONS
                  interval_not_found      = 1
                  number_range_not_intern = 2
                  object_not_found        = 3
                  quantity_is_0           = 4
                  quantity_is_not_1       = 5
                  interval_overflow       = 6
                  buffer_overflow         = 7
                  OTHERS                  = 8.
              IF sy-subrc IS NOT INITIAL.
                lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgid = sy-msgid
                                                                                      iv_msgno = sy-msgno
                                                                                      iv_msgv1 = sy-msgv1
                                                                                      iv_msgv2 = sy-msgv2
                                                                                      iv_msgv3 = sy-msgv3
                                                                                      iv_msgv4 = sy-msgv4 ).
                RAISE EXCEPTION lx_etr_exception.
              ELSE.
                ms_document-invno(3) = ls_serial-serpr.
                ms_document-invno+3(4) = lv_gjahr.
              ENDIF.

            ENDIF.



          ELSEIF ls_serial-nxtsp IS INITIAL.
            lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '031'
                                                                                  iv_msgv1 = ms_document-serpr ).
            RAISE EXCEPTION lx_etr_exception.
          ELSE.
            CASE ms_document-prfid.
              WHEN 'EARSIV'.
                lv_number_object = '/ITETR/EAR'.
                SELECT SINGLE *
                  FROM /itetr/inv_easr
                  INTO ls_serial
                  WHERE bukrs = ms_document-bukrs
                    AND serpr = ls_serial-nxtsp.
              WHEN OTHERS.
                lv_number_object = '/ITETR/EIN'.
                SELECT SINGLE *
                  FROM /itetr/inv_eisr
                  INTO ls_serial
                  WHERE bukrs = ms_document-bukrs
                    AND serpr = ls_serial-nxtsp.
            ENDCASE.
            IF sy-subrc IS NOT INITIAL.
              lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '031'
                                                                                    iv_msgv1 = ms_document-serpr ).
              RAISE EXCEPTION lx_etr_exception.
            ENDIF.
          ENDIF.
        ENDWHILE.
      WHEN 'D'.
        lv_days = sy-datum - ms_document-bldat.
        IF lv_days >= 8.
          lv_days_num = 8.
        ELSE.
          lv_days_num = lv_days.
        ENDIF.
        CONCATENATE ls_serial-serpr lv_days_num lv_gjahr INTO lv_invoice_no.
        CONCATENATE ls_serial-numrn lv_days_num INTO ls_serial-numrn.

        IF lv_aktif_parelel IS NOT INITIAL.
          CALL FUNCTION '/ITETR/COM_CREATE_NUMBER'
            EXPORTING
              nr_range_nr = ls_serial-numrn
              object      = lv_number_object
              quantity    = '1'
              toyear      = lv_gjahr
              bukrs       = ms_document-bukrs
            IMPORTING
              number      = ms_document-invno.

          IF ms_document-invno IS INITIAL.


            CALL FUNCTION 'NUMBER_GET_NEXT'
              EXPORTING
                nr_range_nr             = ls_serial-numrn
                object                  = lv_number_object
                quantity                = '1'
                subobject               = ms_document-bukrs
                toyear                  = lv_gjahr
              IMPORTING
                number                  = ms_document-invno
              EXCEPTIONS
                interval_not_found      = 1
                number_range_not_intern = 2
                object_not_found        = 3
                quantity_is_0           = 4
                quantity_is_not_1       = 5
                interval_overflow       = 6
                buffer_overflow         = 7
                OTHERS                  = 8.
            IF sy-subrc IS NOT INITIAL.
              lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgid = sy-msgid
                                                                                    iv_msgno = sy-msgno
                                                                                    iv_msgv1 = sy-msgv1
                                                                                    iv_msgv2 = sy-msgv2
                                                                                    iv_msgv3 = sy-msgv3
                                                                                    iv_msgv4 = sy-msgv4 ).
              RAISE EXCEPTION lx_etr_exception.
            ELSE.
              ms_document-invno(7) = lv_invoice_no.
            ENDIF.

          ELSE.
            ms_document-invno(7) = lv_invoice_no.
          ENDIF.

        ELSE.


          CALL FUNCTION 'NUMBER_GET_NEXT'
            EXPORTING
              nr_range_nr             = ls_serial-numrn
              object                  = lv_number_object
              quantity                = '1'
              subobject               = ms_document-bukrs
              toyear                  = lv_gjahr
            IMPORTING
              number                  = ms_document-invno
            EXCEPTIONS
              interval_not_found      = 1
              number_range_not_intern = 2
              object_not_found        = 3
              quantity_is_0           = 4
              quantity_is_not_1       = 5
              interval_overflow       = 6
              buffer_overflow         = 7
              OTHERS                  = 8.
          IF sy-subrc IS NOT INITIAL.
            lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgid = sy-msgid
                                                                                  iv_msgno = sy-msgno
                                                                                  iv_msgv1 = sy-msgv1
                                                                                  iv_msgv2 = sy-msgv2
                                                                                  iv_msgv3 = sy-msgv3
                                                                                  iv_msgv4 = sy-msgv4 ).
            RAISE EXCEPTION lx_etr_exception.
          ELSE.
            ms_document-invno(7) = lv_invoice_no.
          ENDIF.


        ENDIF.


    ENDCASE.

    IF ms_document-invno IS NOT INITIAL.
      UPDATE /itetr/inv_oginv
        SET invno = ms_document-invno
        WHERE docui = ms_document-docui.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.


  METHOD get_data_bkpf.
    DATA: ls_bseg  TYPE bseg,
          lv_ktopl TYPE ktopl,
          lv_kotp2 TYPE ktop2.

    SELECT SINGLE *
       FROM bkpf
       INTO rs_data-bkpf
       WHERE bukrs = iv_bukrs
         AND belnr = iv_belnr
         AND gjahr = iv_gjahr.
    CHECK sy-subrc IS INITIAL.

    SELECT SINGLE *
      FROM t001
      INTO rs_data-t001
      WHERE bukrs = iv_bukrs.

    SELECT *
      FROM t005
      INTO TABLE rs_data-t005
      WHERE land1 = rs_data-t001-land1.

    SELECT SINGLE *
      FROM bsec
      INTO rs_data-bsec
      WHERE bukrs = iv_bukrs
        AND belnr = iv_belnr
        AND gjahr = iv_gjahr.
    IF sy-subrc IS INITIAL.
      mo_invoice_operations->get_accounting_onetime_tax(
        EXPORTING
          is_bsec       = rs_data-bsec
        IMPORTING
          ev_taxid      = rs_data-taxid
          ev_tax_office = rs_data-tax_office ).

      IF rs_data-bsec-land1 IS NOT INITIAL AND  rs_data-t005 IS INITIAL. "AS
        SELECT *
          FROM t005
          APPENDING TABLE rs_data-t005
          WHERE land1 = rs_data-bsec-land1.
      ENDIF.

      IF rs_data-bsec-regio IS NOT INITIAL.
        SELECT *
            FROM t005u
            INTO TABLE rs_data-t005u
            WHERE spras = sy-langu
              AND land1 = rs_data-bsec-land1
              AND bland = rs_data-bsec-regio.
      ENDIF.
    ENDIF.

    IF rs_data-t005 IS NOT INITIAL.
      SELECT *
        FROM t005t
        INTO TABLE rs_data-t005t
        FOR ALL ENTRIES IN rs_data-t005
        WHERE spras = sy-langu
          AND land1 = rs_data-t005-land1.
    ENDIF.

    SELECT *
      FROM bseg
      INTO TABLE rs_data-bseg
      WHERE bukrs = iv_bukrs
        AND belnr = iv_belnr
        AND gjahr = iv_gjahr.
    IF sy-subrc IS INITIAL.
      LOOP AT rs_data-bseg INTO ls_bseg USING KEY by_koart WHERE koart = 'D'
                                                             AND shkzg = 'S'.
        IF rs_data-bseg_partner IS INITIAL.
          rs_data-bseg_partner = ls_bseg.
        ELSE.
          ADD ls_bseg-dmbtr TO rs_data-bseg_partner-dmbtr.
          ADD ls_bseg-wrbtr TO rs_data-bseg_partner-wrbtr.
        ENDIF.
      ENDLOOP.
      IF sy-subrc IS NOT INITIAL.
        LOOP AT rs_data-bseg INTO ls_bseg USING KEY by_koart WHERE koart = 'K'
                                                               AND shkzg = 'S'.
          IF rs_data-bseg_partner IS INITIAL.
            rs_data-bseg_partner = ls_bseg.
          ELSE.
            ADD ls_bseg-dmbtr TO rs_data-bseg_partner-dmbtr.
            ADD ls_bseg-wrbtr TO rs_data-bseg_partner-wrbtr.
          ENDIF.
        ENDLOOP.
      ENDIF.

      IF rs_data-bsec IS INITIAL.
        IF rs_data-bseg_partner-kunnr IS NOT INITIAL.
          mo_invoice_operations->get_customer_taxid(
            EXPORTING
              iv_kunnr      = rs_data-bseg_partner-kunnr
            IMPORTING
              ev_taxid      = rs_data-taxid
              ev_tax_office = rs_data-tax_office ).
          SELECT SINGLE adrnr
            FROM kna1
            INTO rs_data-address_number
            WHERE kunnr = rs_data-bseg_partner-kunnr.
        ELSEIF rs_data-bseg_partner-lifnr IS NOT INITIAL.
          mo_invoice_operations->get_vendor_taxid(
            EXPORTING
              iv_lifnr      = rs_data-bseg_partner-lifnr
            IMPORTING
              ev_taxid      = rs_data-taxid
              ev_tax_office = rs_data-tax_office ).
          SELECT SINGLE adrnr
            FROM lfa1
            INTO rs_data-address_number
            WHERE lifnr = rs_data-bseg_partner-lifnr.
        ENDIF.
      ENDIF.

      SELECT SINGLE ktopl ktop2
        FROM t001
        INTO ( lv_ktopl , lv_kotp2 )
        WHERE bukrs = iv_bukrs.
      IF lv_kotp2 IS NOT INITIAL .
        lv_ktopl = lv_kotp2.
      ENDIF.

      SELECT *
        FROM skat
        INTO TABLE rs_data-skat
        FOR ALL ENTRIES IN rs_data-bseg
        WHERE spras = sy-langu
          AND ktopl = lv_ktopl
          AND saknr = rs_data-bseg-hkont.

      SELECT *
        FROM skat
        APPENDING TABLE rs_data-skat
        FOR ALL ENTRIES IN rs_data-bseg
        WHERE spras = sy-langu
          AND ktopl = lv_ktopl
          AND saknr = rs_data-bseg-lokkt.

      SELECT *
        FROM /itetr/inv_fiac
        INTO TABLE rs_data-accounts
        WHERE ktopl = lv_ktopl.
    ENDIF.

    DATA lv_tdname TYPE stxh-tdname.
    FIELD-SYMBOLS: <ls_texts> TYPE /itetr/cl_outgoing_invoice=>mty_texts.
    CONCATENATE iv_bukrs iv_belnr iv_gjahr INTO lv_tdname.
    SELECT tdobject tdname tdid tdspras
      FROM stxh
      INTO CORRESPONDING FIELDS OF TABLE rs_data-texts
      WHERE tdobject = 'BELEG'
        AND tdname = lv_tdname.
    IF sy-subrc IS INITIAL.
      LOOP AT rs_data-texts ASSIGNING <ls_texts>.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = <ls_texts>-tdid
            language                = <ls_texts>-tdspras
            name                    = <ls_texts>-tdname
            object                  = <ls_texts>-tdobject
          TABLES
            lines                   = <ls_texts>-tline
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        CHECK sy-subrc IS NOT INITIAL.
        CLEAR <ls_texts>-tline.
      ENDLOOP.
    ENDIF.

    CONCATENATE iv_bukrs iv_belnr iv_gjahr rs_data-bseg_partner-buzei INTO lv_tdname.
    SELECT tdobject tdname tdid tdspras
      FROM stxh
      APPENDING CORRESPONDING FIELDS OF TABLE rs_data-texts
      WHERE tdobject = 'DOC_ITEM'
        AND tdname = lv_tdname.
    IF sy-subrc IS INITIAL.
      LOOP AT rs_data-texts ASSIGNING <ls_texts>.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = <ls_texts>-tdid
            language                = <ls_texts>-tdspras
            name                    = <ls_texts>-tdname
            object                  = <ls_texts>-tdobject
          TABLES
            lines                   = <ls_texts>-tline
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        CHECK sy-subrc IS NOT INITIAL.
        CLEAR <ls_texts>-tline.
      ENDLOOP.
    ENDIF.


    IF ms_document-invty = 'IADE'    OR ms_document-invty = 'TEVIADE' OR
       ms_document-invty = 'YTBIADE' OR ms_document-invty = 'YTBTEVIADE'.

      DATA : lt_return_ref TYPE TABLE OF /itetr/inv_retrn,
             ls_return_ref TYPE /itetr/inv_retrn,
             ls_bkpf       TYPE bkpf,
             ls_rseg       TYPE rseg,
             lt_rseg       TYPE TABLE OF rseg,
             ls_ekko       TYPE ekko,
             ls_ekpo       TYPE ekpo.
      DATA : lv_value1 TYPE char100.
      DATA : lv_value2 TYPE char100.
      DATA : lv_value3 TYPE char100.
      DATA : lv_value4 TYPE char100.
      DATA : lv_separator TYPE string.
      DATA : lv_date_format TYPE  /itetr/com_e_date_format.
      DATA : ls_reft_tab LIKE LINE OF rs_data-return_ref.
      FIELD-SYMBOLS: <fs_str> TYPE any.
      FIELD-SYMBOLS: <fs_val> TYPE any.

      DATA:lv_strname TYPE char30.

      TYPES: BEGIN OF ty_return_ref,
               value TYPE c LENGTH 150,
             END OF ty_return_ref.

      DATA: ls_return_ref_data TYPE ty_return_ref.
      DATA: lt_return_ref_data TYPE TABLE OF ty_return_ref.


      SELECT * FROM  /itetr/inv_retrn INTO TABLE lt_return_ref WHERE awtyp = 'BKPF' AND
                                                                     bukrs = ms_document-bukrs.
      SORT lt_return_ref BY bukrs DESCENDING.

      ls_bkpf = rs_data-bkpf.
      ASSIGN (lv_strname) TO <fs_str>.

      LOOP AT lt_return_ref INTO ls_return_ref.

        CONCATENATE 'LS_' ls_return_ref-return_tab_name INTO lv_strname.

        CASE ls_return_ref-return_tab_name .
          WHEN 'BKPF'.

            ASSIGN (lv_strname) TO <fs_str>.
            ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
            IF <fs_val> IS ASSIGNED.
              ls_return_ref_data = <fs_val>.
              IF ls_return_ref_data IS NOT INITIAL.
*                APPEND ls_return_ref_data TO lt_return_ref_data.
                COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
              ENDIF.
            ENDIF.

          WHEN 'BSEG'.
            DATA : lt_tmp_bseg TYPE TABLE OF bseg.
            CLEAR lt_tmp_bseg.
            lt_tmp_bseg = rs_data-bseg.
            IF ls_return_ref-exclude_d_k IS NOT INITIAL.
*              CLEAR lt_tmp_bseg.
*              lt_tmp_bseg = rs_data-bseg.
              DELETE lt_tmp_bseg WHERE koart = 'D' OR koart = 'K'.
            ENDIF.
            LOOP AT lt_tmp_bseg ASSIGNING <fs_str> .
              ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
              IF <fs_val> IS ASSIGNED.
                ls_return_ref_data = <fs_val>.
                IF ls_return_ref_data IS NOT INITIAL.
*                  APPEND ls_return_ref_data TO lt_return_ref_data.
                  COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
                ENDIF.
              ENDIF.
            ENDLOOP.
        ENDCASE.
        lv_date_format = ls_return_ref-date_format.
      ENDLOOP.

      LOOP AT lt_return_ref_data INTO ls_return_ref_data.

        READ TABLE lt_return_ref INTO ls_return_ref INDEX 1.
        IF ls_return_ref_data IS NOT INITIAL.
          lv_separator = ls_return_ref-seperator.
          CONDENSE ls_return_ref_data NO-GAPS.
          SPLIT ls_return_ref_data AT lv_separator  INTO lv_value1
                                                         lv_value2
                                                         lv_value3
                                                         lv_value4.
          CONDENSE lv_value2 NO-GAPS.
          IF lv_value1 IS NOT INITIAL.
            ls_reft_tab-return_ref_no = lv_value1.
            CASE lv_date_format.
              WHEN 'DD.MM.YYYY' OR 'DD/MM/YYYY' OR 'DD-MM-YYYY'.
                CONCATENATE lv_value2+6(4) lv_value2+3(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'MM.DD.YYYY' OR 'MM/DD/YYYY' OR 'MM-DD-YYYY'.
                CONCATENATE lv_value2+6(4) lv_value2+3(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'YYYY/MM/DD' OR 'YYYY.MM.DD' OR 'YYYY-MM-DD'.
                CONCATENATE lv_value2+0(4) lv_value2+5(2) lv_value2+8(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'YYYYMMDD'.
                ls_reft_tab-return_ref_date = lv_value2.
              WHEN 'DDMMYYYY'.
                CONCATENATE lv_value2+4(4) lv_value2+2(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'MMDDYYYY'.
                CONCATENATE lv_value2+4(4) lv_value2+0(2) lv_value2+2(2)  INTO  ls_reft_tab-return_ref_date.
            ENDCASE.
            CONCATENATE ls_reft_tab-return_ref_date+0(4)
                        ls_reft_tab-return_ref_date+4(2)
                        ls_reft_tab-return_ref_date+6(2)
               INTO     ls_reft_tab-return_ref_date
               SEPARATED BY '-'.
            COLLECT  ls_reft_tab  INTO rs_data-return_ref.
*            APPEND ls_reft_tab TO rs_data-return_ref.
          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.




  ENDMETHOD.


  METHOD get_data_fica.

    DATA : ls_dfkkopk TYPE dfkkopk.

    SELECT SINGLE *
      FROM /itetr/inv_oginv           "#EC CI_NOFIELD
      INTO rs_data-oginv
      WHERE bukrs      EQ iv_bukrs
        AND belnr_fica EQ iv_belnr
        AND gjahr      EQ iv_gjahr
        AND gpart      EQ iv_gpart.

    SELECT SINGLE *
      FROM t001
      INTO rs_data-t001
      WHERE bukrs = iv_bukrs.

    SELECT *
      FROM t005
      INTO TABLE rs_data-t005
      WHERE land1 = rs_data-t001-land1.

    IF rs_data-t005 IS NOT INITIAL.
      SELECT *
        FROM t005t
        INTO TABLE rs_data-t005t
        FOR ALL ENTRIES IN rs_data-t005
        WHERE spras = sy-langu
          AND land1 = rs_data-t005-land1.
    ENDIF.

    SELECT *
      FROM t030k
      INTO TABLE rs_data-t030k
      WHERE ktopl EQ rs_data-t001-ktopl.

    SELECT SINGLE *
      FROM dfkkko
      INTO rs_data-dfkkko
      WHERE opbel EQ iv_belnr.

    SELECT SINGLE *
      FROM dfkkop
      INTO rs_data-dfkkop
      WHERE opbel EQ iv_belnr.

    SELECT *
      FROM dfkkopk
      INTO TABLE rs_data-dfkkopk
      WHERE opbel EQ iv_belnr.

    LOOP AT rs_data-dfkkopk INTO ls_dfkkopk.
      IF ls_dfkkopk-betrh LE '0'.
        ls_dfkkopk-betrh = ls_dfkkopk-betrh * -1.
      ENDIF.

      IF ls_dfkkopk-betrw LE '0'.
        ls_dfkkopk-betrw = ls_dfkkopk-betrw * -1.
      ENDIF.

      IF ls_dfkkopk-betr2 LE '0'.
        ls_dfkkopk-betr2 = ls_dfkkopk-betr2 * -1.
      ENDIF.

      IF ls_dfkkopk-betr3 LE '0'.
        ls_dfkkopk-betr3 = ls_dfkkopk-betr3 * -1.
      ENDIF.

      IF ls_dfkkopk-sbash LE '0'.
        ls_dfkkopk-sbash = ls_dfkkopk-sbash * -1.
      ENDIF.

      IF ls_dfkkopk-sbasw LE '0'.
        ls_dfkkopk-sbasw = ls_dfkkopk-sbasw * -1.
      ENDIF.

      MODIFY rs_data-dfkkopk FROM ls_dfkkopk.
    ENDLOOP.

    LOOP AT rs_data-dfkkopk INTO ls_dfkkopk WHERE gsber EQ '0001'.
      rs_data-dfkkopk_partner = ls_dfkkopk.
    ENDLOOP.




  ENDMETHOD.


  METHOD get_data_rmrp.
    DATA: lt_return        TYPE TABLE OF bapiret2,
          lv_tdname        TYPE stxh-tdname,
          lt_matnr_range   TYPE RANGE OF matnr,
          ls_matnr_range   LIKE LINE OF lt_matnr_range,
          ls_material_data TYPE bapi_incinv_detail_material,
          lt_t005          TYPE TABLE OF t005,
          lt_mara          TYPE TABLE OF mara,
          ls_mara          TYPE mara.
    DATA: ls_mseg          TYPE mseg.
    FIELD-SYMBOLS: <ls_texts> TYPE /itetr/cl_outgoing_invoice=>mty_texts.
    CALL FUNCTION 'BAPI_INCOMINGINVOICE_GETDETAIL'
      EXPORTING
        invoicedocnumber = iv_belnr
        fiscalyear       = iv_gjahr
      IMPORTING
        headerdata       = rs_data-headerdata
        addressdata      = rs_data-addressdata
      TABLES
        itemdata         = rs_data-itemdata
        accountingdata   = rs_data-accountingdata
        glaccountdata    = rs_data-glaccountdata
        materialdata     = rs_data-materialdata
        taxdata          = rs_data-taxdata
        return           = lt_return.
    CHECK rs_data-headerdata IS NOT INITIAL.

    SELECT SINGLE *
      FROM t001
      INTO rs_data-t001
      WHERE bukrs = rs_data-headerdata-comp_code.

    SELECT *
      FROM t005
      INTO TABLE lt_t005
      WHERE land1 = rs_data-t001-land1.

    SELECT SINGLE adrnr
      FROM lfa1
      INTO rs_data-address_number
      WHERE lifnr = rs_data-headerdata-diff_inv.

    IF rs_data-itemdata IS NOT INITIAL.
      SELECT *
        FROM ekpo
        INTO TABLE rs_data-ekpo
        FOR ALL ENTRIES IN rs_data-itemdata
        WHERE ekpo~ebeln = rs_data-itemdata-po_number
          AND ekpo~ebelp = rs_data-itemdata-po_item.
      IF sy-subrc IS INITIAL.
        SELECT *
          FROM ekko
          INTO TABLE rs_data-ekko
          FOR ALL ENTRIES IN rs_data-ekpo
          WHERE ebeln = rs_data-ekpo-ebeln.  "#EC CI_NO_TRANSFORM

        SELECT *
          FROM ekbe
          INTO TABLE rs_data-ekbe
          FOR ALL ENTRIES IN rs_data-ekpo
          WHERE ebeln = rs_data-ekpo-ebeln
            AND ebelp = rs_data-ekpo-ebelp. "#EC CI_NO_TRANSFORM
        IF sy-subrc IS INITIAL.
          SELECT *
            FROM mseg
            INTO TABLE rs_data-mseg
            FOR ALL ENTRIES IN rs_data-ekbe
            WHERE mblnr = rs_data-ekbe-belnr
              AND mjahr = rs_data-ekbe-gjahr
              AND zeile = rs_data-ekbe-buzei. "#EC CI_NO_TRANSFORM

          LOOP AT rs_data-mseg INTO ls_mseg.
            READ TABLE rs_data-mseg TRANSPORTING NO FIELDS WITH KEY smbln = ls_mseg-mblnr
                                                                    sjahr = ls_mseg-mjahr
                                                                    smblp = ls_mseg-zeile.
            IF sy-subrc IS INITIAL.
              DELETE rs_data-mseg INDEX sy-tabix.
            ENDIF.
          ENDLOOP.
*              AND NOT EXISTS ( SELECT * FROM mseg WHERE smbln = mseg~mblnr AND sjahr = mseg~mjahr AND smblp = mseg~zeile ).
        ENDIF.

        "gkadioglu
        IF rs_data-mseg[] IS NOT INITIAL.
          SELECT *
          FROM mkpf
          INTO TABLE rs_data-mkpf
          FOR ALL ENTRIES IN rs_data-mseg
          WHERE mblnr = rs_data-mseg-mblnr
            AND mjahr = rs_data-mseg-mjahr.
        ENDIF.

        SELECT *
          FROM mara
          INTO TABLE rs_data-mara
          FOR ALL ENTRIES IN rs_data-ekpo
          WHERE matnr = rs_data-ekpo-matnr. "#EC CI_NO_TRANSFORM

        SELECT *
          FROM maw1
          INTO TABLE rs_data-maw1
          FOR ALL ENTRIES IN rs_data-ekpo
          WHERE matnr = rs_data-ekpo-matnr. "#EC CI_NO_TRANSFORM

        IF sy-subrc IS INITIAL.
          SELECT *
            FROM t005
            APPENDING TABLE lt_t005
            FOR ALL ENTRIES IN rs_data-maw1
            WHERE land1 = rs_data-maw1-wherl.
        ENDIF.

        SELECT *
          FROM marc
          INTO TABLE rs_data-marc
          FOR ALL ENTRIES IN rs_data-ekpo
          WHERE matnr = rs_data-ekpo-matnr
            AND werks = rs_data-ekpo-werks. "#EC CI_NO_TRANSFORM

        IF sy-subrc IS INITIAL.
          SELECT *
            FROM t005
            APPENDING TABLE lt_t005
            FOR ALL ENTRIES IN rs_data-marc
            WHERE land1 = rs_data-marc-herkl.
        ENDIF.

      ENDIF.
    ENDIF.

    IF rs_data-materialdata IS NOT INITIAL.
      TYPES : BEGIN OF ty_mat,
                matnr TYPE mara-matnr,
                werks TYPE marc-werks,
              END OF ty_mat.
      DATA: lt_mat TYPE TABLE OF ty_mat,
            ls_mat TYPE ty_mat.

      LOOP AT rs_data-materialdata INTO ls_material_data.
        ls_matnr_range-sign = 'I'.
        ls_matnr_range-option = 'EQ'.
        ls_matnr_range-low = ls_material_data-material.
        COLLECT ls_matnr_range INTO lt_matnr_range.
        ls_mat-matnr = ls_material_data-material.
        ls_mat-werks = ls_material_data-val_area.
        APPEND ls_mat TO lt_mat.
      ENDLOOP.

      SORT lt_mat.
      DELETE ADJACENT DUPLICATES FROM lt_mat COMPARING ALL FIELDS.

      SELECT *
        FROM mara
        INTO TABLE lt_mara
        WHERE matnr IN lt_matnr_range.

      LOOP AT lt_mara INTO ls_mara.
        INSERT ls_mara INTO TABLE rs_data-mara.
      ENDLOOP.

      IF lt_mat[] IS NOT INITIAL.

        SELECT *
          FROM maw1
          INTO TABLE rs_data-maw1
          FOR ALL ENTRIES IN lt_mat
          WHERE matnr = lt_mat-matnr.

        IF sy-subrc IS INITIAL.
          SELECT *
            FROM t005
            APPENDING TABLE lt_t005
            FOR ALL ENTRIES IN rs_data-maw1
            WHERE land1 = rs_data-maw1-wherl.
        ENDIF.

        SELECT *
          FROM marc
          INTO TABLE rs_data-marc
          FOR ALL ENTRIES IN lt_mat
          WHERE matnr = lt_mat-matnr
            AND werks = lt_mat-werks.

        IF sy-subrc IS INITIAL.
          SELECT *
            FROM t005
            APPENDING TABLE lt_t005
            FOR ALL ENTRIES IN rs_data-marc
            WHERE land1 = rs_data-marc-herkl.
        ENDIF.

      ENDIF.

    ENDIF.


    SORT lt_t005 BY land1.
    DELETE ADJACENT DUPLICATES FROM lt_t005 COMPARING land1.
    rs_data-t005 = lt_t005.

    IF rs_data-t005 IS NOT INITIAL.
      SELECT *
        FROM t005t
        INTO TABLE rs_data-t005t
        FOR ALL ENTRIES IN rs_data-t005
        WHERE spras = sy-langu
          AND land1 = rs_data-t005-land1.
    ENDIF.


    IF rs_data-mara IS NOT INITIAL.
      SELECT *
        FROM makt
        INTO TABLE rs_data-makt
        FOR ALL ENTRIES IN rs_data-mara
        WHERE spras = sy-langu
          AND matnr = rs_data-mara-matnr.
    ENDIF.

    mo_invoice_operations->get_vendor_taxid(
      EXPORTING
        iv_lifnr      = rs_data-headerdata-diff_inv
      IMPORTING
        ev_taxid      = rs_data-taxid
        ev_tax_office = rs_data-tax_office ).

    CONCATENATE iv_belnr iv_gjahr INTO lv_tdname.
    SELECT tdobject tdname tdid tdspras
      FROM stxh
      INTO CORRESPONDING FIELDS OF TABLE rs_data-texts
      WHERE tdobject = 'RBKP'
        AND tdid = '0001'
        AND tdname = lv_tdname.
    IF sy-subrc IS INITIAL.
      LOOP AT rs_data-texts ASSIGNING <ls_texts>.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = <ls_texts>-tdid
            language                = <ls_texts>-tdspras
            name                    = <ls_texts>-tdname
            object                  = <ls_texts>-tdobject
          TABLES
            lines                   = <ls_texts>-tline
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        CHECK sy-subrc IS NOT INITIAL.
        CLEAR <ls_texts>-tline.
      ENDLOOP.
    ENDIF.

    IF ms_document-invty = 'IADE'    OR ms_document-invty = 'TEVIADE'   OR
       ms_document-invty = 'YTBIADE' OR ms_document-invty = 'YTBTEVIADE'.

      DATA : lt_return_ref TYPE TABLE OF /itetr/inv_retrn,
             ls_return_ref TYPE /itetr/inv_retrn,
             ls_rbkp       TYPE rbkp,
             ls_rseg       TYPE rseg,
             lt_rseg       TYPE TABLE OF rseg,
             ls_ekko       TYPE ekko,
             ls_ekpo       TYPE ekpo.
      DATA : lv_value1 TYPE char100.
      DATA : lv_value2 TYPE char100.
      DATA : lv_value3 TYPE char100.
      DATA : lv_value4 TYPE char100.
      DATA : lv_separator TYPE string.
      DATA : lv_date_format TYPE  /itetr/com_e_date_format.
      DATA : ls_reft_tab LIKE LINE OF rs_data-return_ref.
      FIELD-SYMBOLS: <fs_str> TYPE any.
      FIELD-SYMBOLS: <fs_val> TYPE any.

      DATA:lv_strname TYPE char30.

      TYPES: BEGIN OF ty_return_ref,
               value TYPE c LENGTH 150,
             END OF ty_return_ref.

      DATA: ls_return_ref_data TYPE ty_return_ref.
      DATA: lt_return_ref_data TYPE TABLE OF ty_return_ref.


      SELECT * FROM  /itetr/inv_retrn INTO TABLE lt_return_ref WHERE awtyp = 'RMRP' AND
                                                                     bukrs = ms_document-bukrs.
      SORT lt_return_ref BY bukrs DESCENDING.

      LOOP AT lt_return_ref INTO ls_return_ref.
        CONCATENATE 'LS_' ls_return_ref-return_tab_name INTO lv_strname.

        ASSIGN (lv_strname) TO <fs_str>.

        CASE ls_return_ref-return_tab_name .
          WHEN 'RBKP'.
            SELECT SINGLE * FROM rbkp INTO ls_rbkp WHERE belnr = iv_belnr AND "#EC CI_ALL_FIELDS_NEEDED
                                                         gjahr = iv_gjahr.
            ASSIGN (lv_strname) TO <fs_str>.
            ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
            IF <fs_val> IS ASSIGNED.
              ls_return_ref_data = <fs_val>.
              IF ls_return_ref_data IS NOT INITIAL.
                COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
              ENDIF.
            ENDIF.
          WHEN 'RSEG'.

            SELECT * FROM rseg INTO TABLE lt_rseg WHERE belnr = iv_belnr AND "#EC CI_ALL_FIELDS_NEEDED
                                                        gjahr = iv_gjahr.
            LOOP AT lt_rseg ASSIGNING <fs_str>.
              ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
              IF <fs_val> IS ASSIGNED.
                ls_return_ref_data = <fs_val>.
                IF ls_return_ref_data IS NOT INITIAL.
                  COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
                ENDIF.
              ENDIF.
            ENDLOOP.

          WHEN 'EKKO'.
            LOOP AT  rs_data-ekko ASSIGNING <fs_str>.
              ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
              IF <fs_val> IS ASSIGNED.
                ls_return_ref_data = <fs_val>.
                IF ls_return_ref_data IS NOT INITIAL.
                  COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
                ENDIF.
              ENDIF.
            ENDLOOP.

          WHEN 'EKPO'.

            LOOP AT  rs_data-ekpo ASSIGNING <fs_str>.
              ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
              IF <fs_val> IS ASSIGNED.
                ls_return_ref_data = <fs_val>.
                IF ls_return_ref_data IS NOT INITIAL.
                  COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
                ENDIF.
              ENDIF.
            ENDLOOP.
        ENDCASE.

        lv_date_format = ls_return_ref-date_format.
      ENDLOOP.

      LOOP AT lt_return_ref_data INTO ls_return_ref_data.

        READ TABLE lt_return_ref INTO ls_return_ref INDEX 1.
        IF ls_return_ref_data IS NOT INITIAL.
          lv_separator = ls_return_ref-seperator.
          CONDENSE ls_return_ref_data NO-GAPS.
          SPLIT ls_return_ref_data AT  lv_separator  INTO lv_value1
                                                          lv_value2
                                                          lv_value3
                                                          lv_value4.
          CONDENSE lv_value2 NO-GAPS.
          IF lv_value1 IS NOT INITIAL.
            ls_reft_tab-return_ref_no = lv_value1.
            CASE lv_date_format.
              WHEN 'DD.MM.YYYY' OR 'DD/MM/YYYY' OR 'DD-MM-YYYY'.
                CONCATENATE lv_value2+6(4) lv_value2+3(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'MM.DD.YYYY' OR 'MM/DD/YYYY' OR 'MM-DD-YYYY'.
                CONCATENATE lv_value2+6(4) lv_value2+3(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'YYYY/MM/DD' OR 'YYYY.MM.DD' OR 'YYYY-MM-DD'.
                CONCATENATE lv_value2+0(4) lv_value2+5(2) lv_value2+8(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'YYYYMMDD'.
                ls_reft_tab-return_ref_date = lv_value2.
              WHEN 'DDMMYYYY'.
                CONCATENATE lv_value2+4(4) lv_value2+2(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'MMDDYYYY'.
                CONCATENATE lv_value2+4(4) lv_value2+0(2) lv_value2+2(2)  INTO  ls_reft_tab-return_ref_date.
            ENDCASE.

            CONCATENATE ls_reft_tab-return_ref_date+0(4)
                        ls_reft_tab-return_ref_date+4(2)
                        ls_reft_tab-return_ref_date+6(2)
                   INTO ls_reft_tab-return_ref_date
                   SEPARATED BY '-'.
            COLLECT  ls_reft_tab  INTO rs_data-return_ref.
*            APPEND ls_reft_tab TO rs_data-return_ref.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD get_data_vbrk.
    DATA: lt_vbrk  TYPE STANDARD TABLE OF vbrkvb,
          lt_komv  TYPE STANDARD TABLE OF komv,
          lt_vbpa  TYPE STANDARD TABLE OF vbpavb,
          lt_vbrp  TYPE STANDARD TABLE OF vbrpvb,
          lt_t005  TYPE STANDARD TABLE OF t005,
          ls_vbpa  TYPE vbpavb,
          lv_parvw TYPE parvw,
          lt_parvw TYPE TABLE OF /itetr/inv_parvw,
          ls_parvw TYPE /itetr/inv_parvw.

    CALL FUNCTION '/ITETR/INV_READ_SD_INVOICE'
*      DESTINATION 'NONE'
      EXPORTING
        iv_vbeln = iv_vbeln
      TABLES
        xkomv    = lt_komv
        xvbpa    = lt_vbpa
        xvbrk    = lt_vbrk
        xvbrp    = lt_vbrp.
    CHECK lt_vbrk IS NOT INITIAL.
    READ TABLE lt_vbrk INTO rs_data-vbrk INDEX 1.
    CHECK sy-subrc = 0.

    MOVE-CORRESPONDING lt_komv TO rs_data-konv.
    MOVE-CORRESPONDING lt_vbpa TO rs_data-vbpa.
    MOVE-CORRESPONDING lt_vbrp TO rs_data-vbrp.

    SELECT SINGLE *
      FROM t001
      INTO rs_data-t001
      WHERE bukrs = rs_data-vbrk-bukrs.

    SELECT *
      FROM t005
      INTO TABLE lt_t005
      WHERE land1 = rs_data-t001-land1.

    SELECT *
      FROM mara
      INTO TABLE rs_data-mara
      FOR ALL ENTRIES IN rs_data-vbrp
      WHERE matnr = rs_data-vbrp-matnr.

    SELECT *
      FROM maw1
      INTO TABLE rs_data-maw1
      FOR ALL ENTRIES IN rs_data-vbrp
      WHERE matnr = rs_data-vbrp-matnr.
    IF sy-subrc IS INITIAL.
      SELECT *
        FROM t005
        APPENDING TABLE lt_t005
        FOR ALL ENTRIES IN rs_data-maw1
        WHERE land1 = rs_data-maw1-wherl.
    ENDIF.

    SELECT *
      FROM marc
      INTO TABLE rs_data-marc
      FOR ALL ENTRIES IN rs_data-vbrp
      WHERE matnr = rs_data-vbrp-matnr
        AND werks = rs_data-vbrp-werks.
    IF sy-subrc IS INITIAL.
      SELECT *
        FROM t005
        APPENDING TABLE lt_t005
        FOR ALL ENTRIES IN rs_data-marc
        WHERE land1 = rs_data-marc-herkl.
    ENDIF.

    SELECT *
      FROM lips
      INTO TABLE rs_data-lips
      FOR ALL ENTRIES IN rs_data-vbrp
      WHERE vbeln = rs_data-vbrp-vgbel
        AND posnr = rs_data-vbrp-vgpos.
    IF sy-subrc IS INITIAL.
      SELECT *
        FROM likp
        INTO TABLE rs_data-likp
        FOR ALL ENTRIES IN rs_data-lips
        WHERE vbeln = rs_data-lips-vbeln.          "#EC CI_NO_TRANSFORM
    ENDIF.

    SELECT *
      FROM vbap
      INTO TABLE rs_data-vbap
      FOR ALL ENTRIES IN rs_data-vbrp
      WHERE vbeln = rs_data-vbrp-aubel
        AND posnr = rs_data-vbrp-aupos.
    IF sy-subrc IS INITIAL.
      SELECT *
        FROM vbak
        INTO TABLE rs_data-vbak
        FOR ALL ENTRIES IN rs_data-vbap
        WHERE vbeln = rs_data-vbap-vbeln.          "#EC CI_NO_TRANSFORM

      IF sy-subrc IS INITIAL.
        SELECT *
          FROM vbkd
          INTO TABLE rs_data-vbkd
          FOR ALL ENTRIES IN rs_data-vbak
          WHERE vbeln = rs_data-vbak-vbeln.        "#EC CI_NO_TRANSFORM
      ENDIF.
    ENDIF.

    SELECT *
      FROM /itetr/inv_parvw
      INTO TABLE lt_parvw
      WHERE parvw NE space.
*    SORT lt_parvw DESCENDING.
    SORT lt_parvw BY party_type DESCENDING fkart DESCENDING  firstly DESCENDING xcpdk DESCENDING .

    IF rs_data-vbpa[] IS INITIAL.
      SELECT *
        FROM vbpa
        INTO TABLE rs_data-vbpa
        WHERE vbeln = iv_vbeln.
    ENDIF.


    IF lt_parvw[] IS INITIAL.
      READ TABLE rs_data-vbpa INTO ls_vbpa WITH TABLE KEY by_parvw COMPONENTS parvw = 'RE'.
      IF sy-subrc = 0.
        rs_data-address_number = ls_vbpa-adrnr.
        mo_invoice_operations->get_billing_onetime_tax(
          EXPORTING
            is_vbpa       = ls_vbpa
          IMPORTING
            ev_taxid      = rs_data-taxid
            ev_tax_office = rs_data-tax_office ).

        IF rs_data-taxid IS INITIAL.
          mo_invoice_operations->get_customer_taxid(
            EXPORTING
              iv_kunnr      = ls_vbpa-kunnr
            IMPORTING
              ev_taxid      = rs_data-taxid
              ev_tax_office = rs_data-tax_office ).
        ENDIF.
      ENDIF.
    ELSE.

      LOOP AT lt_parvw INTO ls_parvw WHERE  party_type = 'BUYER' OR party_type = space AND
                                            ( fkart = rs_data-vbrk-fkart OR fkart = space )
                                       AND   parvw NE space.
        READ TABLE rs_data-vbpa INTO ls_vbpa WITH TABLE KEY by_parvw COMPONENTS parvw = ls_parvw-parvw.

        IF sy-subrc = 0.

          IF ls_parvw-xcpdk IS NOT INITIAL.
            CHECK ls_parvw-xcpdk =  ls_vbpa-xcpdk.
          ENDIF.

          rs_data-address_number = ls_vbpa-adrnr.

          mo_invoice_operations->get_billing_onetime_tax(
            EXPORTING
              is_vbpa               = ls_vbpa
              iv_tax_id_fname       = ls_parvw-tax_id_fname
              iv_tax_office_fname   = ls_parvw-tax_office_fname
            IMPORTING
              ev_taxid      = rs_data-taxid
              ev_tax_office = rs_data-tax_office ).

          IF rs_data-taxid IS INITIAL AND ls_vbpa-xcpdk IS INITIAL.

            rs_data-address_number = ls_vbpa-adrnr.
            mo_invoice_operations->get_customer_taxid(
              EXPORTING
                iv_kunnr              = ls_vbpa-kunnr
                iv_tax_id_fname       = ls_parvw-tax_id_fname
                iv_tax_office_fname   = ls_parvw-tax_office_fname
              IMPORTING
                ev_taxid      = rs_data-taxid
                ev_tax_office = rs_data-tax_office ).

          ENDIF.

          IF rs_data-taxid IS NOT INITIAL.
            EXIT.
          ENDIF.

        ENDIF.

      ENDLOOP.

      LOOP AT lt_parvw INTO ls_parvw WHERE  party_type = 'DELIVERY'                      AND
                                    ( fkart      = rs_data-vbrk-fkart OR fkart = space ) AND
                                      parvw      NE space.
        READ TABLE rs_data-vbpa INTO ls_vbpa WITH TABLE KEY by_parvw COMPONENTS parvw = ls_parvw-parvw.
        IF sy-subrc = 0.
          mv_shipto_address = ls_vbpa-adrnr.
          EXIT.
        ENDIF.

      ENDLOOP.


      LOOP AT lt_parvw INTO ls_parvw WHERE  party_type = 'CARRIER' AND
                                          ( fkart      = rs_data-vbrk-fkart OR fkart = space ) AND
                                            parvw      NE space.
        READ TABLE rs_data-vbpa INTO ls_vbpa WITH TABLE KEY by_parvw COMPONENTS parvw = ls_parvw-parvw.
        IF sy-subrc IS INITIAL.

          DATA : iv_koart TYPE koart.
          DATA : lv_kunnr TYPE kna1-kunnr.

          IF ls_vbpa-kunnr IS NOT INITIAL.
            iv_koart = 'D'.
            lv_kunnr = ls_vbpa-kunnr.
          ELSEIF ls_vbpa-lifnr IS NOT INITIAL.
            iv_koart = 'K'.
            lv_kunnr = ls_vbpa-lifnr.
          ENDIF.

          mo_invoice_operations->get_customer_taxid(
            EXPORTING
              iv_kunnr              = lv_kunnr
              iv_koart              = iv_koart
              iv_tax_id_fname       = ls_parvw-tax_id_fname
              iv_tax_office_fname   = ls_parvw-tax_office_fname
            IMPORTING
              ev_taxid      = rs_data-carier_taxid
              ev_name       = rs_data-carier_name ).

          IF rs_data-carier_taxid IS NOT INITIAL.
            EXIT.
          ENDIF.
        ENDIF.

      ENDLOOP.



    ENDIF.



    IF rs_data-konv IS NOT INITIAL.
      SELECT *
        FROM t685t
        INTO TABLE rs_data-t685t
        FOR ALL ENTRIES IN rs_data-konv
        WHERE spras = sy-langu
          AND kvewe = 'A'
          AND kappl = 'V'
          AND kschl = rs_data-konv-kschl.
    ENDIF.

    SORT lt_t005 BY land1.
    DELETE ADJACENT DUPLICATES FROM lt_t005 COMPARING land1.
    rs_data-t005 = lt_t005.
    IF rs_data-t005 IS NOT INITIAL.
      SELECT *
        FROM t005t
        INTO TABLE rs_data-t005t
        FOR ALL ENTRIES IN rs_data-t005
        WHERE spras = sy-langu
          AND land1 = rs_data-t005-land1.
    ENDIF.

    DATA lv_tdname TYPE stxh-tdname.
    FIELD-SYMBOLS: <ls_texts> TYPE /itetr/cl_outgoing_invoice=>mty_texts.
    CONCATENATE iv_vbeln '%' INTO lv_tdname.
    SELECT tdobject tdname tdid tdspras
      FROM stxh
      INTO CORRESPONDING FIELDS OF TABLE rs_data-texts
      WHERE tdobject IN ('VBBK','VBBP')
        AND tdname LIKE lv_tdname.
    IF sy-subrc IS INITIAL.
      LOOP AT rs_data-texts ASSIGNING <ls_texts>.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = <ls_texts>-tdid
            language                = <ls_texts>-tdspras
            name                    = <ls_texts>-tdname
            object                  = <ls_texts>-tdobject
          TABLES
            lines                   = <ls_texts>-tline
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        CHECK sy-subrc IS NOT INITIAL.
        CLEAR <ls_texts>-tline.
      ENDLOOP.
    ENDIF.

    SELECT *
      INTO TABLE rs_data-conditions
      FROM /itetr/inv_cond.

    IF ms_document-invty = 'IADE'    OR ms_document-invty = 'TEVIADE'   OR
       ms_document-invty = 'YTBIADE' OR ms_document-invty = 'YTBTEVIADE'.

      DATA : lt_return_ref TYPE TABLE OF /itetr/inv_retrn,
             ls_return_ref TYPE /itetr/inv_retrn,
             ls_vbrk       TYPE vbrk,
             ls_vbrp       TYPE vbrp.
      DATA : lv_value1 TYPE char100.
      DATA : lv_value2 TYPE char100.
      DATA : lv_value3 TYPE char100.
      DATA : lv_value4 TYPE char100.
      DATA : lv_separator TYPE string.
      DATA : lv_date_format TYPE  /itetr/com_e_date_format.
      DATA : ls_reft_tab LIKE LINE OF rs_data-return_ref.
      FIELD-SYMBOLS: <fs_str> TYPE any.
      FIELD-SYMBOLS: <fs_val> TYPE any.

      DATA:lv_strname TYPE char30.

      TYPES: BEGIN OF ty_return_ref,
               value TYPE c LENGTH 150,
             END OF ty_return_ref.

      DATA: ls_return_ref_data TYPE ty_return_ref.
      DATA: lt_return_ref_data TYPE TABLE OF ty_return_ref.


      SELECT * FROM  /itetr/inv_retrn INTO TABLE lt_return_ref WHERE awtyp = 'VBRK' AND
                                                                     bukrs = ms_document-bukrs.
      SORT lt_return_ref BY bukrs DESCENDING.

      ls_vbrk = rs_data-vbrk.
      ASSIGN (lv_strname) TO <fs_str>.

      LOOP AT lt_return_ref INTO ls_return_ref.

        CONCATENATE 'LS_' ls_return_ref-return_tab_name INTO lv_strname.

        CASE ls_return_ref-return_tab_name .
          WHEN 'VBRK'.

            ASSIGN (lv_strname) TO <fs_str>.
            ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
            IF <fs_val> IS ASSIGNED.
              ls_return_ref_data = <fs_val>.
              IF ls_return_ref_data IS NOT INITIAL.
                COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
              ENDIF.
            ENDIF.

          WHEN 'VBRP'.

            LOOP AT rs_data-vbrp ASSIGNING <fs_str>.
              ASSIGN COMPONENT ls_return_ref-field_name OF STRUCTURE <fs_str>  TO <fs_val>.
              IF <fs_val> IS ASSIGNED.
                ls_return_ref_data = <fs_val>.
                IF ls_return_ref_data IS NOT INITIAL.
                  COLLECT  ls_return_ref_data  INTO lt_return_ref_data.
                ENDIF.
              ENDIF.
            ENDLOOP.

        ENDCASE.
        lv_date_format = ls_return_ref-date_format.
      ENDLOOP.

      LOOP AT lt_return_ref_data INTO ls_return_ref_data.

        READ TABLE lt_return_ref INTO ls_return_ref INDEX 1.
        IF ls_return_ref_data IS NOT INITIAL.
          lv_separator = ls_return_ref-seperator.
          CONDENSE ls_return_ref_data NO-GAPS.
          SPLIT ls_return_ref_data AT lv_separator  INTO lv_value1
                                                         lv_value2
                                                         lv_value3
                                                         lv_value4.
          CONDENSE lv_value2 NO-GAPS.
          IF lv_value1 IS NOT INITIAL.
            ls_reft_tab-return_ref_no = lv_value1.
            CASE lv_date_format.
              WHEN 'DD.MM.YYYY' OR 'DD/MM/YYYY' OR 'DD-MM-YYYY'.
                CONCATENATE lv_value2+6(4) lv_value2+3(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'MM.DD.YYYY' OR 'MM/DD/YYYY' OR 'MM-DD-YYYY'.
                CONCATENATE lv_value2+6(4) lv_value2+3(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'YYYY/MM/DD' OR 'YYYY.MM.DD' OR 'YYYY-MM-DD'.
                CONCATENATE lv_value2+0(4) lv_value2+5(2) lv_value2+8(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'YYYYMMDD'.
                ls_reft_tab-return_ref_date = lv_value2.
              WHEN 'DDMMYYYY'.
                CONCATENATE lv_value2+4(4) lv_value2+2(2) lv_value2+0(2)  INTO  ls_reft_tab-return_ref_date.
              WHEN 'MMDDYYYY'.
                CONCATENATE lv_value2+4(4) lv_value2+0(2) lv_value2+2(2)  INTO  ls_reft_tab-return_ref_date.
            ENDCASE.
            CONCATENATE ls_reft_tab-return_ref_date+0(4)
                        ls_reft_tab-return_ref_date+4(2)
                        ls_reft_tab-return_ref_date+6(2)
               INTO     ls_reft_tab-return_ref_date
               SEPARATED BY '-'.
            COLLECT  ls_reft_tab  INTO rs_data-return_ref.
*            APPEND ls_reft_tab TO rs_data-return_ref.
          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD get_earchive_barcode.

    DATA: lv_ubl_string          TYPE string,
          ls_splr_partyident     TYPE /itetr/com_party_identificati1,
          ls_splr_partyident_tmp TYPE /itetr/com_party_identificati1,
          ls_cust_partyident     TYPE /itetr/com_party_identificati1,
          ls_cust_partyident_tmp TYPE /itetr/com_party_identificati1,
          ls_tax_total           TYPE /itetr/com_tax_total,
          ls_tax_subtotal        TYPE /itetr/com_tax_subtotal.

    LOOP AT ms_invoice_ubl-part1-accounting_supplier_party-party-party_identification INTO ls_splr_partyident WHERE id-base-base-scheme_id EQ 'TCKN'
                                                                                                                     OR id-base-base-scheme_id EQ 'VKN'.
      ls_splr_partyident_tmp = ls_splr_partyident.
    ENDLOOP.
    LOOP AT ms_invoice_ubl-part1-accounting_customer_party-party-party_identification INTO ls_cust_partyident WHERE id-base-base-scheme_id EQ 'TCKN'
                                                                                                                 OR id-base-base-scheme_id EQ 'VKN'.
      ls_cust_partyident_tmp = ls_cust_partyident.
    ENDLOOP.

    CONCATENATE
    '{"vkntckn":"'        ls_splr_partyident_tmp-id-base-base-content                                  '",'
    '"avkntckn":"'        ls_cust_partyident_tmp-id-base-base-content                                  '",'
    '"senaryo":"'         ms_invoice_ubl-part1-profile_id-base-base-content                            '",'
    '"tip":"'             ms_invoice_ubl-part1-invoice_type_code-base-base-content                     '",'
    '"tarih":"'           ms_invoice_ubl-part1-issue_date-base-content                                 '",'
    '"no":"'              ms_invoice_ubl-part1-id-base-base-content                                    '",'
    '"ettn":"'            ms_invoice_ubl-part1-uuid-base-base-content                                  '",'
    '"parabirimi":"'      ms_invoice_ubl-part1-document_currency_code-base-base-content                '",'
    '"malhizmettoplam":"' ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content '",'
    INTO lv_ubl_string.
    LOOP AT ms_invoice_ubl-part1-tax_total INTO ls_tax_total.
      LOOP AT ls_tax_total-tax_subtotal INTO ls_tax_subtotal.
        CONCATENATE
        lv_ubl_string
        '"kdvmatrah('     ls_tax_subtotal-percent-base-base-content ')":"' ls_tax_subtotal-taxable_amount-base-content '",'
        INTO lv_ubl_string.
      ENDLOOP.
      CONCATENATE
      lv_ubl_string
      '"hesaplanankdv (' ls_tax_subtotal-percent-base-base-content ')":"' ls_tax_total-tax_amount-base-content '",'
      INTO lv_ubl_string.
    ENDLOOP.
    CONCATENATE
    lv_ubl_string
    '"vergidahil":"' ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content '",'
    '"odenecek":"'   ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content       '"}'
    INTO lv_ubl_string.

**    CALL FUNCTION '/ITETR/COM_BARCODE'
**      EXPORTING
**        i_string = lv_ubl_string
**      IMPORTING
**        e_base64 = iv_barcode.


    DATA: lv_int TYPE i.
    DO 3 TIMES.
      CALL FUNCTION '/ITETR/COM_BARCODE'
        EXPORTING
          i_string = lv_ubl_string
        IMPORTING
          e_base64 = iv_barcode.

      lv_int = strlen( iv_barcode ).
      IF lv_int LE 500.
        WAIT UP TO 1 SECONDS.
      ELSE.

        EXIT.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD get_earchive_rule.
    DATA: lt_agent       TYPE RANGE OF /itetr/com_e_agent,
          lt_awtyp       TYPE RANGE OF awtyp,
          lt_vkorg       TYPE RANGE OF vkorg,
          lt_vtweg       TYPE RANGE OF vtweg,
          lt_werks       TYPE RANGE OF werks_d,
          lt_invty       TYPE RANGE OF /itetr/inv_e_invty,
          lt_sddty       TYPE RANGE OF fkart,
          lt_mmdty       TYPE RANGE OF blart,
          lt_fidty       TYPE RANGE OF blart,
          lt_kunnr       TYPE RANGE OF kunnr,
          lt_lifnr       TYPE RANGE OF lifnr,
          lt_pstyv       TYPE RANGE OF pstyv,
          lt_ktgrd       TYPE RANGE OF ktgrd,
          lt_kalks       TYPE RANGE OF kalks,
          lt_kalsm       TYPE RANGE OF kalsmasd,
          ls_range       TYPE rsis_s_range,
          lt_rule        TYPE  TABLE OF /itetr/inv_earu,
          ls_rule        TYPE /itetr/inv_earu,
          rs_rule_output TYPE /itetr/inv_s_earules_out.

    ls_range-sign = 'I'.
    ls_range-option = 'EQ'.

    ls_range-low = ''.
    APPEND ls_range TO lt_agent.
    ls_range-low = is_rule_input-agent.
    APPEND ls_range TO lt_agent.

    ls_range-low = ''.
    APPEND ls_range TO lt_awtyp.
    ls_range-low = is_rule_input-awtyp.
    APPEND ls_range TO lt_awtyp.

    ls_range-low = ''.
    APPEND ls_range TO lt_vkorg.
    ls_range-low = is_rule_input-vkorg.
    APPEND ls_range TO lt_vkorg.

    ls_range-low = ''.
    APPEND ls_range TO lt_vtweg.
    ls_range-low = is_rule_input-vtweg.
    APPEND ls_range TO lt_vtweg.

    ls_range-low = ''.
    APPEND ls_range TO lt_werks.
    ls_range-low = is_rule_input-werks.
    APPEND ls_range TO lt_werks.

    ls_range-low = ''.
    APPEND ls_range TO lt_invty.
    ls_range-low = is_rule_input-ityin.
    APPEND ls_range TO lt_invty.

    ls_range-low = ''.
    APPEND ls_range TO lt_sddty.
    ls_range-low = is_rule_input-sddty.
    APPEND ls_range TO lt_sddty.

    ls_range-low = ''.
    APPEND ls_range TO lt_mmdty.
    ls_range-low = is_rule_input-mmdty.
    APPEND ls_range TO lt_mmdty.

    ls_range-low = ''.
    APPEND ls_range TO lt_fidty.
    ls_range-low = is_rule_input-fidty.
    APPEND ls_range TO lt_fidty.

    ls_range-low = ''.
    APPEND ls_range TO lt_kunnr.
    ls_range-low = is_rule_input-kunnr.
    APPEND ls_range TO lt_kunnr.

    ls_range-low = ''.
    APPEND ls_range TO lt_lifnr.
    ls_range-low = is_rule_input-lifnr.
    APPEND ls_range TO lt_lifnr.

    ls_range-low = ''.
    APPEND ls_range TO lt_pstyv.
    ls_range-low = is_rule_input-pstyv.
    APPEND ls_range TO lt_pstyv.

    ls_range-low = ''.
    APPEND ls_range TO lt_ktgrd.
    ls_range-low = is_rule_input-ktgrd.
    APPEND ls_range TO lt_ktgrd.

    ls_range-low = ''.
    APPEND ls_range TO lt_kalks.
    ls_range-low = is_rule_input-kalks.
    APPEND ls_range TO lt_kalks.

    ls_range-low = ''.
    APPEND ls_range TO lt_kalsm.
    ls_range-low = is_rule_input-kalsm.
    APPEND ls_range TO lt_kalsm.

    SORT: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_pstyv, lt_ktgrd, lt_kalks, lt_kalsm.
    DELETE ADJACENT DUPLICATES FROM: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_pstyv, lt_ktgrd, lt_kalks, lt_kalsm.

    SELECT *
      FROM /itetr/inv_earu
      INTO TABLE lt_rule
      WHERE bukrs EQ ms_document-bukrs
        AND rulet EQ iv_rule_type
        AND agent IN lt_agent
        AND awtyp IN lt_awtyp
        AND vkorg IN lt_vkorg
        AND vtweg IN lt_vtweg
        AND werks IN lt_werks
        AND ityin IN lt_invty
        AND sddty IN lt_sddty
        AND mmdty IN lt_mmdty
        AND fidty IN lt_fidty
        AND kunnr IN lt_kunnr
        AND lifnr IN lt_lifnr
        AND pstyv IN lt_pstyv
        AND ktgrd IN lt_ktgrd
        AND kalks IN lt_kalks
        AND kalsm IN lt_kalsm
      ORDER BY  rulen ASCENDING.

    LOOP AT lt_rule INTO ls_rule.
      IF ls_rule-agent IS NOT INITIAL.
        CHECK ls_rule-agent = is_rule_input-agent.
      ENDIF.
      IF ls_rule-awtyp IS NOT INITIAL.
        CHECK ls_rule-awtyp = is_rule_input-awtyp.
      ENDIF.
      IF ls_rule-vkorg IS NOT INITIAL.
        CHECK ls_rule-vkorg = is_rule_input-vkorg.
      ENDIF.
      IF ls_rule-vtweg IS NOT INITIAL.
        CHECK ls_rule-vtweg = is_rule_input-vtweg.
      ENDIF.
      IF ls_rule-werks IS NOT INITIAL.
        CHECK ls_rule-werks = is_rule_input-werks.
      ENDIF.
      IF ls_rule-ityin IS NOT INITIAL.
        CHECK ls_rule-ityin = is_rule_input-ityin.
      ENDIF.
      IF ls_rule-sddty IS NOT INITIAL.
        CHECK ls_rule-sddty = is_rule_input-sddty.
      ENDIF.
      IF ls_rule-mmdty IS NOT INITIAL.
        CHECK ls_rule-mmdty = is_rule_input-mmdty.
      ENDIF.
      IF ls_rule-fidty IS NOT INITIAL.
        CHECK ls_rule-fidty = is_rule_input-fidty.
      ENDIF.
      IF ls_rule-kunnr IS NOT INITIAL.
        CHECK ls_rule-kunnr = is_rule_input-kunnr.
      ENDIF.
      IF ls_rule-lifnr IS NOT INITIAL.
        CHECK ls_rule-lifnr = is_rule_input-lifnr.
      ENDIF.
      IF ls_rule-pstyv IS NOT INITIAL.
        CHECK ls_rule-pstyv = is_rule_input-pstyv.
      ENDIF.
      IF ls_rule-ktgrd IS NOT INITIAL.
        CHECK ls_rule-ktgrd = is_rule_input-ktgrd.
      ENDIF.
      IF ls_rule-kalsm IS NOT INITIAL.
        CHECK ls_rule-kalsm = is_rule_input-kalsm.
      ENDIF.
      IF ls_rule-kalks IS NOT INITIAL.
        CHECK ls_rule-kalks = is_rule_input-kalks.
      ENDIF.
      MOVE-CORRESPONDING ls_rule TO rs_rule_output.
      APPEND rs_rule_output TO rt_rule_output.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_einvoice_barcode.

    DATA: lv_ubl_string          TYPE string,
          ls_splr_partyident     TYPE /itetr/com_party_identificati1,
          ls_splr_partyident_tmp TYPE /itetr/com_party_identificati1,
          ls_cust_partyident     TYPE /itetr/com_party_identificati1,
          ls_cust_partyident_tmp TYPE /itetr/com_party_identificati1,
          ls_tax_total           TYPE /itetr/com_tax_total,
          ls_tax_subtotal        TYPE /itetr/com_tax_subtotal.

    LOOP AT ms_invoice_ubl-part1-accounting_supplier_party-party-party_identification INTO ls_splr_partyident WHERE id-base-base-scheme_id EQ 'TCKN'
                                                                                                                 OR id-base-base-scheme_id EQ 'VKN'.
      ls_splr_partyident_tmp = ls_splr_partyident.
    ENDLOOP.
    LOOP AT ms_invoice_ubl-part1-accounting_customer_party-party-party_identification INTO ls_cust_partyident WHERE id-base-base-scheme_id EQ 'TCKN'
                                                                                                                 OR id-base-base-scheme_id EQ 'VKN'.
      ls_cust_partyident_tmp = ls_cust_partyident.
    ENDLOOP.

    CONCATENATE
    '{"vkntckn":"'        ls_splr_partyident_tmp-id-base-base-content                                  '",'
    '"avkntckn":"'        ls_cust_partyident_tmp-id-base-base-content                                  '",'
    '"senaryo":"'          ms_invoice_ubl-part1-profile_id-base-base-content                            '",'
    '"tip":"'             ms_invoice_ubl-part1-invoice_type_code-base-base-content                     '",'
    '"tarih":"'           ms_invoice_ubl-part1-issue_date-base-content                                 '",'
    '"no":"'              ms_invoice_ubl-part1-id-base-base-content                                    '",'
    '"ettn":"'            ms_invoice_ubl-part1-uuid-base-base-content                                  '",'
    '"parabirimi":"'      ms_invoice_ubl-part1-document_currency_code-base-base-content                '",'
    '"malhizmettoplam":"' ms_invoice_ubl-part1-legal_monetary_total-line_extension_amount-base-content '",'
    INTO lv_ubl_string.
    LOOP AT ms_invoice_ubl-part1-tax_total INTO ls_tax_total.
      LOOP AT ls_tax_total-tax_subtotal INTO ls_tax_subtotal.
        CONCATENATE
        lv_ubl_string
        '"kdvmatrah('     ls_tax_subtotal-percent-base-base-content ')":"' ls_tax_subtotal-taxable_amount-base-content '",'
        '"hesaplanankdv(' ls_tax_subtotal-percent-base-base-content ')":"' ls_tax_subtotal-tax_amount-base-content     '",'
        INTO lv_ubl_string.
      ENDLOOP.
    ENDLOOP.
    CONCATENATE
    lv_ubl_string
    '"vergidahil":"'      ms_invoice_ubl-part1-legal_monetary_total-tax_inclusive_amount-base-content  '",'
    '"odenecek":"'        ms_invoice_ubl-part1-legal_monetary_total-payable_amount-base-content        '"}'
    INTO lv_ubl_string.


    DATA: lv_int TYPE i.
    DO 3 TIMES.
      CALL FUNCTION '/ITETR/COM_BARCODE'
        EXPORTING
          i_string = lv_ubl_string
        IMPORTING
          e_base64 = iv_barcode.

      lv_int = strlen( iv_barcode ).
      IF lv_int LE 500.
        WAIT UP TO 1 SECONDS.
      ELSE.

        EXIT.
      ENDIF.
    ENDDO.


  ENDMETHOD.


  METHOD get_einvoice_rule.
    DATA: lt_agent       TYPE RANGE OF /itetr/com_e_agent,
          lt_awtyp       TYPE RANGE OF awtyp,
          lt_vkorg       TYPE RANGE OF vkorg,
          lt_vtweg       TYPE RANGE OF vtweg,
          lt_werks       TYPE RANGE OF werks_d,
          lt_invty       TYPE RANGE OF /itetr/inv_e_invty,
          lt_sddty       TYPE RANGE OF fkart,
          lt_mmdty       TYPE RANGE OF blart,
          lt_fidty       TYPE RANGE OF blart,
          lt_kunnr       TYPE RANGE OF kunnr,
          lt_lifnr       TYPE RANGE OF lifnr,
          lt_pstyv       TYPE RANGE OF pstyv,
          lt_ktgrd       TYPE RANGE OF ktgrd,
          lt_kalks       TYPE RANGE OF kalks,
          lt_kalsm       TYPE RANGE OF kalsmasd,
          lt_prfid       TYPE RANGE OF /itetr/inv_e_prfid,
          ls_range       TYPE rsis_s_range,
          lt_rule        TYPE TABLE OF /itetr/inv_eiru,
          ls_rule        TYPE /itetr/inv_eiru,
          rs_rule_output TYPE /itetr/inv_s_eirules_out.

    ls_range-sign = 'I'.
    ls_range-option = 'EQ'.

    ls_range-low = ''.
    APPEND ls_range TO lt_agent.
    ls_range-low = is_rule_input-agent.
    APPEND ls_range TO lt_agent.

    ls_range-low = ''.
    APPEND ls_range TO lt_awtyp.
    ls_range-low = is_rule_input-awtyp.
    APPEND ls_range TO lt_awtyp.

    ls_range-low = ''.
    APPEND ls_range TO lt_vkorg.
    ls_range-low = is_rule_input-vkorg.
    APPEND ls_range TO lt_vkorg.

    ls_range-low = ''.
    APPEND ls_range TO lt_vtweg.
    ls_range-low = is_rule_input-vtweg.
    APPEND ls_range TO lt_vtweg.

    ls_range-low = ''.
    APPEND ls_range TO lt_werks.
    ls_range-low = is_rule_input-werks.
    APPEND ls_range TO lt_werks.

    ls_range-low = ''.
    APPEND ls_range TO lt_invty.
    ls_range-low = is_rule_input-ityin.
    APPEND ls_range TO lt_invty.

    ls_range-low = ''.
    APPEND ls_range TO lt_sddty.
    ls_range-low = is_rule_input-sddty.
    APPEND ls_range TO lt_sddty.

    ls_range-low = ''.
    APPEND ls_range TO lt_mmdty.
    ls_range-low = is_rule_input-mmdty.
    APPEND ls_range TO lt_mmdty.

    ls_range-low = ''.
    APPEND ls_range TO lt_fidty.
    ls_range-low = is_rule_input-fidty.
    APPEND ls_range TO lt_fidty.

    ls_range-low = ''.
    APPEND ls_range TO lt_prfid.
    ls_range-low = is_rule_input-pidin.
    APPEND ls_range TO lt_prfid.

    ls_range-low = ''.
    APPEND ls_range TO lt_kunnr.
    ls_range-low = is_rule_input-kunnr.
    APPEND ls_range TO lt_kunnr.

    ls_range-low = ''.
    APPEND ls_range TO lt_lifnr.
    ls_range-low = is_rule_input-lifnr.
    APPEND ls_range TO lt_lifnr.

    ls_range-low = ''.
    APPEND ls_range TO lt_ktgrd.
    ls_range-low = is_rule_input-ktgrd.
    APPEND ls_range TO lt_ktgrd.

    ls_range-low = ''.
    APPEND ls_range TO lt_kalks.
    ls_range-low = is_rule_input-kalks.
    APPEND ls_range TO lt_kalks.

    ls_range-low = ''.
    APPEND ls_range TO lt_kalsm.
    ls_range-low = is_rule_input-kalsm.
    APPEND ls_range TO lt_kalsm.

    ls_range-low = ''.
    APPEND ls_range TO lt_pstyv.
    ls_range-low = is_rule_input-pstyv.
    APPEND ls_range TO lt_pstyv.

    SORT: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_prfid, lt_pstyv, lt_ktgrd, lt_kalks, lt_kalsm.
    DELETE ADJACENT DUPLICATES FROM: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_prfid, lt_pstyv, lt_ktgrd, lt_kalks, lt_kalsm.

    SELECT *
      FROM /itetr/inv_eiru
      INTO TABLE lt_rule
      WHERE bukrs EQ ms_document-bukrs
        AND rulet EQ iv_rule_type
        AND agent IN lt_agent
        AND awtyp IN lt_awtyp
        AND vkorg IN lt_vkorg
        AND vtweg IN lt_vtweg
        AND werks IN lt_werks
        AND ityin IN lt_invty
        AND sddty IN lt_sddty
        AND mmdty IN lt_mmdty
        AND fidty IN lt_fidty
        AND pidin IN lt_prfid
        AND kunnr IN lt_kunnr
        AND lifnr IN lt_lifnr
        AND pstyv IN lt_pstyv
        AND ktgrd IN lt_ktgrd
        AND kalks IN lt_kalks
        AND kalsm IN lt_kalsm
      ORDER BY  rulen   ASCENDING.

    LOOP AT lt_rule INTO ls_rule.
      IF ls_rule-agent IS NOT INITIAL.
        CHECK ls_rule-agent = is_rule_input-agent.
      ENDIF.
      IF ls_rule-awtyp IS NOT INITIAL.
        CHECK ls_rule-awtyp = is_rule_input-awtyp.
      ENDIF.
      IF ls_rule-vkorg IS NOT INITIAL.
        CHECK ls_rule-vkorg = is_rule_input-vkorg.
      ENDIF.
      IF ls_rule-vtweg IS NOT INITIAL.
        CHECK ls_rule-vtweg = is_rule_input-vtweg.
      ENDIF.
      IF ls_rule-werks IS NOT INITIAL.
        CHECK ls_rule-werks = is_rule_input-werks.
      ENDIF.
      IF ls_rule-pidin IS NOT INITIAL.
        CHECK ls_rule-pidin = is_rule_input-pidin.
      ENDIF.
      IF ls_rule-ityin IS NOT INITIAL.
        CHECK ls_rule-ityin = is_rule_input-ityin.
      ENDIF.
      IF ls_rule-sddty IS NOT INITIAL.
        CHECK ls_rule-sddty = is_rule_input-sddty.
      ENDIF.
      IF ls_rule-mmdty IS NOT INITIAL.
        CHECK ls_rule-mmdty = is_rule_input-mmdty.
      ENDIF.
      IF ls_rule-fidty IS NOT INITIAL.
        CHECK ls_rule-fidty = is_rule_input-fidty.
      ENDIF.
      IF ls_rule-kunnr IS NOT INITIAL.
        CHECK ls_rule-kunnr = is_rule_input-kunnr.
      ENDIF.
      IF ls_rule-lifnr IS NOT INITIAL.
        CHECK ls_rule-lifnr = is_rule_input-lifnr.
      ENDIF.
      IF ls_rule-pstyv IS NOT INITIAL.
        CHECK ls_rule-pstyv = is_rule_input-pstyv.
      ENDIF.
      IF ls_rule-ktgrd IS NOT INITIAL.
        CHECK ls_rule-ktgrd = is_rule_input-ktgrd.
      ENDIF.
      IF ls_rule-kalsm IS NOT INITIAL.
        CHECK ls_rule-kalsm = is_rule_input-kalsm.
      ENDIF.
      IF ls_rule-kalks IS NOT INITIAL.
        CHECK ls_rule-kalks = is_rule_input-kalks.
      ENDIF.
      MOVE-CORRESPONDING ls_rule TO rs_rule_output.
      APPEND rs_rule_output TO rt_rule_output.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_tax_match.
    SELECT SINGLE *
      FROM /itetr/inv_taxm
      INTO rs_tax_match
      WHERE kalsm = iv_kalsm
        AND mwskz = iv_mwskz.
  ENDMETHOD.


  METHOD invoice_abap_to_ubl.
    DATA: lx_etr_exception        TYPE REF TO /itetr/cx_regulative_exception,
          lx_transformation_error TYPE REF TO cx_root,
          lt_binary               TYPE solix_tab,
          lv_length               TYPE i,
          lv_invoice              TYPE string,
          lv_submatch             TYPE string.
    TRY.
        mv_invoice_ubl = cl_proxy_xml_transform=>abap_to_xml_xstring(
          EXPORTING
            abap_data               = ms_invoice_ubl
            ddic_type               = '/ITETR/COM_MESSAGE1'
            xml_header              = 'full'
        ).
      CATCH cx_proxy_fault cx_transformation_error INTO lx_transformation_error.
        lx_etr_exception = /itetr/cx_regulative_exception=>create_by_exception( lx_transformation_error ).
        RAISE EXCEPTION lx_etr_exception.
    ENDTRY.

    CALL FUNCTION 'CRM_IC_XML_XSTRING2STRING'
      EXPORTING
        inxstring = mv_invoice_ubl
      IMPORTING
        outstring = lv_invoice.
    REPLACE REGEX 'Invoice xmlns' IN lv_invoice WITH 'Invoice xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-2.1.xsd" xmlns'.
    REPLACE REGEX '<n\w:HeadOfficeParty/>' IN lv_invoice WITH ``.
    REPLACE REGEX '<n\w:UBLExtensions/>' IN lv_invoice WITH ``.

    REPLACE ALL OCCURRENCES OF REGEX '\<n0:Invoice' IN lv_invoice WITH 'Invoice'.
    REPLACE ALL OCCURRENCES OF REGEX '<n1:' IN lv_invoice WITH '<cac:'.
    REPLACE ALL OCCURRENCES OF REGEX '</n1:' IN lv_invoice WITH '</cac:'.
    REPLACE ALL OCCURRENCES OF REGEX '<n2:' IN lv_invoice WITH '<cbc:'.
    REPLACE ALL OCCURRENCES OF REGEX '</n2:' IN lv_invoice WITH '</cbc:'.
    REPLACE ALL OCCURRENCES OF REGEX '<n3:' IN lv_invoice WITH '<ext:'.
    REPLACE ALL OCCURRENCES OF REGEX '</n3:' IN lv_invoice WITH '</ext:'.

    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n3="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'
    IN lv_invoice WITH 'xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'.

    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n2="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'
    IN lv_invoice WITH 'xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'.

    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n1="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'
    IN lv_invoice WITH 'xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'.

    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n0="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"'
    IN lv_invoice WITH 'xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"'.

    "müstahil için credit note
    IF ms_invoice_ubl-part1-profile_id-base-base-content = 'EARSIVBELGE' AND ms_invoice_ubl-part1-invoice_type_code-base-base-content = 'MUSTAHSILMAKBUZ'.
      REPLACE ALL OCCURRENCES OF REGEX '<Invoice' IN lv_invoice WITH '<CreditNote'.
      REPLACE ALL OCCURRENCES OF REGEX 'xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-2.1.xsd"' IN lv_invoice
      WITH 'xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2 ..\xsdrt\maindoc\UBL-CreditNote-2.1.xsd"'.
      REPLACE ALL OCCURRENCES OF REGEX 'xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"' IN lv_invoice
      WITH 'xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"'.
      REPLACE ALL OCCURRENCES OF REGEX '<cbc:InvoiceTypeCode>' IN lv_invoice WITH '<cbc:CreditNoteTypeCode>'.
      REPLACE ALL OCCURRENCES OF REGEX '</cbc:InvoiceTypeCode>' IN lv_invoice WITH '</cbc:CreditNoteTypeCode>'.
      REPLACE ALL OCCURRENCES OF REGEX '<cac:InvoiceLine>' IN lv_invoice WITH '<cac:CreditNoteLine>'.
      REPLACE ALL OCCURRENCES OF REGEX '</cac:InvoiceLine>' IN lv_invoice WITH '</cac:CreditNoteLine>'.
      REPLACE ALL OCCURRENCES OF REGEX '<cbc:InvoicedQuantity' IN lv_invoice WITH '<cbc:CreditedQuantity'.
      REPLACE ALL OCCURRENCES OF REGEX '</cbc:InvoicedQuantity>' IN lv_invoice WITH '</cbc:CreditedQuantity>'.
      REPLACE ALL OCCURRENCES OF REGEX '</Invoice>' IN lv_invoice WITH '</CreditNote>'.
    ENDIF.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = lv_invoice
      IMPORTING
        buffer = mv_invoice_ubl
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc IS INITIAL.
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = mv_invoice_ubl
        IMPORTING
          output_length = lv_length
        TABLES
          binary_tab    = lt_binary.
      IF lt_binary IS NOT INITIAL.
        CALL FUNCTION 'MD5_CALCULATE_HASH_FOR_RAW'
          EXPORTING
            length         = lv_length
          IMPORTING
            hash           = mv_invoice_hash
          TABLES
            data_tab       = lt_binary
          EXCEPTIONS
            internal_error = 1
            OTHERS         = 2.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD raise_custom_error.
    "[MAI | 2026-08-20] Schematron kural kontrolleri icin serbest metinli hata mesaji.
    "Mesaj sinifi /ITETR/REGULATIVE, numara 000 metni '&1 &2 &3 &4' seklindedir; bu nedenle
    "yeni bir SE91 mesaj numarasi olusturmadan serbest metin 4x50 karakterlik parcalara
    "bolunerek iletilir (bkz. /itetr/cx_regulative_exception=>create_by_exception ile ayni yontem).
    DATA: lx_exception TYPE REF TO /itetr/cx_regulative_exception,
          ls_return     TYPE bapiret2,
          lv_text       TYPE bapi_msg.

    lv_text = iv_text.
    ls_return-id = '/ITETR/REGULATIVE'.
    ls_return-type = 'E'.
    ls_return-number = '000'.
    ls_return-message_v1 = lv_text(50).
    ls_return-message_v2 = lv_text+50(50).
    ls_return-message_v3 = lv_text+100(50).
    ls_return-message_v4 = lv_text+150(50).

    lx_exception = /itetr/cx_regulative_exception=>create_by_bapiret2( ls_return ).
    RAISE EXCEPTION lx_exception.
  ENDMETHOD.


  METHOD send_inv_to_tra.
    TYPES BEGIN OF ty_documents.
    TYPES awtyp TYPE bkpf-awtyp.
    TYPES belnr TYPE bkpf-belnr.
    TYPES bldat TYPE bkpf-bldat.
    TYPES gjahr TYPE bkpf-gjahr.
    TYPES END OF ty_documents.

    DATA : ls_vbrk     TYPE vbrk,
           lt_vbrk     TYPE TABLE OF vbrk,
           ls_mkpf     TYPE mkpf,
           lt_mkpf     TYPE TABLE OF mkpf,
           ls_bkpf     TYPE bkpf,
           lt_bkpf     TYPE TABLE OF bkpf,
*           lt_manu     TYPE TABLE OF /itetr/dlv_ogdlv,
*           ls_manu     TYPE /itetr/dlv_ogdlv,
           ls_return_t TYPE bapiret2.
    DATA: ls_sendable_invoice TYPE /itetr/com_s_document_id.

    DATA  : ls_inv_oginv_1  TYPE  /itetr/inv_oginv.
    DATA  : ls_inv_oginv  TYPE  /itetr/inv_oginv.
    DATA  : ls_return     TYPE  bapiret2.
    DATA  : lt_return     TYPE bapiret2_tab.
    DATA  : lv_subrc      TYPE sy-subrc.
    DATA  : lr_stacd      TYPE RANGE OF  /itetr/inv_oginv-stacd.
    DATA  : ls_stacd      LIKE LINE OF lr_stacd.
    DATA  : ls_document   TYPE  ty_documents.
    DATA  : lt_documents   TYPE TABLE OF ty_documents.
    DATA  : lv_tabix TYPE sy-tabix,
            lv_belnr TYPE bkpf-belnr.
    DATA  : lt_doc_t TYPE /itetr/com_tt_document_id,
            ls_doc_t TYPE /itetr/com_s_document_id.
    DATA : lv_in_update_task TYPE sy-subrc.

*    DATA : lv_merge_id TYPE /itetr/com_e_mrgid.
*
*    lv_merge_id = iv_merge_id.
    CASE iv_module.
      WHEN 'SD'.
        MOVE-CORRESPONDING it_data[] TO lt_vbrk[].
*        lt_likp[] = it_data[].
        CLEAR lv_tabix.
        LOOP AT lt_vbrk INTO ls_vbrk.
          lv_tabix = sy-tabix.


          ls_document-awtyp = 'VBRK'.
          ls_document-belnr = ls_vbrk-vbeln.
          ls_document-gjahr = ls_vbrk-fkdat(4).

          IF ls_document-gjahr IS INITIAL.
            ls_document-gjahr = sy-datum(4).
          ENDIF.

          APPEND ls_document TO lt_documents.
        ENDLOOP.

      WHEN 'MM'.
        MOVE-CORRESPONDING it_data[] TO lt_mkpf[].
*        lt_mkpf[] = it_data[].
        CLEAR lv_tabix.

        LOOP AT lt_mkpf INTO ls_mkpf.


          ls_document-awtyp = 'MKPF'.
          ls_document-belnr = ls_mkpf-mblnr.
          ls_document-gjahr = ls_mkpf-mjahr.

          IF ls_document-gjahr IS INITIAL.
            ls_document-gjahr = sy-datum(4).
          ENDIF.

          APPEND ls_document TO lt_documents.
        ENDLOOP.

      WHEN 'FI'.
        MOVE-CORRESPONDING it_data[] TO lt_bkpf[].
        CLEAR lv_tabix.
        LOOP AT lt_bkpf INTO ls_bkpf.
          lv_tabix = sy-tabix.


          ls_document-awtyp = 'BKPF'.
          ls_document-belnr = ls_bkpf-belnr.
          ls_document-gjahr = ls_bkpf-gjahr.

          IF ls_document-gjahr IS INITIAL.
            ls_document-gjahr = sy-datum(4).
          ENDIF.

          APPEND ls_document TO lt_documents.
        ENDLOOP.

*      WHEN 'MA'."gkadioglu eklendi
*        MOVE-CORRESPONDING it_data[] TO lt_manu[].
*
*        CLEAR lv_tabix.
*        LOOP AT lt_manu INTO ls_manu.
*          lv_tabix = sy-tabix.
*          ls_document-awtyp = 'MANU'.
*          ls_document-belnr = ls_manu-belnr.
*          ls_document-bldat = ls_manu-bldat.
*          ls_document-gjahr = ls_manu-gjahr.
*          APPEND ls_document TO lt_documents.
*        ENDLOOP.
    ENDCASE.

*    DESCRIBE TABLE lt_documents LINES DATA(lv_lines).
*    IF lv_lines = 1.
*      CLEAR lv_merge_id.
*    ENDIF.

    CLEAR lv_tabix.
    LOOP AT lt_documents INTO ls_document.
      lv_tabix = sy-tabix.

      CALL FUNCTION '/ITETR/INV_INVOICE_CHECK_SAVE'
        EXPORTING
          iv_awtyp    = ls_document-awtyp
          iv_bukrs    = iv_bukrs
          iv_belnr    = ls_document-belnr
          iv_gjahr    = ls_document-gjahr
        IMPORTING
          es_document = ls_inv_oginv_1
          es_return   = ls_return.

      IF lv_tabix = 1.
        ls_inv_oginv = ls_inv_oginv_1.
      ENDIF.

    ENDLOOP.

    IF ls_inv_oginv IS INITIAL.
      LOOP AT lt_documents INTO ls_document.
        SELECT SINGLE bukrs
                      docui
                      envui
                      invui
                      invno
                      stacd
                      xsltt
                      prfid
                      invty FROM /itetr/inv_oginv                   "#EC CI_NOFIELD
                                      INTO CORRESPONDING FIELDS OF ls_inv_oginv
                                                                         WHERE bukrs = iv_bukrs
                                                                           AND belnr = ls_document-belnr
                                                                           AND gjahr = ls_document-gjahr
                                                                           AND awtyp = ls_document-awtyp
                                                                         "  AND stacd IN ('','2')
                                                                           AND revch EQ abap_false.

      ENDLOOP.

      IF ls_inv_oginv-envui IS INITIAL."gkadioglu
        ls_inv_oginv-envui = ls_inv_oginv-invui.
      ENDIF.

    ELSE.

      CALL FUNCTION 'TH_IN_UPDATE_TASK'
        IMPORTING
          in_update_task = lv_in_update_task.

      IF lv_in_update_task NE 1.
        COMMIT WORK AND WAIT.
      ENDIF.

    ENDIF.


    GET TIME.


    IF ls_inv_oginv IS  INITIAL.
      CLEAR:ls_return_t .
      LOOP AT lt_documents INTO ls_document.
        ls_return_t-type = 'E'.
        ls_return_t-log_no = 'ZNTT_CREATE'.
        ls_return_t-message_v1 = iv_module.
        ls_return_t-message_v2 = ls_document-belnr.
        ls_return_t-message_v3 = 'Gönderime Hazırlamada E-Dönüşümdeki Uyarlama Kriterlerine Uygun veri bulunamamıştır.'.
        APPEND ls_return_t TO et_return.
      ENDLOOP.
*      ls_dlv_log-messages = ls_return_t-message_v1 && ls_return_t-message_v2 && ls_return_t-message_v3 .
      EXIT.
    ENDIF.

    CASE iv_process_method.
      WHEN 'SEND2TRA'.

        CLEAR lr_stacd.
        ls_stacd-sign   = 'I'.
        ls_stacd-option = 'EQ'.
        ls_stacd-low    = ''.
        APPEND ls_stacd TO lr_stacd.
        ls_stacd-low    = '2'.

        APPEND ls_stacd TO lr_stacd.

        IF ls_inv_oginv-stacd IN lr_stacd AND
           ls_inv_oginv-revch EQ abap_false.
          ls_doc_t-docui = ls_inv_oginv-docui.
          APPEND ls_doc_t TO lt_doc_t.

          CALL FUNCTION '/ITETR/INV_OUTINV_SEND_V2'
            EXPORTING
              iv_company_code    = iv_bukrs
              it_documents       = lt_doc_t
            IMPORTING
              ev_invoice_uuid    = es_response-invui
              ev_invoice_no      = es_response-invno
              ev_envelope_uuid   = es_response-envui
              ev_integrator_uuid = es_response-invii
              ev_ubl_xstring     = es_response-ubl_xstring
              ev_stacd           = es_response-stacd
              et_return          = lt_return.

          et_return[] = lt_return[].

        ENDIF.


        es_response-bukrs       = iv_bukrs.
        es_response-doc_number  = ls_document-belnr.
        es_response-gjahr       = ls_document-gjahr.
        es_response-docui       = ls_inv_oginv-docui.
        es_response-prfid       = ls_inv_oginv-prfid.
        es_response-invty       = ls_inv_oginv-invty.
        es_response-xsltt       = ls_inv_oginv-xsltt.

        IF es_response-invui IS INITIAL.
          es_response-invui = ls_inv_oginv-invui.
        ENDIF.

        IF es_response-envui IS INITIAL.
          es_response-envui = ls_inv_oginv-envui.
        ENDIF.

        IF es_response-invno IS INITIAL.
          es_response-invno = ls_inv_oginv-invno.
        ENDIF.



    ENDCASE.


  ENDMETHOD.


  METHOD set_initial_data.
    ms_document = is_document.
    mv_preview = iv_preview.
    mo_invoice_operations = /itetr/cl_invoice_operations=>factory( ms_document-bukrs ).

    " <--- hkizilkaya
    TYPES: BEGIN OF ty_einp,
             genid        TYPE /itetr/com_e_genid,
             barcode      TYPE /itetr/com_e_barcode,
             sepallowance TYPE /itetr/com_e_sepallowance,
           END OF ty_einp.
    DATA: ls_einp TYPE ty_einp,
          ls_earp TYPE ty_einp.
    " hkizilkaya --->

    SELECT SINGLE value
      INTO mv_company_taxid
      FROM /itetr/com_cmppi
      WHERE bukrs = ms_document-bukrs
        AND prtid = 'VKN'.
    CASE ms_document-prfid.
      WHEN 'EARSIV'.
        SELECT SINGLE genid barcode sepallowance
          FROM /itetr/inv_earp
          INTO ls_earp
          WHERE bukrs = ms_document-bukrs.
        mv_generate_invoice_id = ls_earp-genid. "hkizilkaya
        mv_barcode = ls_earp-barcode. "hkizilkaya
        mv_sepallowance = ls_earp-sepallowance.
        IF mv_company_taxid IS INITIAL.
          SELECT SINGLE value
            FROM /itetr/inv_eacp
            INTO mv_company_taxid
            WHERE bukrs = ms_document-bukrs
              AND cuspa = 'TEST_VKN'.
        ENDIF.

        SELECT SINGLE value
          FROM /itetr/inv_eacp
          INTO mv_add_signature
          WHERE bukrs = ms_document-bukrs
            AND cuspa = 'ADDSIGN'.

        SELECT SINGLE value
          FROM /itetr/inv_eacp
          INTO mv_item_sort
          WHERE bukrs = ms_document-bukrs
            AND cuspa = 'ITEMSORT'.

        SELECT SINGLE value "gkadioglu
          FROM /itetr/inv_eacp
          INTO mv_fix_quantity
          WHERE bukrs = ms_document-bukrs
            AND cuspa = 'FIXQUAN'.

        SELECT SINGLE value "gkadioglu
        FROM /itetr/inv_eacp
        INTO mv_invtype
        WHERE bukrs = ms_document-bukrs
          AND cuspa = 'INVTYPE'.

      WHEN OTHERS.
        SELECT SINGLE genid barcode sepallowance
          FROM /itetr/inv_einp
          INTO ls_einp
          WHERE bukrs = ms_document-bukrs.
        mv_generate_invoice_id = ls_einp-genid. "hkizilkaya
        mv_barcode = ls_einp-barcode. "hkizilkaya
        mv_sepallowance = ls_einp-sepallowance.
        IF mv_company_taxid IS INITIAL.
          SELECT SINGLE value
            FROM /itetr/inv_eicp
            INTO mv_company_taxid
            WHERE bukrs = ms_document-bukrs
              AND cuspa = 'TEST_VKN'.
        ENDIF.

        SELECT SINGLE value
          FROM /itetr/inv_eicp
          INTO mv_add_signature
          WHERE bukrs = ms_document-bukrs
            AND cuspa = 'ADDSIGN'.

        SELECT SINGLE value
          FROM /itetr/inv_eicp
          INTO mv_item_sort
          WHERE bukrs = ms_document-bukrs
            AND cuspa = 'ITEMSORT'.

        SELECT SINGLE value "gkadioglu
          FROM /itetr/inv_eicp
          INTO mv_fix_quantity
          WHERE bukrs = ms_document-bukrs
            AND cuspa = 'FIXQUAN'.

        SELECT SINGLE value "gkadioglu
          FROM /itetr/inv_eicp
          INTO mv_invtype
          WHERE bukrs = ms_document-bukrs
            AND cuspa = 'INVTYPE'.

    ENDCASE.
    IF mv_item_sort IS INITIAL.
      SELECT SINGLE value
        FROM /itetr/com_cmpcp
        INTO mv_item_sort
        WHERE bukrs = ms_document-bukrs
          AND cuspa = 'ITEMSORT'.
    ENDIF.

    SELECT * FROM  /itetr/inv_eicp INTO TABLE  mt_inv_eicp WHERE bukrs = ms_document-bukrs OR
                                                                 bukrs = space .

  ENDMETHOD.


  METHOD summarize_items.
    DATA: ls_items              TYPE mty_item_collect,
          ls_items_2            TYPE mty_item_collect,
          ls_items_sum          TYPE mty_item_collect,
          lt_items_sum          TYPE TABLE OF mty_item_collect,
          lv_taxrt              TYPE /itetr/inv_taxm-taxrt,
          ls_vbrp               TYPE vbrpvb,
          ls_vbap               TYPE vbap,
          ls_conditions         TYPE /itetr/inv_cond,
          ls_konv               TYPE komv,
          ls_maw1               TYPE maw1,
          lv_herkl              TYPE maw1-wherl,
          ls_marc               TYPE marc,
          ls_t005t              TYPE t005t,
          ls_export_data        TYPE /itetr/cl_outgoing_invoice=>mty_export_spec_data,
          ls_item_allowance     TYPE mty_item_allowance,
          ls_item_allowance_sum TYPE mty_item_allowance,
          lt_item_allowance_sum TYPE TABLE OF mty_item_allowance,
          ls_sddt               TYPE /itetr/inv_sddt,
          lt_sddt               TYPE TABLE OF  /itetr/inv_sddt,
          lv_summarize_text     TYPE text255.
    DATA : lv_tabix TYPE sy-tabix.

    LOOP AT mt_invoice_items TRANSPORTING NO FIELDS WHERE summr IS NOT INITIAL .
      EXIT.
    ENDLOOP.

    IF sy-subrc IS INITIAL.
      SORT mt_invoice_items BY posnr ASCENDING summr ASCENDING.
      LOOP AT mt_invoice_items INTO ls_items.
        CLEAR lv_tabix.
        READ TABLE lt_items_sum INTO ls_items_sum WITH KEY summr = ls_items-summr.
        lv_tabix = sy-tabix.

        IF sy-subrc IS INITIAL.
          IF ls_items_sum-mwskz IS INITIAL.
            ls_items_sum-mwskz = ls_items-mwskz.
          ENDIF.
          ls_items_sum-netwr  =  ls_items_sum-netwr + ls_items-netwr.
          ls_items_sum-netpr  =  ls_items_sum-netpr + ls_items-netpr.
          ls_items_sum-peinh  =  ls_items_sum-peinh + ls_items-peinh.
          ls_items_sum-fkimg  =  ls_items_sum-fkimg + ls_items-fkimg.
          ls_items_sum-distr  =  ls_items_sum-distr + ls_items-distr.
          ls_items_sum-surtr  =  ls_items_sum-surtr + ls_items-surtr.
          ls_items_sum-mwsbp  =  ls_items_sum-mwsbp + ls_items-mwsbp.
          ls_items_sum-kwrfr  =  ls_items_sum-kwrfr + ls_items-kwrfr.
          ls_items_sum-kwrin  =  ls_items_sum-kwrin + ls_items-kwrin.
          ls_items_sum-kwrfr  =  ls_items_sum-kwrfr + ls_items-kwrfr.
          MODIFY lt_items_sum FROM ls_items_sum INDEX lv_tabix.
        ELSE.
          APPEND ls_items TO lt_items_sum.
        ENDIF.

      ENDLOOP.
      mt_invoice_items[] = lt_items_sum[].
      SORT lt_item_allowance_sum BY posnr ASCENDING summr ASCENDING.
      LOOP AT mt_items_allowance INTO ls_item_allowance.

        CLEAR lv_tabix.
        READ TABLE lt_item_allowance_sum INTO ls_item_allowance_sum WITH KEY summr = ls_item_allowance-summr.
        lv_tabix = sy-tabix.

        IF sy-subrc IS INITIAL.

          ls_item_allowance_sum-distr  =  ls_item_allowance_sum-distr + ls_item_allowance-distr.
          ls_item_allowance_sum-surtr  =  ls_item_allowance_sum-surtr + ls_item_allowance-surtr.
          MODIFY lt_item_allowance_sum FROM ls_item_allowance_sum INDEX lv_tabix.

        ELSE.
          APPEND ls_item_allowance_sum TO lt_item_allowance_sum.
        ENDIF.

      ENDLOOP.
      mt_items_allowance[] = lt_item_allowance_sum[].

    ENDIF.

  ENDMETHOD.


  METHOD ubl_fill_agent_data.
    DATA: lx_etr_exception   TYPE REF TO /itetr/cx_regulative_exception,
          ls_company         TYPE /itetr/com_cmpbi,
          lt_identifications TYPE STANDARD TABLE OF /itetr/com_cmpbp,
          ls_identifications TYPE /itetr/com_cmpbp.
    FIELD-SYMBOLS: <ls_party_identification> TYPE /itetr/com_party_identificati1.

    SELECT SINGLE *
      FROM /itetr/com_cmpbi
      INTO ls_company
      WHERE bukrs = iv_bukrs
        AND agent = iv_agent.
    IF sy-subrc IS NOT INITIAL.
      lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( '023' ).
      RAISE EXCEPTION lx_etr_exception.
    ENDIF.

    rs_data-website_uri-base-base-content = ls_company-website.
    rs_data-party_name-name-base-base-content = ls_company-title.
    rs_data-party_tax_scheme-tax_scheme-name-base-base-content = ls_company-taxof.
    rs_data-postal_address-district-base-base-content = ls_company-distr.
    rs_data-postal_address-street_name-base-base-content = ls_company-street.
    rs_data-postal_address-block_name-base-base-content = ls_company-blckn.
    rs_data-postal_address-building_name-base-base-content = ls_company-bldnm.
    rs_data-postal_address-building_number-base-base-content = ls_company-bldno.
    rs_data-postal_address-room-base-base-content = ls_company-roomn.
    rs_data-postal_address-postbox-base-base-content = ls_company-pobox.
    rs_data-postal_address-postal_zone-base-base-content = ls_company-pstcd.
    rs_data-postal_address-city_subdivision_name-base-base-content = ls_company-subdv.
    rs_data-postal_address-city_name-base-base-content = ls_company-cityn.
    rs_data-postal_address-region-base-base-content = ls_company-region.
    rs_data-postal_address-country-name-base-base-content = ls_company-country.
    rs_data-contact-electronic_mail-base-base-content = ls_company-email.
    rs_data-contact-telephone-base-base-content = ls_company-telnm.
    rs_data-contact-telefax-base-base-content = ls_company-faxnm.

    SELECT *
      FROM /itetr/com_cmpbp
      INTO TABLE lt_identifications
      WHERE bukrs = iv_bukrs
        AND agent = iv_agent.
    IF sy-subrc IS INITIAL.
      LOOP AT lt_identifications INTO ls_identifications.
        APPEND INITIAL LINE TO rs_data-party_identification ASSIGNING <ls_party_identification>.
        <ls_party_identification>-id-base-base-content = ls_identifications-value.
        CALL FUNCTION 'CONVERSION_EXIT_YYPID_OUTPUT'
          EXPORTING
            input  = ls_identifications-prtid
          IMPORTING
            output = <ls_party_identification>-id-base-base-scheme_id.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD ubl_fill_company_data.
    DATA: ls_company         TYPE /itetr/com_cmpin,
          lt_identifications TYPE STANDARD TABLE OF /itetr/com_cmppi,
          ls_identifications TYPE /itetr/com_cmppi,
          lx_etr_exception   TYPE REF TO /itetr/cx_regulative_exception.
    FIELD-SYMBOLS: <ls_party_identification> TYPE /itetr/com_party_identificati1.
    SELECT SINGLE *
      FROM /itetr/com_cmpin
      INTO ls_company
      WHERE bukrs = iv_bukrs.
    IF sy-subrc IS NOT INITIAL.
      lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( '001' ).
      RAISE EXCEPTION lx_etr_exception.
    ENDIF.

    rs_data-website_uri-base-base-content = ls_company-website.
    rs_data-party_name-name-base-base-content = ls_company-title.
    rs_data-party_tax_scheme-tax_scheme-name-base-base-content = ls_company-taxof.
    rs_data-postal_address-district-base-base-content = ls_company-distr.
    rs_data-postal_address-street_name-base-base-content = ls_company-street.
    rs_data-postal_address-block_name-base-base-content = ls_company-blckn.
    rs_data-postal_address-building_name-base-base-content = ls_company-bldnm.
    rs_data-postal_address-building_number-base-base-content = ls_company-bldno.
    rs_data-postal_address-room-base-base-content = ls_company-roomn.
    rs_data-postal_address-postbox-base-base-content = ls_company-pobox.
    rs_data-postal_address-postal_zone-base-base-content = ls_company-pstcd.
    rs_data-postal_address-city_subdivision_name-base-base-content = ls_company-subdv.
    rs_data-postal_address-city_name-base-base-content = ls_company-cityn.
    rs_data-postal_address-region-base-base-content = ls_company-region.
    rs_data-postal_address-country-name-base-base-content = ls_company-country.
    rs_data-contact-electronic_mail-base-base-content = ls_company-email.
    rs_data-contact-telephone-base-base-content = ls_company-telnm.
    rs_data-contact-telefax-base-base-content = ls_company-faxnm.

    SELECT *
      FROM /itetr/com_cmppi
      INTO TABLE lt_identifications
      WHERE bukrs = iv_bukrs.
    IF sy-subrc IS INITIAL.
      LOOP AT lt_identifications INTO ls_identifications.
        APPEND INITIAL LINE TO rs_data-party_identification ASSIGNING <ls_party_identification>.
        CALL FUNCTION 'CONVERSION_EXIT_YYPID_OUTPUT'
          EXPORTING
            input  = ls_identifications-prtid
          IMPORTING
            output = <ls_party_identification>-id-base-base-scheme_id.
        <ls_party_identification>-id-base-base-content = ls_identifications-value.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD ubl_fill_other_party_data.
    DATA: lt_taxid         TYPE RANGE OF stcd2,
          ls_taxid         LIKE LINE OF lt_taxid,
          lt_prtty         TYPE RANGE OF /itetr/com_e_prtty,
          ls_prtty         LIKE LINE OF lt_prtty,
          lx_etr_exception TYPE REF TO /itetr/cx_regulative_exception,
          ls_party_data    TYPE /itetr/com_othp,
          lv_person        TYPE xfeld.
    FIELD-SYMBOLS: <ls_identification> TYPE /itetr/com_party_identificati1.

    IF iv_taxid IS NOT INITIAL.
      ls_taxid-sign = 'I'.
      ls_taxid-option = 'EQ'.
      ls_taxid-low = iv_taxid.
      APPEND ls_taxid TO lt_taxid.
    ENDIF.
    IF iv_prtty IS NOT INITIAL.
      ls_prtty-sign = 'I'.
      ls_prtty-option = 'EQ'.
      ls_prtty-low = iv_prtty.
      APPEND ls_prtty TO lt_prtty.
    ENDIF.

    IF iv_taxid IS INITIAL AND iv_prtty IS INITIAL.
      lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( '025' ).
      RAISE EXCEPTION lx_etr_exception.
    ENDIF.

    SELECT SINGLE *
      FROM /itetr/com_othp
      INTO ls_party_data
      WHERE taxid IN lt_taxid
        AND prtty IN lt_prtty.
    IF sy-subrc IS NOT INITIAL.
      lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( '025' ).
      RAISE EXCEPTION lx_etr_exception.
    ENDIF.

    rs_data-website_uri-base-base-content = ls_party_data-website.
    rs_data-party_name-name-base-base-content = ls_party_data-title.
    rs_data-party_tax_scheme-tax_scheme-name-base-base-content = ls_party_data-taxof.
    rs_data-postal_address-district-base-base-content = ls_party_data-distr.
    rs_data-postal_address-street_name-base-base-content = ls_party_data-street.
    rs_data-postal_address-block_name-base-base-content = ls_party_data-blckn.
    rs_data-postal_address-building_name-base-base-content = ls_party_data-bldnm.
    rs_data-postal_address-building_number-base-base-content = ls_party_data-bldno.
    rs_data-postal_address-room-base-base-content = ls_party_data-roomn.
    rs_data-postal_address-postbox-base-base-content = ls_party_data-pobox.
    rs_data-postal_address-postal_zone-base-base-content = ls_party_data-pstcd.
    rs_data-postal_address-city_subdivision_name-base-base-content = ls_party_data-subdv.
    rs_data-postal_address-city_name-base-base-content = ls_party_data-cityn.
    rs_data-postal_address-region-base-base-content = ls_party_data-region.
    rs_data-postal_address-country-name-base-base-content = ls_party_data-country.
    rs_data-contact-electronic_mail-base-base-content = ls_party_data-email.
    rs_data-contact-telephone-base-base-content = ls_party_data-telnm.
    rs_data-contact-telefax-base-base-content = ls_party_data-faxnm.

    lv_person = COND xfeld( WHEN strlen( ls_party_data-taxid ) = 11 THEN abap_true ELSE abap_false ).
    APPEND INITIAL LINE TO rs_data-party_identification ASSIGNING <ls_identification>.
    IF ls_party_data-taxid IS NOT INITIAL.
      <ls_identification>-id-base-base-content = ls_party_data-taxid.
    ELSEIF lv_person = abap_true.
      <ls_identification>-id-base-base-content = '11111111111'.
    ELSE.
      <ls_identification>-id-base-base-content = '1111111111'.
    ENDIF.
    IF strlen( <ls_identification>-id-base-base-content ) = 11.
      <ls_identification>-id-base-base-scheme_id = 'TCKN'.
    ELSE.
      <ls_identification>-id-base-base-scheme_id = 'VKN'.
    ENDIF.
  ENDMETHOD.


  METHOD ubl_fill_partner_data.
    DATA: ls_address       TYPE szadr_addr1_complete,
          ls_t005t         TYPE t005t,
          ls_t005u         TYPE t005u,
          lx_etr_exception TYPE REF TO /itetr/cx_regulative_exception,
          ls_addr1         TYPE szadr_addr1_line,
          ls_adtel         TYPE szadr_adtel_line,
          ls_adfax         TYPE szadr_adfax_line,
          ls_aduri         TYPE szadr_aduri_line,
          ls_adsmtp        TYPE szadr_adsmtp_line,
          ls_taxdetails    TYPE bus_tax,
          lv_taxid         TYPE bus_tax-tax_number,
          lv_person        TYPE abap_bool.
    FIELD-SYMBOLS: <ls_identification> TYPE /itetr/com_party_identificati1,
                   <ls_legal_entity>   TYPE /itetr/com_party_legal_entity1.

    CALL FUNCTION 'ADDR_GET_COMPLETE'
      EXPORTING
        addrnumber              = iv_address_number
      IMPORTING
        addr1_complete          = ls_address
      EXCEPTIONS
        parameter_error         = 1
        address_not_exist       = 2
        internal_error          = 3
        wrong_access_to_archive = 4
        OTHERS                  = 5.
    IF sy-subrc IS NOT INITIAL.
      lx_etr_exception = /itetr/cx_regulative_exception=>create_by_message( '024' ).
      RAISE EXCEPTION lx_etr_exception.
    ENDIF.

    IF iv_nation IS NOT INITIAL.
      READ TABLE ls_address-addr1_tab INTO ls_addr1 WITH KEY nation = iv_nation.
      IF sy-subrc IS NOT INITIAL.
        READ TABLE ls_address-addr1_tab INTO ls_addr1 INDEX 1.
      ENDIF.
    ELSE.
      READ TABLE ls_address-addr1_tab INTO ls_addr1 INDEX 1.
    ENDIF.

    IF sy-subrc = 0.
      rs_data-postal_address-street_name-base-base-content = ls_addr1-data-name_co .
      IF ls_addr1-data-str_suppl1 IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-str_suppl1
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.
      IF ls_addr1-data-str_suppl2 IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-str_suppl2
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.
      IF ls_addr1-data-street IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-street
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.
      IF ls_addr1-data-str_suppl3 IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-str_suppl3
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.
      IF ls_addr1-data-house_num1 IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-house_num1
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.
      IF ls_addr1-data-house_num2 IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-house_num2
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.
      IF ls_addr1-data-location IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-location
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.
      IF ls_addr1-data-city2 IS NOT INITIAL.
        CONCATENATE rs_data-postal_address-street_name-base-base-content ls_addr1-data-city2
          INTO rs_data-postal_address-street_name-base-base-content
          SEPARATED BY space.
      ENDIF.

      rs_data-postal_address-postal_zone-base-base-content = ls_addr1-data-post_code1.
      IF ls_addr1-data-country IS NOT INITIAL.
        CALL FUNCTION 'T005T_SINGLE_READ'
          EXPORTING
            t005t_spras = sy-langu
            t005t_land1 = ls_addr1-data-country
          IMPORTING
            wt005t      = ls_t005t
          EXCEPTIONS
            not_found   = 1
            OTHERS      = 2.
        IF sy-subrc = 0.
          rs_data-postal_address-country-name-base-base-content = ls_t005t-landx.
        ENDIF.
        mv_country = ls_addr1-data-country. "gkadioglu
      ENDIF.
      IF ls_addr1-data-region IS NOT INITIAL.
        CALL FUNCTION 'T005U_SINGLE_READ'
          EXPORTING
            t005u_spras = sy-langu
            t005u_land1 = ls_addr1-data-country
            t005u_bland = ls_addr1-data-region
          IMPORTING
            wt005u      = ls_t005u
          EXCEPTIONS
            not_found   = 1
            OTHERS      = 2.
        IF sy-subrc = 0.
          rs_data-postal_address-city_name-base-base-content = ls_t005u-bezei.
        ENDIF.
      ELSEIF ls_addr1-data-city1 IS NOT INITIAL.
        rs_data-postal_address-city_name-base-base-content = ls_addr1-data-city1.
      ENDIF.
      IF ls_addr1-data-city1 IS NOT INITIAL .
        rs_data-postal_address-city_subdivision_name-base-base-content = ls_addr1-data-city1.
      ELSE.
        rs_data-postal_address-city_subdivision_name-base-base-content = '...'.
      ENDIF.
      rs_data-postal_address-building_number-base-base-content = ls_addr1-data-building.
      rs_data-postal_address-room-base-base-content = ls_addr1-data-roomnumber.
    ENDIF.

    READ TABLE ls_address-adtel_tab INTO ls_adtel INDEX 1.
    IF sy-subrc = 0.
      IF ls_adtel-adtel-telnr_long IS NOT INITIAL.
        rs_data-contact-telephone-base-base-content = ls_adtel-adtel-telnr_long.
      ELSEIF ls_adtel-adtel-tel_number IS NOT INITIAL.
        rs_data-contact-telephone-base-base-content = ls_adtel-adtel-tel_number.
      ENDIF.
    ENDIF.

    READ TABLE ls_address-adfax_tab INTO ls_adfax INDEX 1.
    IF sy-subrc = 0.
      IF ls_adfax-adfax-faxnr_long IS NOT INITIAL.
        rs_data-contact-telefax-base-base-content = ls_adfax-adfax-faxnr_long.
      ELSEIF ls_adfax-adfax-fax_number IS NOT INITIAL.
        rs_data-contact-telefax-base-base-content = ls_adfax-adfax-fax_number.
      ENDIF.
    ENDIF.

    READ TABLE ls_address-aduri_tab INTO ls_aduri INDEX 1.
    IF sy-subrc = 0 AND ls_aduri-aduri-uri_addr IS NOT INITIAL.
      rs_data-website_uri-base-base-content = ls_aduri-aduri-uri_addr.
    ENDIF.

    READ TABLE ls_address-adsmtp_tab INTO ls_adsmtp INDEX 1.
    IF sy-subrc = 0 AND ls_adsmtp-adsmtp-smtp_addr IS NOT INITIAL.
      rs_data-contact-electronic_mail-base-base-content = ls_adsmtp-adsmtp-smtp_addr.
    ENDIF.

    IF iv_profile_id NE 'IHRACAT' AND
       iv_profile_id NE 'YOLCU'   AND
       iv_profile_id NE 'MUSTAHSIL'.
      rs_data-party_tax_scheme-tax_scheme-name-base-base-content = iv_tax_office.
      lv_taxid = iv_tax_id.
    ENDIF.

    IF iv_profile_id EQ 'MUSTAHSIL'.
      lv_taxid = iv_tax_id.
    ENDIF.

    CONDENSE ls_addr1-data-name1.
    CONDENSE ls_addr1-data-name2.

      IF strlen( lv_taxid ) = 11.
        lv_person = abap_true.
        rs_data-person-first_name-base-base-content = ls_addr1-data-name1.
        rs_data-person-family_name-base-base-content = ls_addr1-data-name2.
        IF rs_data-person-family_name-base-base-content IS INITIAL.
          SPLIT ls_addr1-data-name1
            AT space
            INTO rs_data-person-first_name-base-base-content
                 rs_data-person-family_name-base-base-content.
        ENDIF.
        IF rs_data-person-family_name-base-base-content IS INITIAL.
          rs_data-person-first_name-base-base-content = ls_addr1-data-name1.
          rs_data-person-family_name-base-base-content = '...'.
        ENDIF.
        rs_data-person-nationality_id-base-base-content = ls_addr1-data-country.
      ELSE.
        CONCATENATE ls_addr1-data-name1 ls_addr1-data-name2
          INTO rs_data-party_name-name-base-base-content
          SEPARATED BY space.
      ENDIF.

    CASE iv_profile_id.
      WHEN 'IHRACAT'.
        APPEND INITIAL LINE TO rs_data-party_identification ASSIGNING <ls_identification>.
        <ls_identification>-id-base-base-content = 'EXPORT'.
        <ls_identification>-id-base-base-scheme_id = 'PARTYTYPE'.


        APPEND INITIAL LINE TO rs_data-party_legal_entity ASSIGNING <ls_legal_entity>.
        <ls_legal_entity>-company_id-base-base-content = '22222222222'."iv_address_number. AS 06.01.2022
        <ls_legal_entity>-registration_name-base-base-content = rs_data-party_name-name-base-base-content.


        " AS 06.01.2022
        APPEND INITIAL LINE TO rs_data-party_identification ASSIGNING <ls_identification>.
        IF lv_taxid IS NOT INITIAL.
          <ls_identification>-id-base-base-content = lv_taxid.
        ELSEIF lv_person = abap_true.
          <ls_identification>-id-base-base-content = '22222222222'.
        ELSE.
          <ls_identification>-id-base-base-content = '2222222222'.
        ENDIF.
        IF strlen( <ls_identification>-id-base-base-content ) = 11.
          <ls_identification>-id-base-base-scheme_id = 'TCKN'.
        ELSE.
          <ls_identification>-id-base-base-scheme_id = 'VKN'.
        ENDIF.
      WHEN 'YOLCU'.
        APPEND INITIAL LINE TO rs_data-party_identification ASSIGNING <ls_identification>.
        <ls_identification>-id-base-base-content = 'TAXFREE'.
        <ls_identification>-id-base-base-scheme_id = 'PARTYTYPE'.
      WHEN OTHERS.
        APPEND INITIAL LINE TO rs_data-party_identification ASSIGNING <ls_identification>.
        IF lv_taxid IS NOT INITIAL.
          <ls_identification>-id-base-base-content = lv_taxid.
        ELSEIF lv_person = abap_true.
          <ls_identification>-id-base-base-content = '11111111111'.
        ELSE.
          <ls_identification>-id-base-base-content = '1111111111'.
        ENDIF.
        IF strlen( <ls_identification>-id-base-base-content ) = 11.
          <ls_identification>-id-base-base-scheme_id = 'TCKN'.
        ELSE.
          <ls_identification>-id-base-base-scheme_id = 'VKN'.
        ENDIF.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.