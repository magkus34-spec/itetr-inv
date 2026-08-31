class /ITETR/CL_INVOICE_OPERATIONS definition
  public
  create protected .

public section.

  types:
    tt_komv TYPE TABLE OF  komv .
  types:
    tt_vbpa TYPE TABLE OF  vbpavb .
  types:
    tt_vbrk TYPE TABLE OF  vbrkvb .
  types:
    tt_vbrp TYPE TABLE OF  vbrpvb .
  types S_VBRK type VBRKVB .
  types S_VBPA type VBPAVB .

*"      XKOMV STRUCTURE  KOMV
*"      XVBPA STRUCTURE  VBPAVB
*"      XVBRK STRUCTURE  VBRKVB
*"      XVBRP STRUCTURE  VBRPVB
  class-methods FACTORY
    importing
      !IV_COMPANY type BUKRS
    returning
      value(RO_INSTANCE) type ref to /ITETR/CL_INVOICE_OPERATIONS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_SAVE
    importing
      !IV_AWTYP type AWTYP
      !IV_BUKRS type BUKRS
      !IV_BELNR type BELNR_D
      !IV_GJAHR type GJAHR
    returning
      value(RS_DOCUMENT) type /ITETR/INV_OGINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_CUSTOMER_TAXID
    importing
      !IV_TAX_ID_FNAME type /ITETR/INV_E_TAX_ID_FNAME optional
      !IV_TAX_OFFICE_FNAME type /ITETR/INV_E_TAX_OFFICE_FNAME optional
      !IV_KUNNR type KUNNR
      !IV_KOART type KOART default 'D'
    exporting
      !EV_TAXID type STCD2
      !EV_TAX_OFFICE type /ITETR/COM_E_TAXOF
      !EV_ADRNR type ADRNR
      !EV_NAME type TEXT100 .
  methods GET_VENDOR_TAXID
    importing
      !IV_LIFNR type LIFNR
    exporting
      !EV_TAXID type STCD2
      !EV_TAX_OFFICE type /ITETR/COM_E_TAXOF .
  methods GET_BILLING_ONETIME_TAX
    importing
      !IS_VBPA type VBPAVB
      !IV_TAX_ID_FNAME type /ITETR/INV_E_TAX_ID_FNAME optional
      !IV_TAX_OFFICE_FNAME type /ITETR/INV_E_TAX_OFFICE_FNAME optional
    exporting
      !EV_TAXID type STCD2
      !EV_TAX_OFFICE type /ITETR/COM_E_TAXOF .
  methods GET_ACCOUNTING_ONETIME_TAX
    importing
      !IS_BSEC type BSEC
    exporting
      !EV_TAXID type STCD2
      !EV_TAX_OFFICE type /ITETR/COM_E_TAXOF .
  methods GET_INCOMING_INVOICES
    importing
      !IV_DATE_FROM type DATUM optional
      !IV_DATE_TO type DATUM optional
    returning
      value(RT_LIST) type /ITETR/INV_TT_ICINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods SET_SPECIFIC_RULES_EXIT
    importing
      !IS_VBRK type S_VBRK optional
      !IS_VBPA type S_VBPA optional
      !IT_VBPA type TT_VBPA optional
      !IT_VBRP type TT_VBRP optional
    exporting
      !EV_ADD_KEY_XSLT type /ITETR/COM_E_ADD_KEY
      !EV_ADD_KEY_SERNR type /ITETR/COM_E_ADD_KEY
    changing
      !IS_DOCUMENT type /ITETR/INV_OGINV .
  methods SET_SAVE_VBRK_EXIT
    changing
      !IT_VBPA type TT_VBPA optional
      !IT_VBRK type TT_VBRK optional
      !IT_VBRP type TT_VBRP optional
      !IT_KOMV type TT_KOMV optional
      !IS_DOCUMENT type /ITETR/INV_OGINV optional
      !IV_SUBRC type SYSUBRC optional
      !IS_VBRK type VBRKVB optional .
  methods SAVE_INCOMING_INVOICES
    importing
      !IT_LIST type /ITETR/INV_TT_ICINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_INCOMING_ARCHIVES
    importing
      !IV_DATE_FROM type DATUM optional
      !IV_DATE_TO type DATUM optional
    returning
      value(RT_LIST) type /ITETR/INV_TT_ICINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods UPDATE_CHECK_OGINV_DATE_EXIT
    changing
      !IT_VBPA type TT_VBPA optional
      !IT_VBRK type TT_VBRK optional
      !IT_VBRP type TT_VBRP optional
      !IT_KOMV type TT_KOMV optional
      !IS_DOCUMENT type /ITETR/INV_OGINV optional
      !IV_SUBRC type SYSUBRC optional .
protected section.

  data MV_COMPANY_CODE type BUKRS .
  data:
    mt_parameters TYPE TABLE OF /itetr/inv_eicp .

  methods OUTGOING_INVOICE_SAVE_VBRK
    importing
      !IV_AWTYP type AWTYP
      !IV_BUKRS type BUKRS
      !IV_BELNR type BELNR_D
      !IV_GJAHR type GJAHR
    returning
      value(RS_DOCUMENT) type /ITETR/INV_OGINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_SAVE_RMRP
    importing
      !IV_AWTYP type AWTYP
      !IV_BUKRS type BUKRS
      !IV_BELNR type BELNR_D
      !IV_GJAHR type GJAHR
    returning
      value(RS_DOCUMENT) type /ITETR/INV_OGINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_SAVE_BKPF
    importing
      !IV_AWTYP type AWTYP
      !IV_BUKRS type BUKRS
      !IV_BELNR type BELNR_D
      !IV_GJAHR type GJAHR
    returning
      value(RS_DOCUMENT) type /ITETR/INV_OGINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_AGENT
    importing
      !IV_BUKRS type BUKRS
      !IV_GSBER type GSBER optional
      !IV_WERKS type WERKS_D optional
      !IV_AWTYP type AWTYP optional
      !IV_BELNR type BELNR_D optional
      !IV_GJAHR type GJAHR optional
    returning
      value(RV_AGENT) type /ITETR/COM_E_AGENT .
  methods GET_EINVOICE_RULE
    importing
      !IV_RULE_TYPE type /ITETR/INV_E_RULET
      !IS_RULE_INPUT type /ITETR/INV_S_EIRULES_IN
    returning
      value(RS_RULE_OUTPUT) type /ITETR/INV_S_EIRULES_OUT .
  methods GET_EARCHIVE_RULE
    importing
      !IV_RULE_TYPE type /ITETR/INV_E_RULET
      !IS_RULE_INPUT type /ITETR/INV_S_EARULES_IN
    returning
      value(RS_RULE_OUTPUT) type /ITETR/INV_S_EARULES_OUT .
  methods GET_EPRRECEIPT_RULE
    importing
      !IV_RULE_TYPE type /ITETR/INV_E_RULET
      !IS_RULE_INPUT type /ITETR/INV_S_EMMRULES_IN
    returning
      value(RS_RULE_OUTPUT) type /ITETR/INV_S_EMMRULES_OUT .
PRIVATE SECTION.

  .

  METHODS set_initial_data
    IMPORTING
      !iv_bukrs TYPE bukrs .
ENDCLASS.



CLASS /ITETR/CL_INVOICE_OPERATIONS IMPLEMENTATION.


  METHOD factory.
    DATA: lx_exception           TYPE REF TO /itetr/cx_regulative_exception,
          lx_create_object_error TYPE REF TO cx_sy_create_object_error,
          lv_reference_class     TYPE /itetr/com_refcl-refcl.
    SELECT SINGLE refcl
      INTO lv_reference_class
      FROM /itetr/com_refcl
      WHERE bukrs = iv_company
        AND prncl = '/ITETR/CL_INVOICE_OPERATIONS'. "AS 01.01.2022

    IF lv_reference_class IS INITIAL.
      lv_reference_class = '/ITETR/CL_INVOICE_OPERATIONS'.
    ENDIF.

    TRY .
        CREATE OBJECT ro_instance TYPE (lv_reference_class).
        ro_instance->set_initial_data( iv_company ).
      CATCH cx_sy_create_object_error INTO lx_create_object_error.
        lx_exception = /itetr/cx_regulative_exception=>create_by_exception( lx_create_object_error ).
        RAISE EXCEPTION lx_exception.
    ENDTRY.

  ENDMETHOD.


  METHOD get_accounting_onetime_tax.
    DATA : ls_parameters LIKE LINE OF mt_parameters.
    FIELD-SYMBOLS <fs_val> TYPE any.

    ev_taxid = is_bsec-stcd2.
    ev_tax_office = is_bsec-stcd1.

    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_ID'.

    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE is_bsec TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
          ev_taxid = <fs_val>.
      ENDIF.
    ENDIF.

    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_OFFICE'.
    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE is_bsec TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
          ev_tax_office = <fs_val>.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD get_agent.
    IF iv_gsber IS NOT INITIAL.
      SELECT SINGLE agent
        FROM /itetr/com_cmpbi
        INTO rv_agent
        WHERE bukrs = iv_bukrs
          AND agent = iv_gsber.
    ENDIF.

    IF rv_agent IS INITIAL AND iv_werks IS NOT INITIAL.
      SELECT SINGLE agent
        FROM /itetr/com_cmpbi
        INTO rv_agent
        WHERE bukrs = iv_bukrs
          AND agent = iv_werks.
    ENDIF.
  ENDMETHOD.


  METHOD get_billing_onetime_tax.
    DATA : ls_parameters LIKE LINE OF mt_parameters.
    FIELD-SYMBOLS <fs_val> TYPE any.

    ev_taxid = is_vbpa-stcd2.
    ev_tax_office = is_vbpa-stcd1.


    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_ID'.

    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE is_vbpa TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        IF <fs_val> IS NOT INITIAL.
          ev_taxid = <fs_val>.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_OFFICE'.
    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE is_vbpa TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        IF <fs_val> IS NOT INITIAL.
          ev_tax_office = <fs_val>.
        ENDIF.
      ENDIF.
    ENDIF.


    IF iv_tax_id_fname IS NOT INITIAL.
      ASSIGN COMPONENT iv_tax_id_fname OF STRUCTURE is_vbpa TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        IF <fs_val> IS NOT INITIAL.
          ev_taxid = <fs_val>.
        ENDIF.
      ENDIF.
    ENDIF.

    IF iv_tax_office_fname IS NOT INITIAL.
      ASSIGN COMPONENT iv_tax_office_fname OF STRUCTURE is_vbpa TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        IF <fs_val> IS NOT INITIAL.
          ev_tax_office = <fs_val>.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_customer_taxid.
    "29.11.2023 - stcd2 veya stcd3ten biri mükellef ise onu al, ikisi de değilse direk stcd2
***    DATA lv_stcd3 TYPE kna1-stcd3.
***    SELECT SINGLE adrnr stcd1 stcd2 stcd3
***      FROM kna1
***      INTO (ev_adrnr, ev_tax_office , ev_taxid, lv_stcd3)
***      WHERE kunnr = iv_kunnr.
***    IF ev_taxid IS INITIAL AND lv_stcd3 IS NOT INITIAL.
***      ev_taxid = lv_stcd3.
***    ENDIF.
    FIELD-SYMBOLS : <fs_val> TYPE any.
    TYPES: BEGIN OF ty_taxp,
             taxid TYPE /itetr/inv_taxp-taxid,
           END OF ty_taxp.
    DATA: lv_stcd3b     TYPE kna1-stcd3,
          lv_stcd3      TYPE kna1-stcd2,
          lv_stcd2      TYPE kna1-stcd2,
          lv_stcd4      TYPE kna1-stcd4,
          ls_kna1       TYPE kna1,
          lt_taxp       TYPE SORTED TABLE OF ty_taxp WITH UNIQUE KEY taxid,
          ls_taxp       TYPE ty_taxp,
          ls_parameters TYPE /itetr/inv_eicp,
          lv_len        TYPE i,
          lv_taxid      TYPE string.
    CASE iv_koart.
      WHEN 'D'.
        SELECT SINGLE adrnr stcd1 stcd2 stcd3 stcd4 stceg name1 name2 land1
          FROM kna1
*      INTO (ev_adrnr, ev_tax_office , lv_stcd2, lv_stcd3b)
           INTO CORRESPONDING FIELDS OF ls_kna1
          WHERE kunnr = iv_kunnr.
      WHEN 'K'.
        SELECT SINGLE adrnr stcd1 stcd2 stcd3 stcd4 stceg name1 name2 land1
          FROM lfa1
*      INTO (ev_adrnr, ev_tax_office , lv_stcd2, lv_stcd3b)
           INTO CORRESPONDING FIELDS OF ls_kna1
          WHERE lifnr = iv_kunnr.
    ENDCASE.
    lv_stcd3      = ls_kna1-stcd3.
    ev_adrnr      = ls_kna1-adrnr.
    ev_tax_office = ls_kna1-stcd1.
    lv_stcd2      = ls_kna1-stcd2.
    lv_stcd4      = ls_kna1-stcd4."gkadioglu

    "VKN format kontrolu
    IF ls_kna1-land1 EQ 'TR'.
      "STCD2 kontrolu
      CLEAR:lv_len,lv_taxid .
      lv_taxid  = lv_stcd2.
      lv_len = strlen( lv_taxid ).
      IF lv_len NE 10 AND lv_len NE 11 .
        CLEAR:lv_stcd2.
      ELSEIF lv_taxid  CN '0123456789'.
        CLEAR:lv_stcd2.
      ENDIF.

      "STCD3 kontrolu
      CLEAR:lv_len,lv_taxid .
      lv_taxid  = lv_stcd3.
      lv_len = strlen( lv_taxid ).
      IF lv_len NE 10 AND lv_len NE 11 .
        CLEAR:lv_stcd3.
      ELSEIF  lv_taxid  CN '0123456789'.
        CLEAR:lv_stcd3.
      ENDIF.

      "STCD4 kontrolu
      CLEAR:lv_len,lv_taxid .
      lv_taxid  = lv_stcd4.
      lv_len = strlen( lv_taxid ).
      IF lv_len NE 10 AND lv_len NE 11 .
        CLEAR:lv_stcd4.
      ELSEIF  lv_taxid  CN '0123456789'.
        CLEAR:lv_stcd4.
      ENDIF.
    ENDIF.



    SELECT DISTINCT taxid
      FROM /itetr/inv_taxp
      INTO TABLE lt_taxp
      WHERE taxid IN ( lv_stcd2, lv_stcd3 , lv_stcd4 ).

    READ TABLE lt_taxp INTO ls_taxp WITH KEY taxid = lv_stcd2.

    IF sy-subrc EQ 0.
      ev_taxid = lv_stcd2.
    ELSE.
      READ TABLE lt_taxp INTO ls_taxp WITH KEY taxid = lv_stcd3.
      IF sy-subrc EQ 0.
        ev_taxid = lv_stcd3.
      ELSE.
****        ev_taxid = lv_stcd2.
        READ TABLE lt_taxp INTO ls_taxp WITH KEY taxid = lv_stcd4."gkadioglu
        IF sy-subrc EQ 0.
          ev_taxid = lv_stcd4.
        ELSE.
          ev_taxid = lv_stcd2.
        ENDIF.
      ENDIF.
    ENDIF.

****    IF ev_taxid IS INITIAL.
****      ev_taxid = lv_stcd3.
****    ENDIF.

    IF ev_taxid IS INITIAL.
      IF lv_stcd2 IS NOT INITIAL.
        ev_taxid = lv_stcd2.
      ELSEIF lv_stcd3 IS NOT INITIAL.
        ev_taxid = lv_stcd3.
      ELSEIF lv_stcd4 IS NOT INITIAL.
        ev_taxid = lv_stcd4.
      ENDIF.
    ENDIF.


    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_ID'.

    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE ls_kna1 TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        IF <fs_val> IS NOT INITIAL.
          ev_taxid = <fs_val>.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_OFFICE'.
    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE ls_kna1 TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        IF <fs_val> IS NOT INITIAL.
          ev_tax_office = <fs_val>.
        ENDIF.
      ENDIF.
    ENDIF.

    IF iv_tax_id_fname IS NOT INITIAL.
      ASSIGN COMPONENT iv_tax_id_fname OF STRUCTURE ls_kna1 TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        ev_taxid = <fs_val>.
      ENDIF.
    ENDIF.

    IF iv_tax_office_fname IS NOT INITIAL.
      ASSIGN COMPONENT iv_tax_office_fname OF STRUCTURE ls_kna1 TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        ev_tax_office = <fs_val>.
      ENDIF.
    ENDIF.

    CONCATENATE ls_kna1-name1 ls_kna1-name2 INTO ev_name SEPARATED BY space.
    CONDENSE ev_name.

  ENDMETHOD.


  METHOD get_earchive_rule.
    DATA: lt_agent TYPE RANGE OF /itetr/com_e_agent,
          lt_awtyp TYPE RANGE OF awtyp,
          lt_vkorg TYPE RANGE OF vkorg,
          lt_vtweg TYPE RANGE OF vtweg,
          lt_werks TYPE RANGE OF werks_d,
          lt_pstyv TYPE RANGE OF pstyv,
          lt_ktgrd TYPE RANGE OF ktgrd,
          lt_kalks TYPE RANGE OF kalks,
          lt_kalsm TYPE RANGE OF kalsmasd,
          lt_invty TYPE RANGE OF /itetr/inv_e_invty,
          lt_sddty TYPE RANGE OF fkart,
          lt_mmdty TYPE RANGE OF blart,
          lt_fidty TYPE RANGE OF blart,
          lt_kunnr TYPE RANGE OF kunnr,
          lt_lifnr TYPE RANGE OF lifnr,
          ls_range TYPE rsis_s_range,
          ls_rule  TYPE /itetr/inv_earu. ""AS Tip uyuşmazlığından hata oluyordu değiştirildi.
*          ls_rule  TYPE /itetr/inv_eiru.

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

    SORT: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_pstyv, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_ktgrd, lt_kalks, lt_kalsm.
    DELETE ADJACENT DUPLICATES FROM: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_pstyv, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_ktgrd, lt_kalks, lt_kalsm.

    SELECT *
      FROM /itetr/inv_earu
      INTO ls_rule
      WHERE bukrs EQ mv_company_code
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
      ORDER BY  agent   DESCENDING
                awtyp   DESCENDING
                vkorg   DESCENDING
                vtweg   DESCENDING
                werks   DESCENDING
                ityin   DESCENDING
                sddty   DESCENDING
                mmdty   DESCENDING
                fidty   DESCENDING
                kunnr   DESCENDING
                lifnr   DESCENDING
                pstyv   DESCENDING
                ktgrd   DESCENDING
                kalks   DESCENDING
                kalsm   DESCENDING.
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
      EXIT.
    ENDSELECT.
  ENDMETHOD.


  METHOD get_einvoice_rule.
    DATA: lt_agent TYPE RANGE OF /itetr/com_e_agent,
          lt_awtyp TYPE RANGE OF awtyp,
          lt_vkorg TYPE RANGE OF vkorg,
          lt_vtweg TYPE RANGE OF vtweg,
          lt_werks TYPE RANGE OF werks_d,
          lt_pstyv TYPE RANGE OF pstyv,
          lt_ktgrd TYPE RANGE OF ktgrd,
          lt_kalks TYPE RANGE OF kalks,
          lt_kalsm TYPE RANGE OF kalsmasd,
          lt_invty TYPE RANGE OF /itetr/inv_e_invty,
          lt_sddty TYPE RANGE OF fkart,
          lt_mmdty TYPE RANGE OF blart,
          lt_fidty TYPE RANGE OF blart,
          lt_kunnr TYPE RANGE OF kunnr,
          lt_lifnr TYPE RANGE OF lifnr,
          lt_prfid TYPE RANGE OF /itetr/inv_e_prfid,
          ls_range TYPE rsis_s_range,
          ls_rule  TYPE /itetr/inv_eiru.

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
    APPEND ls_range TO lt_pstyv.
    ls_range-low = is_rule_input-pstyv.
    APPEND ls_range TO lt_pstyv.

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

    SORT: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_pstyv, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_prfid, lt_ktgrd, lt_kalks, lt_kalsm.
    DELETE ADJACENT DUPLICATES FROM: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_pstyv, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr, lt_prfid, lt_ktgrd, lt_kalks, lt_kalsm.

    SELECT *
      FROM /itetr/inv_eiru
      INTO ls_rule
      WHERE bukrs EQ mv_company_code
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
      ORDER BY  agent   DESCENDING
                awtyp   DESCENDING
                vkorg   DESCENDING
                vtweg   DESCENDING
                werks   DESCENDING
                ityin   DESCENDING
                sddty   DESCENDING
                mmdty   DESCENDING
                fidty   DESCENDING
                pidin   DESCENDING
                kunnr   DESCENDING
                lifnr   DESCENDING
                pstyv   DESCENDING
                ktgrd   DESCENDING
                kalks   DESCENDING
                kalsm   DESCENDING.
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
      MOVE-CORRESPONDING ls_rule TO rs_rule_output.
      EXIT.
    ENDSELECT.
  ENDMETHOD.


  METHOD get_eprreceipt_rule.
    DATA: lt_agent TYPE RANGE OF /itetr/com_e_agent,
          lt_awtyp TYPE RANGE OF awtyp,
          lt_vkorg TYPE RANGE OF vkorg,
          lt_vtweg TYPE RANGE OF vtweg,
          lt_werks TYPE RANGE OF werks_d,
          lt_invty TYPE RANGE OF /itetr/inv_e_invty,
          lt_sddty TYPE RANGE OF fkart,
          lt_mmdty TYPE RANGE OF blart,
          lt_fidty TYPE RANGE OF blart,
          lt_kunnr TYPE RANGE OF kunnr,
          lt_lifnr TYPE RANGE OF lifnr,
          ls_range TYPE rsis_s_range,
          ls_rule  TYPE /itetr/inv_emru.

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

    SORT: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr.
    DELETE ADJACENT DUPLICATES FROM: lt_agent, lt_awtyp, lt_vkorg, lt_vtweg, lt_werks, lt_invty, lt_sddty, lt_mmdty, lt_fidty, lt_kunnr, lt_lifnr.

    SELECT *
      FROM /itetr/inv_emru
      INTO ls_rule
      WHERE bukrs EQ mv_company_code
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
      ORDER BY  agent   DESCENDING
                awtyp   DESCENDING
                vkorg   DESCENDING
                vtweg   DESCENDING
                werks   DESCENDING
                ityin   DESCENDING
                sddty   DESCENDING
                mmdty   DESCENDING
                fidty   DESCENDING
                kunnr   DESCENDING
                lifnr   DESCENDING.
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
      MOVE-CORRESPONDING ls_rule TO rs_rule_output.
      EXIT.
    ENDSELECT.
  ENDMETHOD.


  METHOD get_incoming_archives.
    DATA: lv_valid_from       TYPE datab,
          lv_valid_to         TYPE datbi,
          lo_einvoice_service TYPE REF TO /itetr/cl_earchive_ws,
          lv_invii            TYPE c LENGTH 50,
          lt_invui            TYPE TABLE OF /itetr/com_e_duich,
          lx_etr_exception    TYPE REF TO /itetr/cx_regulative_exception,
          lv_subject          TYPE so_obj_des,
          lt_mail_list        TYPE /itetr/inv_tt_inv_mail_list,
          lt_log              TYPE /itetr/com_tt_logs,
          lv_count            TYPE i,
          lv_invoice_content  TYPE xstring,
          lv_message          TYPE bapi_msg,
          lx_exception        TYPE REF TO /itetr/cx_regulative_exception.
    FIELD-SYMBOLS: <ls_mail_list>  TYPE /itetr/inv_s_inv_mail_list,
                   <ls_attachment> TYPE /itetr/com_s_files,
                   <ls_list>       TYPE /itetr/inv_icinv,
                   <ls_log>        TYPE /itetr/com_s_logs.

    SELECT SINGLE datab datbi
        FROM /itetr/inv_einp
        INTO (lv_valid_from,lv_valid_to)
        WHERE bukrs = mv_company_code.
    IF iv_date_from IS NOT INITIAL OR iv_date_to IS NOT INITIAL.
      CHECK iv_date_from BETWEEN lv_valid_from AND lv_valid_to
         OR iv_date_to BETWEEN lv_valid_from AND lv_valid_to.
    ELSE.
      CHECK sy-datum BETWEEN lv_valid_from AND lv_valid_to.
    ENDIF.

        lo_einvoice_service = /itetr/cl_earchive_ws=>factory( iv_company = mv_company_code ).

        rt_list = lo_einvoice_service->get_incoming_archives(
          EXPORTING
            iv_date_from       = iv_date_from
            iv_date_to         = iv_date_to
          IMPORTING
            ev_message         = lv_message
        ).


    IF rt_list IS NOT INITIAL.
      LOOP AT rt_list ASSIGNING <ls_list>.
        APPEND INITIAL LINE TO lt_log ASSIGNING <ls_log>.
        <ls_log>-docui = <ls_list>-docui.
        <ls_log>-datum = sy-datum.
        <ls_log>-uzeit = sy-uzeit.
        <ls_log>-uname = sy-uname.
        <ls_log>-logcd = /itetr/cl_regulative_logs=>mc_log_codes-saved.
        <ls_log>-logtx = lv_message.
      ENDLOOP.

      "write logs
      /itetr/cl_regulative_logs=>create( it_logs = lt_log ).
    ENDIF.

    IF lv_message IS NOT INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.
  ENDMETHOD.


  METHOD get_incoming_invoices.
    DATA: lv_valid_from       TYPE datab,
          lv_valid_to         TYPE datbi,
          lo_einvoice_service TYPE REF TO /itetr/cl_einvoice_ws,
          lv_invii            TYPE c LENGTH 50,
          lt_invui            TYPE TABLE OF /itetr/com_e_duich,
          lx_etr_exception    TYPE REF TO /itetr/cx_regulative_exception,
          lv_subject          TYPE so_obj_des,
          lt_mail_list        TYPE /itetr/inv_tt_inv_mail_list,
          lt_log              TYPE /itetr/com_tt_logs,
          lv_count            TYPE i,
          lv_invoice_content  TYPE xstring,
          lv_message          TYPE bapi_msg,
          lx_exception        TYPE REF TO /itetr/cx_regulative_exception,
          lt_mail       TYPE TABLE OF /itetr/inv_eiem. "gkadioglu
    FIELD-SYMBOLS: <ls_mail_list>  TYPE /itetr/inv_s_inv_mail_list,
                   <ls_attachment> TYPE /itetr/com_s_files,
                   <ls_list>       TYPE /itetr/inv_icinv,
                   <ls_log>        TYPE /itetr/com_s_logs.

    SELECT SINGLE datab datbi
        FROM /itetr/inv_einp
        INTO (lv_valid_from,lv_valid_to)
        WHERE bukrs = mv_company_code.
    IF sy-subrc <> 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '001' ).
      RAISE EXCEPTION lx_exception.
    ELSEIF iv_date_from IS NOT INITIAL OR iv_date_to IS NOT INITIAL.
      CHECK iv_date_from BETWEEN lv_valid_from AND lv_valid_to
         OR iv_date_to BETWEEN lv_valid_from AND lv_valid_to.
    ELSE.
      CHECK sy-datum BETWEEN lv_valid_from AND lv_valid_to.
    ENDIF.

    " creating instance
    lo_einvoice_service = /itetr/cl_einvoice_ws=>factory( iv_company = mv_company_code ).
    " getting invoices
    rt_list = lo_einvoice_service->get_incoming_invoices(
      EXPORTING
        iv_date_from       = iv_date_from
        iv_date_to         = iv_date_to
      IMPORTING
        ev_message         = lv_message
    ).

    DELETE rt_list WHERE docui IS INITIAL.

    IF rt_list IS NOT INITIAL.
      lv_subject = TEXT-007.
      LOOP AT rt_list ASSIGNING <ls_list>.
        APPEND INITIAL LINE TO lt_mail_list ASSIGNING <ls_mail_list>.
        MOVE-CORRESPONDING <ls_list> TO <ls_mail_list>.
      ENDLOOP.
      IF rt_list IS NOT INITIAL.
        SELECT *
         INTO CORRESPONDING FIELDS OF TABLE  lt_mail
         FROM /itetr/inv_eiem
         WHERE emtim = '1'                AND
               bukrs = mv_company_code.
        IF lt_mail[] IS NOT INITIAL.

          LOOP AT lt_mail_list ASSIGNING <ls_mail_list>.
            CLEAR lv_invoice_content.
            CALL FUNCTION '/ITETR/INV_INCINV_DOWNLOAD'
              EXPORTING
                iv_document_uid = <ls_mail_list>-docui
                iv_content_type = 'PDF'
              IMPORTING
                ev_document     = lv_invoice_content.
            CHECK lv_invoice_content IS NOT INITIAL.
            APPEND INITIAL LINE TO <ls_mail_list>-attch ASSIGNING <ls_attachment>.
            <ls_attachment>-mime_code = 'application/pdf'.
            <ls_attachment>-content = lv_invoice_content.
            <ls_attachment>-format = 'PDF'.
            CONCATENATE <ls_mail_list>-invno '-' <ls_mail_list>-invui '.pdf' INTO <ls_attachment>-filename.
          ENDLOOP.

          CALL FUNCTION '/ITETR/INV_MAIL_INVOICES'
            EXPORTING
              iv_company_code = mv_company_code
              iv_email_time   = '1'
              iv_subject      = lv_subject
              it_invoices     = lt_mail_list.
        ENDIF.
      ENDIF.


      LOOP AT rt_list ASSIGNING <ls_list>.
        APPEND INITIAL LINE TO lt_log ASSIGNING <ls_log>.
        <ls_log>-docui = <ls_list>-docui.
        <ls_log>-datum = sy-datum.
        <ls_log>-uzeit = sy-uzeit.
        <ls_log>-uname = sy-uname.
        <ls_log>-logcd = /itetr/cl_regulative_logs=>mc_log_codes-saved.
        <ls_log>-logtx = lv_message.
      ENDLOOP.
    ENDIF.

    "write logs
    /itetr/cl_regulative_logs=>create( it_logs = lt_log ).

    IF lv_message IS NOT INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.
  ENDMETHOD.


  METHOD get_vendor_taxid.
***    DATA lv_stcd3 TYPE lfa1-stcd3.
***    SELECT SINGLE stcd1 stcd2 stcd3
***      FROM lfa1
***      INTO (ev_tax_office, ev_taxid, lv_stcd3)
***      WHERE lifnr = iv_lifnr.
***    IF ev_taxid IS INITIAL AND lv_stcd3 IS NOT INITIAL.
***      ev_taxid = lv_stcd3.
***    ENDIF.

    TYPES: BEGIN OF ty_taxp,
             taxid TYPE /itetr/inv_taxp-taxid,
           END OF ty_taxp.
    DATA: lv_stcd3b     TYPE lfa1-stcd3,
          lv_stcd3      TYPE lfa1-stcd2,
          lv_stcd4      TYPE lfa1-stcd4, "gkadioglu
          lv_stcd2      TYPE lfa1-stcd2,
          ls_lfa1       TYPE lfa1,
          lt_taxp       TYPE SORTED TABLE OF ty_taxp WITH UNIQUE KEY taxid,
          ls_taxp       TYPE ty_taxp,
          ls_parameters TYPE /itetr/inv_eicp,
          lv_len        TYPE i,
          lv_taxid      TYPE string.
    FIELD-SYMBOLS : <fs_val> TYPE any.


    SELECT SINGLE stcd1 stcd2 stcd3 stcd4 stceg land1
      FROM lfa1
*      INTO (ev_tax_office, lv_stcd2, lv_stcd3b)
      INTO CORRESPONDING FIELDS OF ls_lfa1
      WHERE lifnr = iv_lifnr.

*    lv_stcd3 = lv_stcd3b.
    lv_stcd3 = ls_lfa1-stcd3.
    lv_stcd4 = ls_lfa1-stcd4.
    ev_tax_office = ls_lfa1-stcd1.

    "VKN format kontrolu
    IF ls_lfa1-land1 EQ 'TR'.
      "STCD2 kontrolu
      CLEAR:lv_len,lv_taxid .
      lv_taxid  = ls_lfa1-stcd2.
      lv_len = strlen( lv_taxid ).
      IF lv_len NE 10 AND lv_len NE 11 .
        CLEAR:ls_lfa1-stcd2.
      ELSEIF lv_taxid  CN '0123456789'.
        CLEAR:ls_lfa1-stcd2.
      ENDIF.

      "STCD3 kontrolu
      CLEAR:lv_len,lv_taxid .
      lv_taxid  = lv_stcd3.
      lv_len = strlen( lv_taxid ).
      IF lv_len NE 10 AND lv_len NE 11 .
        CLEAR:lv_stcd3.
      ELSEIF  lv_taxid  CN '0123456789'.
        CLEAR:lv_stcd3.
      ENDIF.

      "STCD4 kontrolu
      CLEAR:lv_len,lv_taxid .
      lv_taxid  = lv_stcd4.
      lv_len = strlen( lv_taxid ).
      IF lv_len NE 10 AND lv_len NE 11 .
        CLEAR:lv_stcd4.
      ELSEIF  lv_taxid  CN '0123456789'.
        CLEAR:lv_stcd4.
      ENDIF.
    ENDIF.



    SELECT DISTINCT taxid
      FROM /itetr/inv_taxp
      INTO TABLE lt_taxp
*      WHERE taxid IN ( lv_stcd2, lv_stcd3 ).
      WHERE taxid IN ( ls_lfa1-stcd2, lv_stcd3, lv_stcd4 ).

    READ TABLE lt_taxp INTO ls_taxp WITH KEY taxid = ls_lfa1-stcd2.
    IF sy-subrc EQ 0.
      ev_taxid = ls_lfa1-stcd2.
    ELSE.
      READ TABLE lt_taxp INTO ls_taxp WITH KEY taxid = lv_stcd3.
      IF sy-subrc EQ 0.
        ev_taxid = lv_stcd3.
      ELSE.
***        ev_taxid = ls_lfa1-stcd2.
        READ TABLE lt_taxp INTO ls_taxp WITH KEY taxid = lv_stcd4.
        IF sy-subrc EQ 0.
          ev_taxid = lv_stcd4.
        ELSE.
          ev_taxid = ls_lfa1-stcd2.
        ENDIF.
      ENDIF.
    ENDIF.
***    IF ev_taxid IS INITIAL.
***      ev_taxid = lv_stcd3.
***    ENDIF.

    IF ev_taxid IS INITIAL.
      IF ls_lfa1-stcd2 IS NOT INITIAL.
        ev_taxid = ls_lfa1-stcd2.
      ELSEIF lv_stcd3 IS NOT INITIAL.
        ev_taxid = lv_stcd3.
      ELSEIF lv_stcd4 IS NOT INITIAL.
        ev_taxid = lv_stcd4.
      ENDIF.
    ENDIF.

    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_ID'.

    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE ls_lfa1 TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        ev_taxid = <fs_val>.
      ENDIF.
    ENDIF.

    READ TABLE mt_parameters INTO ls_parameters WITH KEY  cuspa = 'TAX_OFFICE'.
    IF sy-subrc IS INITIAL.
      ASSIGN COMPONENT ls_parameters-value OF STRUCTURE ls_lfa1 TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        ev_tax_office = <fs_val>.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD outgoing_invoice_save.
    DATA : lr_awtyp TYPE RANGE OF awtyp,
           ls_range TYPE rsis_s_range,
           lv_field TYPE text50.


    CONCATENATE iv_bukrs iv_belnr iv_gjahr iv_awtyp INTO lv_field.
    CALL FUNCTION 'ENQUEUE_/ITETR/ECOM_L001'
      EXPORTING
        field          = lv_field
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      EXIT.
    ELSE.
      ls_range-sign   = 'I'.
      ls_range-option = 'EQ'.

      IF iv_awtyp EQ 'BKPF' OR iv_awtyp EQ 'BKPFF' OR iv_awtyp EQ 'REACI' OR iv_awtyp EQ 'IDOC'. "Mevcut kurulu yerlerde hata almasın diye
        ls_range-low = 'BKPF'.
        APPEND ls_range TO lr_awtyp.
        ls_range-low = 'BKPFF'.
        APPEND ls_range TO lr_awtyp.
        ls_range-low = 'REACI'.
        APPEND ls_range TO lr_awtyp.
        ls_range-low = 'IDOC'.
        APPEND ls_range TO lr_awtyp.
      ELSE.
        ls_range-low = iv_awtyp.
        APPEND ls_range TO lr_awtyp.
      ENDIF.

      SELECT COUNT(*) "#EC CI_NOFIELD
        FROM /itetr/inv_oginv
        WHERE awtyp IN lr_awtyp
          AND bukrs EQ iv_bukrs
          AND belnr EQ iv_belnr
          AND gjahr EQ iv_gjahr.
      CHECK sy-subrc NE 0.

*      "Out of Scope E-Invoice and E-Archive
      SELECT COUNT(*) "#EC CI_NOFIELD
       FROM /itetr/inv_nosnd
       WHERE awtyp IN lr_awtyp
        AND bukrs EQ iv_bukrs
        AND belnr EQ iv_belnr
        AND gjahr EQ iv_gjahr.
      CHECK sy-subrc NE 0.


      CASE iv_awtyp.
        WHEN 'VBRK'.
          rs_document = outgoing_invoice_save_vbrk( iv_awtyp = iv_awtyp
                                                    iv_bukrs = iv_bukrs
                                                    iv_belnr = iv_belnr
                                                    iv_gjahr = iv_gjahr ).
        WHEN 'RMRP'.
          rs_document = outgoing_invoice_save_rmrp( iv_awtyp = iv_awtyp
                                                    iv_bukrs = iv_bukrs
                                                    iv_belnr = iv_belnr
                                                    iv_gjahr = iv_gjahr ).
        WHEN 'BKPF' OR 'BKPFF' OR 'REACI' OR 'IDOC'.
          rs_document = outgoing_invoice_save_bkpf( iv_awtyp = iv_awtyp
                                                    iv_bukrs = iv_bukrs
                                                    iv_belnr = iv_belnr
                                                    iv_gjahr = iv_gjahr ).
      ENDCASE.

*      CHECK rs_document IS NOT INITIAL.
      IF rs_document IS NOT INITIAL.
        INSERT /itetr/inv_oginv FROM rs_document.

        /itetr/cl_regulative_logs=>create_single_log(
          EXPORTING
            iv_log_code    = /itetr/cl_regulative_logs=>mc_log_codes-created
            iv_document_id = rs_document-docui
            iv_commit      = abap_true ).
      ENDIF.

      CALL FUNCTION 'DEQUEUE_/ITETR/ECOM_L001'
        EXPORTING
          field = lv_field.

    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_save_bkpf.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE /itetr/com_e_alias,
             regdt  TYPE budat,
             defal  TYPE xfeld,
             txpty  TYPE /itetr/com_e_txpty,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datab,
             datbi TYPE datbi,
             genid TYPE /itetr/com_e_genid,
             prfid TYPE /itetr/inv_e_prfid,
           END OF ty_company,
           BEGIN OF ty_tax_data,
             invty TYPE /itetr/inv_e_invty,
             taxex TYPE /itetr/com_e_taxex,
             taxty TYPE /itetr/com_e_taxty, " AS 30.12.2021
             taxrt TYPE /itetr/inv_e_taxrt,
           END OF ty_tax_data,
           BEGIN OF ty_bkpf,
             belnr     TYPE bkpf-belnr,
             gjahr     TYPE bkpf-gjahr,
             bldat     TYPE bkpf-bldat,
             cputm     TYPE bkpf-cputm,
             xreversal TYPE bkpf-xreversal,
             waers     TYPE bkpf-waers,
             hwaer     TYPE bkpf-hwaer,
             kursf     TYPE bkpf-kursf,
             blart     TYPE bkpf-blart,
             usnam     TYPE bkpf-usnam,
           END OF ty_bkpf,
           BEGIN OF ty_bseg,
             buzei TYPE bseg-buzei,
             shkzg TYPE bseg-shkzg,
             hkont TYPE bseg-hkont,
             lokkt TYPE bseg-lokkt, "staskan
             koart TYPE bseg-koart,
             kunnr TYPE bseg-kunnr,
             lifnr TYPE bseg-lifnr,
             wrbtr TYPE bseg-wrbtr,
             dmbtr TYPE bseg-dmbtr,
             mwskz TYPE bseg-mwskz,
             gsber TYPE bseg-gsber,
             werks TYPE bseg-werks,
           END OF ty_bseg.
    DATA: lt_bseg           TYPE STANDARD TABLE OF ty_bseg,
          ls_bseg_partner   TYPE ty_bseg,
          ls_bseg           TYPE ty_bseg,
          ls_bkpf           TYPE ty_bkpf,
          ls_tax_data       TYPE ty_tax_data,
          ls_company_data   TYPE ty_company,
          lt_taxpayer       TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer       TYPE ty_taxpayer,
          ls_document       TYPE /itetr/inv_oginv,
          ls_eirule_input   TYPE /itetr/inv_s_eirules_in,
          ls_eirule_output  TYPE /itetr/inv_s_eirules_out,
          ls_earule_input   TYPE /itetr/inv_s_earules_in,
          ls_earule_output  TYPE /itetr/inv_s_earules_out,
          ls_emmrule_input  TYPE /itetr/inv_s_emmrules_in,
          ls_emmrule_output TYPE /itetr/inv_s_emmrules_out,
          ls_fidty          TYPE /itetr/inv_fidt,
          lv_kalsm          TYPE t005-kalsm,
          ls_bsec           TYPE bsec,
          lt_tax_acc        TYPE STANDARD TABLE OF /itetr/inv_fiac,
          ls_tax_acc        TYPE /itetr/inv_fiac,
          ls_bseg_tax       TYPE ty_bseg,
          lv_insrt          TYPE /itetr/inv_e_insrt,
          lv_inv_type       TYPE /itetr/com_e_value. "gkadioglu
    DATA: lt_taxex_chck TYPE TABLE OF /itetr/inv_taxm-taxex,
          ls_taxex_chck LIKE LINE OF lt_taxex_chck,
          lv_intid      TYPE /itetr/com_e_intid.

    DO 1000 TIMES.
      SELECT SINGLE belnr
                    gjahr
                    bldat
                    cputm
                    xreversal
                    waers
                    hwaer
                    kursf
                    blart
                    usnam
        FROM bkpf
        INTO ls_bkpf
        WHERE bukrs = iv_bukrs
          AND belnr = iv_belnr
          AND gjahr = iv_gjahr.
      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO '0.1' SECONDS.
      ENDIF.
    ENDDO.
    CHECK ls_bkpf IS NOT INITIAL
      AND ls_bkpf-xreversal = ''.

    SELECT SINGLE *
      FROM /itetr/inv_fidt
      INTO ls_fidty
      WHERE blart = ls_bkpf-blart.
    CHECK ls_fidty-eichk = abap_true OR ls_fidty-eachk = abap_true OR ls_fidty-emchk = abap_true.

    SELECT buzei shkzg hkont lokkt koart kunnr lifnr wrbtr dmbtr mwskz gsber werks
      FROM bseg
      INTO TABLE lt_bseg
      WHERE bukrs = iv_bukrs
        AND belnr = iv_belnr
        AND gjahr = iv_gjahr.

    ls_document-waers = ls_bkpf-waers.
    LOOP AT lt_bseg INTO ls_bseg_partner WHERE ( koart = 'K' OR koart = 'D' ) AND shkzg = 'S'.
      IF ls_bseg_partner-wrbtr IS INITIAL AND ls_bseg_partner-dmbtr IS NOT INITIAL.
        ls_bseg_partner-wrbtr = ls_bseg_partner-dmbtr.
        ls_document-waers = ls_bkpf-hwaer.
        ls_document-kursf = 1.
      ENDIF.
      ADD ls_bseg_partner-wrbtr TO ls_document-wrbtr.

*      ls_document-werks = ls_bseg_partner-werks.
      ls_document-gsber = ls_bseg_partner-gsber.
      ls_document-kunnr = ls_bseg_partner-kunnr.
      ls_document-lifnr = ls_bseg_partner-lifnr.
    ENDLOOP.
    CHECK sy-subrc IS INITIAL.
    READ TABLE lt_bseg INTO ls_bseg WITH KEY koart = 'S'
                                             shkzg = 'H'.
    CHECK sy-subrc IS INITIAL.

    SELECT SINGLE *
      FROM bsec
      INTO ls_bsec
      WHERE bukrs = iv_bukrs
        AND belnr = iv_belnr
        AND gjahr = iv_gjahr.

    get_accounting_onetime_tax(
      EXPORTING
        is_bsec  = ls_bsec
      IMPORTING
        ev_taxid = ls_document-taxid ).

    IF ls_document-taxid IS INITIAL AND ls_bseg_partner-kunnr IS NOT INITIAL.
      get_customer_taxid(
        EXPORTING
          iv_kunnr = ls_bseg_partner-kunnr
        IMPORTING
          ev_taxid = ls_document-taxid ).
    ELSEIF ls_document-taxid IS INITIAL AND ls_bseg_partner-lifnr IS NOT INITIAL.
      get_vendor_taxid(
        EXPORTING
          iv_lifnr = ls_bseg_partner-lifnr
        IMPORTING
          ev_taxid = ls_document-taxid ).
    ENDIF.

    ls_document-bldat   = ls_bkpf-bldat.
    ls_document-doctype = ls_bkpf-blart.
    ls_document-agent = get_agent( iv_bukrs = iv_bukrs
                                   iv_gsber = ls_bseg_partner-gsber
                                   iv_werks = ls_bseg-werks
                                   iv_awtyp = iv_awtyp
                                   iv_belnr = iv_belnr
                                   iv_gjahr = iv_gjahr ).
    ls_document-werks = ls_bseg-werks.

    ls_eirule_input-agent = ls_document-agent.
    ls_eirule_input-awtyp = iv_awtyp.
    ls_eirule_input-fidty = ls_bkpf-blart.
    ls_eirule_input-kunnr = ls_bseg_partner-kunnr.
    ls_eirule_input-lifnr = ls_bseg_partner-lifnr.
    ls_eirule_input-werks = ls_bseg-werks.
    MOVE-CORRESPONDING ls_eirule_input TO ls_earule_input.

    "check id e-invoice
    IF ls_fidty-eichk = abap_true.
      SELECT SINGLE datab datbi genid prfid
        FROM /itetr/inv_einp
        INTO ls_company_data
        WHERE bukrs = iv_bukrs.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
      ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'P'
                                            is_rule_input  = ls_eirule_input ).
      IF ls_eirule_output IS NOT INITIAL.
        ls_document-prfid = ls_eirule_output-pidou.
        ls_document-invty = ls_eirule_output-ityou.
        ls_document-taxex = ls_eirule_output-taxex.
      ENDIF.
    ENDIF.

    IF ls_document-taxid IS NOT INITIAL.
      " check if partner is registered
      SELECT aliass regdt defal txpty
        FROM /itetr/inv_taxp
        INTO TABLE lt_taxpayer
        WHERE taxid = ls_document-taxid
          AND regdt <= ls_document-bldat.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.

        IF ls_taxpayer-txpty EQ 'KAMU'.
          ls_document-prfid = 'KAMU'.
        ENDIF.

        IF ls_document-prfid IS INITIAL.
          IF ls_company_data-prfid IS INITIAL.
            ls_company_data-prfid = 'TEMEL'.
          ENDIF.
          ls_document-prfid = ls_company_data-prfid.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_taxpayer IS INITIAL AND ls_document-prfid NE 'IHRACAT' AND
       ls_document-prfid NE 'YOLCU' AND ( ls_fidty-eachk = abap_true OR ls_fidty-emchk = abap_true ).
      IF ls_fidty-eachk = abap_true.
        SELECT SINGLE datab datbi genid
          FROM /itetr/inv_earp
          INTO ls_company_data
          WHERE bukrs = iv_bukrs.
        CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

        ls_document-prfid = 'EARSIV'.
        ls_earule_output = get_earchive_rule( iv_rule_type   = 'P'
                                              is_rule_input  = ls_earule_input ).
        IF ls_earule_output IS NOT INITIAL.
          ls_document-invty = ls_earule_output-ityou.
          ls_document-taxex = ls_earule_output-taxex.
        ENDIF.
      ELSEIF ls_fidty-emchk = abap_true.
        SELECT SINGLE datab datbi genid
          FROM /itetr/inv_emmp
          INTO ls_company_data
          WHERE bukrs = iv_bukrs.
        CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
        ls_document-prfid = ls_document-invty = 'MUSTAHSIL'.
        IF sy-sysid = 'NP4'  AND strlen( ls_document-taxid ) = 10.
          CONCATENATE ls_document-taxid '1' INTO ls_document-taxid.
        ENDIF.
        CLEAR: ls_document-aliass.
        "no tax exemption is applied at producer receipts
      ENDIF.
    ENDIF.

    CHECK ls_document-prfid IS NOT INITIAL.

    "gkadioglu
    IF ls_document-prfid = 'EARSIV'.
      SELECT SINGLE value  FROM /itetr/inv_eacp INTO lv_inv_type WHERE bukrs = iv_bukrs AND cuspa = 'INVTYPE'.
    ELSEIF ls_document-prfid = 'MUSTAHSIL'.
      SELECT SINGLE value  FROM /itetr/inv_emcp INTO lv_inv_type WHERE bukrs = iv_bukrs AND cuspa = 'INVTYPE'.
    ELSE.
      SELECT SINGLE value  FROM /itetr/inv_eicp INTO lv_inv_type WHERE bukrs = iv_bukrs AND cuspa = 'INVTYPE'.
    ENDIF.

    SELECT *
      FROM /itetr/inv_fiac
      INTO TABLE lt_tax_acc
      WHERE accty IN ('O','I').
    SORT lt_tax_acc BY saknr.

    SELECT SINGLE t005~kalsm
      FROM t001
      LEFT OUTER JOIN t005
        ON t001~land1 = t005~land1
      INTO lv_kalsm
      WHERE t001~bukrs = iv_bukrs.
    DATA lv_hkont TYPE hkont .

    LOOP AT lt_bseg INTO ls_bseg_tax.
      CLEAR ls_tax_data.
      "-- Lokkt kontrolü STASKAN 24.12.2021
      lv_hkont = ls_bseg_tax-lokkt .
      IF  lv_hkont IS INITIAL .
        lv_hkont = ls_bseg_tax-hkont .
      ENDIF.

      SELECT SINGLE invty taxex taxty taxrt
        FROM /itetr/inv_taxm
        INTO ls_tax_data
        WHERE kalsm = lv_kalsm
          AND mwskz = ls_bseg_tax-mwskz.
      IF sy-subrc EQ 0 AND ls_tax_data-taxrt EQ '0'.
        ls_document-texex = abap_true.
        IF lv_inv_type EQ abap_true AND ls_document-invty NE 'YTBISTISNA'."gkadioglu
          ls_document-invty = 'ISTISNA'.
        ENDIF.
      ENDIF.

      READ TABLE lt_tax_acc WITH KEY saknr = lv_hkont BINARY SEARCH TRANSPORTING NO FIELDS.
      CHECK sy-subrc = 0 OR ls_document-prfid = 'MUSTAHSIL'.

      IF ls_bseg_tax-wrbtr IS INITIAL AND ls_bseg_tax-dmbtr IS NOT INITIAL.
        ls_bseg_tax-wrbtr = ls_bseg_tax-dmbtr.
      ENDIF.
      IF ls_bseg_tax-shkzg = 'S'.
        ls_bseg_tax-wrbtr = ls_bseg_tax-wrbtr * -1.
      ENDIF.
      ADD ls_bseg_tax-wrbtr TO ls_document-fwste.
      IF ls_bseg_tax-wrbtr IS INITIAL.
        ls_document-texex = abap_true.
      ENDIF.
      IF ls_document-invty IS INITIAL AND ls_bseg_tax-mwskz IS NOT INITIAL AND ls_tax_data IS NOT INITIAL.
        ls_document-invty = ls_tax_data-invty.
      ENDIF.
      IF ls_document-taxex IS INITIAL AND ls_bseg_tax-mwskz IS NOT INITIAL AND ls_tax_data IS NOT INITIAL.
        ls_document-taxex = ls_tax_data-taxex.
        ls_taxex_chck = ls_tax_data-taxex.
        COLLECT ls_taxex_chck INTO lt_taxex_chck.
      ENDIF.
      IF ls_document-taxty IS INITIAL.
        ls_document-taxty = ls_tax_data-taxty. " AS 30.12.2021
      ENDIF.
      IF ls_document-prfid = 'MUSTAHSIL'.
        ls_document-taxty = '0003'.
      ENDIF.
    ENDLOOP.

    DATA: lv_taxex_count TYPE i .
    DESCRIBE TABLE lt_taxex_chck LINES lv_taxex_count.

    IF lv_taxex_count GT 1.
      CLEAR ls_document-taxex.
    ENDIF.

    IF ls_document-fwste IS INITIAL AND ls_document-prfid <> 'MUSTAHSIL'.
      ls_document-texex = abap_true.
    ENDIF.

    IF ls_document-invty IS INITIAL AND ls_bseg_partner-mwskz IS NOT INITIAL.
      SELECT SINGLE invty taxex
        FROM /itetr/inv_taxm
        INTO ls_tax_data
        WHERE kalsm = lv_kalsm
          AND mwskz = ls_bseg_partner-mwskz.
      IF sy-subrc = 0.
        ls_document-invty = ls_tax_data-invty.
        ls_document-taxex = ls_tax_data-taxex.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
        ls_document-invui = /itetr/cl_regulative_common=>generate_document_uuid_c36( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-ernam = ls_bkpf-usnam.
    ls_document-uzeit = ls_bkpf-cputm.
    IF ls_document-kursf IS INITIAL.
      IF ls_bkpf-kursf IS NOT INITIAL.
        ls_document-kursf = ls_bkpf-kursf.
      ELSEIF ls_bkpf-waers = ls_bkpf-hwaer.
        ls_document-kursf = 1.
      ENDIF.
    ENDIF.
    ls_document-aprvd = abap_true.

    DATA: lv_add_key_xslt	 TYPE /itetr/com_e_add_key,
          lv_add_key_sernr TYPE /itetr/com_e_add_key.

    set_specific_rules_exit( IMPORTING ev_add_key_xslt  = lv_add_key_xslt
                                       ev_add_key_sernr = lv_add_key_sernr
                             CHANGING is_document = ls_document ).


    CASE ls_document-prfid.
      WHEN 'EARSIV'.
        ls_earule_input-ityin = ls_document-invty.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_earule_output.
          ls_earule_output = get_earchive_rule( iv_rule_type   = 'S'
                                                is_rule_input  = ls_earule_input ).
          IF ls_earule_output IS NOT INITIAL AND lv_add_key_sernr IS INITIAL.
            ls_document-serpr = ls_earule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM /itetr/inv_easr
              INTO ls_document-serpr
              WHERE bukrs = iv_bukrs
                AND add_key = lv_add_key_sernr
                AND maisp = abap_true.
          ENDIF.
        ENDIF.

        CLEAR ls_earule_output.
        ls_earule_output = get_earchive_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_earule_input ).
        IF ls_earule_output IS NOT INITIAL AND lv_add_key_xslt IS INITIAL.
          ls_document-xsltt = ls_earule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM /itetr/inv_eaxs
            INTO ls_document-xsltt
            WHERE bukrs = iv_bukrs
              AND add_key = lv_add_key_xslt
              AND deflt = abap_true.
        ENDIF.

      WHEN 'MUSTAHSIL'.
        ls_emmrule_input-ityin = ls_document-invty.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_emmrule_output.
          ls_emmrule_output = get_eprreceipt_rule( iv_rule_type   = 'S'
                                                   is_rule_input  = ls_emmrule_input ).
          IF ls_emmrule_output IS NOT INITIAL AND lv_add_key_sernr IS INITIAL.
            ls_document-serpr = ls_emmrule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM /itetr/inv_emsr
              INTO ls_document-serpr
              WHERE bukrs = iv_bukrs
                AND add_key = lv_add_key_sernr
                AND maisp = abap_true.
          ENDIF.
        ENDIF.

        CLEAR ls_emmrule_output.
        ls_emmrule_output = get_eprreceipt_rule( iv_rule_type   = 'X'
                                                 is_rule_input  = ls_emmrule_input ).
        IF ls_emmrule_output IS NOT INITIAL AND lv_add_key_xslt IS INITIAL.
          ls_document-xsltt = ls_emmrule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM /itetr/inv_emxs
            INTO ls_document-xsltt
            WHERE bukrs = iv_bukrs
              AND add_key = lv_add_key_xslt
              AND deflt = abap_true.
        ENDIF.

      WHEN OTHERS.
        ls_eirule_input-ityin = ls_document-invty.
        ls_eirule_input-pidin = ls_document-prfid.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_eirule_output.
          ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'S'
                                                is_rule_input  = ls_eirule_input ).
          IF ls_eirule_output IS NOT INITIAL AND lv_add_key_sernr IS INITIAL.
            ls_document-serpr = ls_eirule_output-serpr.
          ELSE.
            CASE ls_document-prfid.
              WHEN 'IHRACAT'.
                lv_insrt = 'E'.
              WHEN 'YOLCU'.
                lv_insrt = 'T'.
              WHEN OTHERS.
                lv_insrt = 'D'.
            ENDCASE.
            SELECT SINGLE serpr
              FROM /itetr/inv_eisr
              INTO ls_document-serpr
              WHERE bukrs = iv_bukrs
                AND add_key = lv_add_key_sernr
                AND maisp = abap_true
                AND insrt = lv_insrt.
            IF sy-subrc NE 0.
              SELECT SINGLE serpr
                FROM /itetr/inv_eisr
                INTO ls_document-serpr
                WHERE bukrs = iv_bukrs
                  AND add_key = lv_add_key_sernr
                  AND maisp = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR ls_eirule_output.
        ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_eirule_input ).
        IF ls_eirule_output IS NOT INITIAL AND lv_add_key_xslt IS INITIAL.
          ls_document-xsltt = ls_eirule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM /itetr/inv_eixs
            INTO ls_document-xsltt
            WHERE bukrs = iv_bukrs
              AND add_key = lv_add_key_xslt
              AND deflt = abap_true.
        ENDIF.
    ENDCASE.


    rs_document = ls_document.
  ENDMETHOD.


  METHOD outgoing_invoice_save_rmrp.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE /itetr/com_e_alias,
             regdt  TYPE budat,
             defal  TYPE xfeld,
             txpty  TYPE /itetr/com_e_txpty,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datab,
             datbi TYPE datbi,
             genid TYPE /itetr/com_e_genid,
             prfid TYPE /itetr/inv_e_prfid,
           END OF ty_company,
           BEGIN OF ty_tax_data,
             invty TYPE /itetr/inv_e_invty,
             taxex TYPE /itetr/com_e_taxex,
             taxty TYPE /itetr/com_e_taxty,
             taxrt TYPE /itetr/inv_e_taxrt, "gkadioglu
           END OF ty_tax_data,
           BEGIN OF ty_rbkp,
             belnr  TYPE rbkp-belnr,
             gjahr  TYPE rbkp-gjahr,
             bldat  TYPE rbkp-bldat,
             lifnr  TYPE rbkp-lifnr,
             xrech  TYPE rbkp-xrech,
             stblg  TYPE rbkp-stblg,
             waers  TYPE rbkp-waers,
             cputm  TYPE rbkp-cputm,
             gsber  TYPE rbkp-gsber,
             rmwwr  TYPE rbkp-rmwwr,
             wmwst1 TYPE rbkp-wmwst1,
             mwskz1 TYPE rbkp-mwskz1,
             kursf  TYPE rbkp-kursf,
             blart  TYPE rbkp-blart,
             usnam  TYPE rbkp-usnam,
           END OF ty_rbkp,
           BEGIN OF ty_rseg,
             belnr TYPE rseg-belnr,
             gjahr TYPE rseg-gjahr,
             buzei TYPE rseg-buzei,
             werks TYPE rseg-werks,
             mwskz TYPE rseg-mwskz,
           END OF ty_rseg.
    DATA: ls_rseg          TYPE ty_rseg,
          lt_rseg          TYPE TABLE OF ty_rseg,
          lt_rseg_tmp      TYPE TABLE OF ty_rseg,
          ls_rbkp          TYPE ty_rbkp,
          ls_tax_data      TYPE ty_tax_data,
          ls_company_data  TYPE ty_company,
          lt_taxpayer      TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer      TYPE ty_taxpayer,
          ls_document      TYPE /itetr/inv_oginv,
          ls_eirule_input  TYPE /itetr/inv_s_eirules_in,
          ls_eirule_output TYPE /itetr/inv_s_eirules_out,
          ls_earule_input  TYPE /itetr/inv_s_earules_in,
          ls_earule_output TYPE /itetr/inv_s_earules_out,
          ls_muhattap      TYPE /itetr/com_othp,
          ls_mmdty         TYPE /itetr/inv_mmdt,
          lv_kalsm         TYPE t005-kalsm,
          lv_insrt         TYPE /itetr/inv_e_insrt,
          lv_inv_type      TYPE /itetr/com_e_value. "gkadioglu
    DATA: lt_taxex_chck TYPE TABLE OF /itetr/inv_taxm-taxex,
          ls_taxex_chck LIKE LINE OF lt_taxex_chck,
          lv_subrc_flag TYPE char1,
          lv_intid      TYPE /itetr/com_e_intid.

    DO 1000 TIMES.
      SELECT SINGLE belnr
                    gjahr
                    bldat
                    lifnr
                    xrech
                    stblg
                    waers
                    cputm
                    gsber
                    rmwwr
                    wmwst1
                    mwskz1
                    kursf
                    blart
                    usnam
        FROM rbkp
        INTO ls_rbkp
        WHERE belnr = iv_belnr
          AND gjahr = iv_gjahr.
      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO '0.1' SECONDS.
      ENDIF.
    ENDDO.
    CHECK ls_rbkp IS NOT INITIAL
      AND ls_rbkp-xrech = ''
      AND ls_rbkp-stblg = ''.

    SELECT SINGLE *
      FROM /itetr/inv_mmdt
      INTO ls_mmdty
      WHERE blart = ls_rbkp-blart.
    CHECK ls_mmdty-eichk = abap_true OR ls_mmdty-eachk = abap_true.

    get_vendor_taxid(
      EXPORTING
        iv_lifnr = ls_rbkp-lifnr
      IMPORTING
        ev_taxid = ls_document-taxid ).

*    SELECT SINGLE belnr gjahr buzei werks mwskz
*      FROM rseg
*      INTO ls_rseg
*      WHERE belnr = iv_belnr
*        AND gjahr = iv_gjahr.

    SELECT  belnr gjahr buzei werks mwskz
      FROM rseg
      INTO TABLE lt_rseg
      WHERE belnr = iv_belnr
        AND gjahr = iv_gjahr.

    SORT lt_rseg BY mwskz. "gkadioglu
    DELETE ADJACENT DUPLICATES FROM lt_rseg COMPARING mwskz.
    READ TABLE lt_rseg INTO ls_rseg INDEX 1.

    ls_document-bldat   = ls_rbkp-bldat.
    ls_document-doctype = ls_rbkp-blart.
    ls_document-agent = get_agent( iv_bukrs = iv_bukrs
                                   iv_gsber = ls_rbkp-gsber
                                   iv_werks = ls_rseg-werks
                                   iv_awtyp = iv_awtyp
                                   iv_belnr = iv_belnr
                                   iv_gjahr = iv_gjahr ).
    ls_document-werks = ls_rseg-werks.

    ls_eirule_input-agent = ls_document-agent.
    ls_eirule_input-awtyp = iv_awtyp.
    ls_eirule_input-mmdty = ls_rbkp-blart.
    ls_eirule_input-lifnr = ls_rbkp-lifnr.
    ls_eirule_input-werks = ls_rseg-werks.
    MOVE-CORRESPONDING ls_eirule_input TO ls_earule_input.

    "check id e-invoice
    IF ls_mmdty-eichk = abap_true.
      SELECT SINGLE datab datbi genid prfid
        FROM /itetr/inv_einp
        INTO ls_company_data
        WHERE bukrs = iv_bukrs.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
      ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'P'
                                            is_rule_input  = ls_eirule_input ).
      IF ls_eirule_output IS NOT INITIAL.
        ls_document-prfid = ls_eirule_output-pidou.
        ls_document-invty = ls_eirule_output-ityou.
        ls_document-taxex = ls_eirule_output-taxex.
      ENDIF.
    ENDIF.

    IF ls_document-taxid IS NOT INITIAL.
      " check if partner is registered
      SELECT aliass regdt defal txpty
        FROM /itetr/inv_taxp
        INTO TABLE lt_taxpayer
        WHERE taxid = ls_document-taxid
          AND regdt <= ls_document-bldat.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.

        IF ls_taxpayer-txpty EQ 'KAMU'.
          ls_document-prfid = 'KAMU'.
        ENDIF.

        IF ls_document-prfid IS INITIAL.
          IF ls_company_data-prfid IS INITIAL.
            ls_company_data-prfid = 'TEMEL'.
          ENDIF.
          ls_document-prfid = ls_company_data-prfid.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_taxpayer IS INITIAL AND ls_document-prfid NE 'IHRACAT' AND
       ls_document-prfid NE 'YOLCU' AND ls_mmdty-eachk = abap_true.
      SELECT SINGLE datab datbi genid
        FROM /itetr/inv_earp
        INTO ls_company_data
        WHERE bukrs = iv_bukrs.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

      ls_document-prfid = 'EARSIV'.
      ls_earule_output = get_earchive_rule( iv_rule_type   = 'P'
                                            is_rule_input  = ls_earule_input ).
      IF ls_earule_output IS NOT INITIAL.
        ls_document-invty = ls_earule_output-ityou.
        ls_document-taxex = ls_earule_output-taxex.
      ENDIF.
    ENDIF.

    "gkadioglu
    IF sy-subrc EQ 0.
      lv_subrc_flag = abap_true.
    ENDIF.
    IF ls_document-prfid = 'EARSIV'.
      SELECT SINGLE value  FROM /itetr/inv_eacp INTO lv_inv_type WHERE bukrs = iv_bukrs AND cuspa = 'INVTYPE'.
    ELSE.
      SELECT SINGLE value  FROM /itetr/inv_eicp INTO lv_inv_type WHERE bukrs = iv_bukrs AND cuspa = 'INVTYPE'.
    ENDIF.
    IF lv_subrc_flag = abap_true.
      sy-subrc = 0.
    ENDIF.

    CHECK ls_document-prfid IS NOT INITIAL.


    " determine invoice type
    LOOP AT lt_rseg INTO ls_rseg.
      IF ls_document-invty IS INITIAL OR ls_document-taxex IS INITIAL OR ls_document-taxty IS INITIAL.
        IF ls_rseg-mwskz IS INITIAL.
          SELECT SINGLE mwskz
            FROM rbtx
            INTO ls_rseg-mwskz
            WHERE belnr = iv_belnr
              AND gjahr = iv_gjahr
              AND buzei = ls_rseg-buzei.
        ENDIF.

        IF sy-subrc = 0 AND ls_rseg-mwskz IS NOT INITIAL.
          SELECT SINGLE t005~kalsm
            FROM t001
            LEFT OUTER JOIN t005
              ON t001~land1 = t005~land1
            INTO lv_kalsm
            WHERE t001~bukrs = iv_bukrs.
          SELECT SINGLE invty taxex taxty taxrt
            FROM /itetr/inv_taxm
            INTO ls_tax_data
            WHERE kalsm = lv_kalsm
              AND mwskz = ls_rseg-mwskz.
          IF sy-subrc = 0.
            IF ls_document-invty IS INITIAL.
              ls_document-invty = ls_tax_data-invty.
            ENDIF.
            IF ls_document-taxex IS INITIAL.
              ls_document-taxex = ls_tax_data-taxex.
              ls_taxex_chck = ls_tax_data-taxex.
              COLLECT ls_taxex_chck INTO lt_taxex_chck.
            ENDIF.
            IF ls_document-taxty IS INITIAL.
              ls_document-taxty = ls_tax_data-taxty.
            ENDIF.
            IF lv_inv_type EQ abap_true AND ls_tax_data-taxrt EQ 0 and ls_document-invty NE 'YTBISTISNA'.
              ls_document-invty = 'ISTISNA'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.



    DATA: lv_taxex_count TYPE i .
    DESCRIBE TABLE lt_taxex_chck LINES lv_taxex_count.

    IF lv_taxex_count GT 1.
      CLEAR ls_document-taxex.
    ENDIF.

    TRY .
        ls_document-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
        ls_document-invui = /itetr/cl_regulative_common=>generate_document_uuid_c36( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-lifnr = ls_rbkp-lifnr.
    ls_document-wrbtr = ls_rbkp-rmwwr.
    ls_document-fwste = ls_rbkp-wmwst1.
    ls_document-gsber = ls_rbkp-gsber.
    ls_document-kursf = ls_rbkp-kursf.
    ls_document-ernam = ls_rbkp-usnam.
    IF ls_document-fwste IS INITIAL.
      ls_document-texex = abap_true.
    ENDIF.
    ls_document-waers = ls_rbkp-waers.
    ls_document-aprvd = abap_true.

    DATA: lv_add_key_xslt	 TYPE /itetr/com_e_add_key,
          lv_add_key_sernr TYPE /itetr/com_e_add_key.

    set_specific_rules_exit( IMPORTING ev_add_key_xslt = lv_add_key_xslt
                                       ev_add_key_sernr = lv_add_key_sernr
                             CHANGING is_document = ls_document ).

    CASE ls_document-prfid.
      WHEN 'EARSIV'.
        ls_earule_input-ityin = ls_document-invty.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_earule_output.
          ls_earule_output = get_earchive_rule( iv_rule_type   = 'S'
                                                is_rule_input  = ls_earule_input ).
          IF ls_earule_output IS NOT INITIAL AND lv_add_key_sernr IS INITIAL.
            ls_document-serpr = ls_earule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM /itetr/inv_easr
              INTO ls_document-serpr
              WHERE bukrs = iv_bukrs
              AND add_key = lv_add_key_sernr
              AND maisp = abap_true.
          ENDIF.
        ENDIF.

        CLEAR ls_earule_output.
        ls_earule_output = get_earchive_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_earule_input ).
        IF ls_earule_output IS NOT INITIAL AND lv_add_key_xslt IS INITIAL..
          ls_document-xsltt = ls_earule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM /itetr/inv_eaxs
            INTO ls_document-xsltt
            WHERE bukrs = iv_bukrs
            AND add_key = lv_add_key_xslt
              AND deflt = abap_true.
        ENDIF.
      WHEN OTHERS.
        ls_eirule_input-ityin = ls_document-invty.
        ls_eirule_input-pidin = ls_document-prfid.
        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_eirule_output.
          ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'S'
                                                is_rule_input  = ls_eirule_input ).
          IF ls_eirule_output IS NOT INITIAL AND lv_add_key_sernr IS INITIAL..
            ls_document-serpr = ls_eirule_output-serpr.
          ELSE.
            CASE ls_document-prfid.
              WHEN 'IHRACAT'.
                lv_insrt = 'E'.
              WHEN 'YOLCU'.
                lv_insrt = 'T'.
              WHEN OTHERS.
                lv_insrt = 'D'.
            ENDCASE.
            SELECT SINGLE serpr
              FROM /itetr/inv_eisr
              INTO ls_document-serpr
              WHERE bukrs = iv_bukrs
                AND maisp = abap_true
                AND add_key = lv_add_key_sernr
                AND insrt = lv_insrt.
            IF sy-subrc NE 0.
              SELECT SINGLE serpr
                FROM /itetr/inv_eisr
                INTO ls_document-serpr
                WHERE bukrs = iv_bukrs
                  AND add_key = lv_add_key_sernr
                  AND maisp = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR ls_eirule_output.
        ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_eirule_input ).
        IF ls_eirule_output IS NOT INITIAL AND lv_add_key_xslt IS INITIAL..
          ls_document-xsltt = ls_eirule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM /itetr/inv_eixs
            INTO ls_document-xsltt
            WHERE bukrs = iv_bukrs
              AND add_key = lv_add_key_xslt
              AND deflt = abap_true.
        ENDIF.
    ENDCASE.

    IF ls_document-prfid EQ 'IHRACAT' .
      SELECT SINGLE * FROM /itetr/com_othp INTO ls_muhattap WHERE prtty EQ 'C'.

      SELECT aliass regdt defal
            FROM /itetr/inv_taxp
            INTO TABLE lt_taxpayer
            WHERE taxid = ls_muhattap-taxid
              AND regdt <= ls_document-bldat.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    rs_document = ls_document.
  ENDMETHOD.


  METHOD outgoing_invoice_save_vbrk.
    TYPES: BEGIN OF ty_taxpayer,
             aliass TYPE /itetr/com_e_alias,
             regdt  TYPE budat,
             defal  TYPE xfeld,
             txpty  TYPE /itetr/com_e_txpty,
           END OF ty_taxpayer,
           BEGIN OF ty_company,
             datab TYPE datab,
             datbi TYPE datbi,
             genid TYPE /itetr/com_e_genid,
             prfid TYPE /itetr/inv_e_prfid,
           END OF ty_company,
           BEGIN OF ty_tax_data,
             invty TYPE /itetr/inv_e_invty,
             taxex TYPE /itetr/com_e_taxex,
             taxty TYPE /itetr/com_e_taxty,
           END OF ty_tax_data.
    DATA: ls_tax_data      TYPE ty_tax_data,
          ls_company_data  TYPE ty_company,
          lt_taxpayer      TYPE STANDARD TABLE OF ty_taxpayer,
          ls_taxpayer      TYPE ty_taxpayer,
          ls_vbrk_in       TYPE vbrk,
          lt_komv          TYPE TABLE OF komv,
          ls_komv          TYPE komv,
          lt_komv_temp     TYPE TABLE OF komv, "gkadioglu
          lt_vbpa          TYPE TABLE OF vbpavb,
          ls_vbpa          TYPE vbpavb,
          ls_knvv          TYPE knvv,
          lt_vbrk          TYPE TABLE OF vbrkvb,
          ls_vbrk          TYPE vbrkvb,
          lt_vbrp          TYPE TABLE OF vbrpvb,
          ls_vbrp          TYPE vbrpvb,
          ls_document      TYPE /itetr/inv_oginv,
          ls_eirule_input  TYPE /itetr/inv_s_eirules_in,
          ls_eirule_output TYPE /itetr/inv_s_eirules_out,
          ls_earule_input  TYPE /itetr/inv_s_earules_in,
          ls_earule_output TYPE /itetr/inv_s_earules_out,
          ls_sddty         TYPE /itetr/inv_sddt,
          lv_kalsm         TYPE t005-kalsm,
          ls_muhattap      TYPE /itetr/com_othp,
          lv_insrt         TYPE /itetr/inv_e_insrt,
          lv_parvw         TYPE parvw,
          lt_parvw         TYPE TABLE OF /itetr/inv_parvw,
          ls_parvw         TYPE  /itetr/inv_parvw,
          lv_inv_type      TYPE /itetr/com_e_value,
          lt_taxm_temp     TYPE TABLE OF /itetr/inv_taxm,
          ls_komv_temp     TYPE komv,
          lv_subrc         TYPE sy-subrc,
          lv_intid         TYPE /itetr/com_e_intid.

    DATA: lt_taxex_chck TYPE TABLE OF /itetr/inv_taxm-taxex,
          ls_taxex_chck LIKE LINE OF lt_taxex_chck.
    DATA : lv_in_update_task TYPE sy-subrc.

    SELECT SINGLE *                                     "#EC CI_NOFIELD
      FROM /itetr/inv_oginv
      INTO ls_document
      WHERE awtyp = iv_awtyp
        AND belnr = iv_belnr.
    IF sy-subrc = 0.
      SELECT SINGLE fkdat
        FROM vbrk
        INTO ls_document-bldat
        WHERE vbeln = iv_belnr.
      IF sy-subrc IS INITIAL.
        SELECT SUM( netwr ) AS wrbtr
               SUM( mwsbp ) AS fwste
          FROM vbrp
          INTO (ls_document-wrbtr, ls_document-fwste)
          WHERE vbeln = iv_belnr.

        update_check_oginv_date_exit( CHANGING is_document = ls_document
                                               it_vbrk     = lt_vbrk
                                               it_vbrp     = lt_vbrp
                                               it_vbpa     = lt_vbpa
                                               it_komv     = lt_komv
                                               iv_subrc    = lv_subrc ).

        IF lv_subrc IS INITIAL.

          UPDATE /itetr/inv_oginv
            SET bldat = ls_document-bldat
                wrbtr = ls_document-wrbtr
                fwste = ls_document-fwste
          WHERE docui = ls_document-docui.

          CALL FUNCTION 'TH_IN_UPDATE_TASK'
            IMPORTING
              in_update_task = lv_in_update_task.

          IF lv_in_update_task NE 1.
            COMMIT WORK AND WAIT.
          ENDIF.
*        COMMIT WORK.
        ENDIF.
      ENDIF.
    ENDIF.

    CHECK ls_document IS INITIAL.

    DO 1000 TIMES.
      CALL FUNCTION '/ITETR/INV_READ_SD_INVOICE'
*        DESTINATION 'NONE'
        EXPORTING
          iv_vbeln = iv_belnr
        TABLES
          xkomv    = lt_komv
          xvbpa    = lt_vbpa
          xvbrk    = lt_vbrk
          xvbrp    = lt_vbrp.
      IF sy-subrc IS INITIAL.
        READ TABLE lt_vbrk INTO ls_vbrk INDEX 1.
        CHECK sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.1' SECONDS.
      ENDIF.
    ENDDO.

    set_save_vbrk_exit( CHANGING is_document = ls_document
                                 is_vbrk     = ls_vbrk
                                 it_vbrk     = lt_vbrk
                                 it_vbrp     = lt_vbrp
                                 it_vbpa     = lt_vbpa
                                 it_komv     = lt_komv
                                 iv_subrc    = lv_subrc   ).

    CHECK lv_subrc EQ 0."gkadioglu

    CHECK ls_vbrk IS NOT INITIAL
      AND ls_vbrk-sfakn = ''
      AND ls_vbrk-fksto = ''.

    SELECT SINGLE *
      FROM /itetr/inv_sddt
      INTO ls_sddty
      WHERE fkart = ls_vbrk-fkart.
    CHECK ls_sddty-eichk = abap_true OR ls_sddty-eachk = abap_true.

    SELECT *
      FROM /itetr/inv_parvw
      INTO TABLE lt_parvw.                              "#EC CI_NOWHERE
*    SORT lt_parvw DESCENDING.
    SORT lt_parvw BY  fkart DESCENDING  firstly DESCENDING xcpdk DESCENDING .

    IF lt_parvw[] IS INITIAL.

      SORT lt_vbpa BY parvw.
      CLEAR ls_vbpa.
      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY parvw = 'RE' BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE lt_vbpa INTO ls_vbpa WITH KEY parvw = 'AG' BINARY SEARCH.
      ENDIF.

      CHECK ls_vbpa IS NOT INITIAL.

      get_billing_onetime_tax(
        EXPORTING
          is_vbpa               = ls_vbpa
        IMPORTING
          ev_taxid              = ls_document-taxid ).

      IF ls_document-taxid IS INITIAL.

        get_customer_taxid(
            EXPORTING
              iv_kunnr      = ls_vbpa-kunnr
            IMPORTING
              ev_taxid      = ls_document-taxid ).

      ENDIF.

    ELSE.

      SORT lt_parvw DESCENDING.

      LOOP AT lt_parvw INTO ls_parvw WHERE  party_type = 'BUYER' OR party_type = space AND
                                            ( fkart = ls_vbrk-fkart OR fkart = space ).
        CLEAR ls_vbpa.
        READ TABLE lt_vbpa INTO ls_vbpa WITH KEY parvw = ls_parvw-parvw BINARY SEARCH.

        IF sy-subrc = 0.

          IF ls_parvw-xcpdk IS NOT INITIAL.
            CHECK ls_parvw-xcpdk = ls_vbpa-xcpdk.
          ENDIF.

          get_billing_onetime_tax(
          EXPORTING
            is_vbpa               = ls_vbpa
            iv_tax_id_fname       = ls_parvw-tax_id_fname
            iv_tax_office_fname   = ls_parvw-tax_office_fname
          IMPORTING
            ev_taxid      = ls_document-taxid ).

          IF ls_document-taxid IS INITIAL AND ls_vbpa-xcpdk IS INITIAL.

            get_customer_taxid(
              EXPORTING
                iv_kunnr              = ls_vbpa-kunnr
                iv_tax_id_fname       = ls_parvw-tax_id_fname
                iv_tax_office_fname   = ls_parvw-tax_office_fname
              IMPORTING
                ev_taxid      = ls_document-taxid ).

          ENDIF.

          IF ls_document-taxid IS NOT INITIAL.
            EXIT.
          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.

    IF ls_vbpa-kunnr IS NOT INITIAL.
      SELECT SINGLE *
        INTO ls_knvv
        FROM knvv
        WHERE kunnr = ls_vbpa-kunnr
          AND vkorg = ls_vbrk-vkorg
          AND vtweg = ls_vbrk-vtweg
          AND spart = ls_vbrk-spart.
    ENDIF.


    READ TABLE lt_vbrp INTO ls_vbrp INDEX 1.
    CHECK sy-subrc = 0.
    ls_document-bldat   = ls_vbrk-fkdat.
    ls_document-doctype = ls_vbrk-fkart.
    ls_document-agent = get_agent( iv_bukrs = iv_bukrs
                                   iv_gsber = ls_vbrp-gsber
                                   iv_werks = ls_vbrp-werks
                                   iv_awtyp = iv_awtyp
                                   iv_belnr = iv_belnr
                                   iv_gjahr = iv_gjahr ).

    ls_eirule_input-agent = ls_document-agent.
    ls_eirule_input-awtyp = iv_awtyp.
    ls_eirule_input-sddty = ls_vbrk-fkart.
    ls_eirule_input-kunnr = ls_vbpa-kunnr.
    ls_eirule_input-vkorg = ls_vbrk-vkorg.
    ls_eirule_input-vtweg = ls_vbrk-vtweg.
    ls_eirule_input-werks = ls_vbrp-werks.
    ls_eirule_input-pstyv = ls_vbrp-pstyv.
    ls_eirule_input-ktgrd = ls_vbrk-ktgrd.
    ls_eirule_input-kalsm = ls_vbrk-kalsm.
    ls_eirule_input-kalks = ls_knvv-kalks.
    ls_eirule_input-vbeln = ls_vbrk-vbeln.
    MOVE-CORRESPONDING ls_eirule_input TO ls_earule_input.

    "check id e-invoice
    IF ls_sddty-eichk = abap_true.
      SELECT SINGLE datab datbi genid prfid
        FROM /itetr/inv_einp
        INTO ls_company_data
        WHERE bukrs = iv_bukrs.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.
      ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'P'
                                            is_rule_input  = ls_eirule_input ).
      IF ls_eirule_output IS NOT INITIAL.
        ls_document-prfid = ls_eirule_output-pidou.
        ls_document-invty = ls_eirule_output-ityou.
        ls_document-taxex = ls_eirule_output-taxex.
      ENDIF.
    ENDIF.

    IF ls_document-prfid NE 'IHRACAT' AND
       ls_document-prfid NE 'YOLCU'.
      CHECK ls_vbrk-rfbsk CA 'CD'.

      IF ls_document-taxid IS NOT INITIAL.
        " check if partner is registered
        SELECT aliass regdt defal txpty
          FROM /itetr/inv_taxp
          INTO TABLE lt_taxpayer
          WHERE taxid = ls_document-taxid
            AND regdt <= ls_document-bldat.
        IF sy-subrc = 0.
          SORT lt_taxpayer BY defal.
          READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
          IF sy-subrc = 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ELSE.
            SORT lt_taxpayer DESCENDING BY regdt.
            READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
            IF sy-subrc EQ 0.
              ls_document-aliass = ls_taxpayer-aliass.
            ENDIF.
          ENDIF.

          IF ls_taxpayer-txpty EQ 'KAMU'.
            ls_document-prfid = 'KAMU'.
          ENDIF.

          IF ls_document-prfid IS INITIAL.
            IF ls_company_data-prfid IS INITIAL.
              ls_company_data-prfid = 'TEMEL'.
            ENDIF.
            ls_document-prfid = ls_company_data-prfid.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    IF lt_taxpayer IS INITIAL AND ls_document-prfid NE 'IHRACAT' AND
       ls_document-prfid NE 'YOLCU' AND ls_sddty-eachk = abap_true.
      SELECT SINGLE datab datbi genid
        FROM /itetr/inv_earp
        INTO ls_company_data
        WHERE bukrs = iv_bukrs.
      CHECK sy-subrc = 0 AND ls_document-bldat BETWEEN ls_company_data-datab AND ls_company_data-datbi.

      ls_document-prfid = 'EARSIV'.
      ls_earule_output = get_earchive_rule( iv_rule_type   = 'P'
                                            is_rule_input  = ls_earule_input ).
      IF ls_earule_output IS NOT INITIAL.
        ls_document-invty = ls_earule_output-ityou.
        ls_document-taxex = ls_earule_output-taxex.
      ENDIF.
    ENDIF.

    "gkadioglu
    IF ls_document-prfid = 'EARSIV'.
      SELECT SINGLE value  FROM /itetr/inv_eacp INTO lv_inv_type WHERE bukrs = iv_bukrs AND cuspa = 'INVTYPE'.
    ELSE.
      SELECT SINGLE value  FROM /itetr/inv_eicp INTO lv_inv_type WHERE bukrs = iv_bukrs AND cuspa = 'INVTYPE'.
    ENDIF.


    CHECK ls_document-prfid IS NOT INITIAL.
    " determine invoice type
    IF ls_document-invty IS INITIAL OR ls_document-taxex IS INITIAL OR ls_document-taxty IS INITIAL.
      SORT lt_komv BY koaid kstat.
      READ TABLE lt_komv INTO ls_komv WITH KEY koaid = 'D' kstat = '' BINARY SEARCH.
      IF sy-subrc = 0 AND ls_komv-mwsk1 IS NOT INITIAL.
        SELECT SINGLE t005~kalsm
          FROM t001
          LEFT OUTER JOIN t005
            ON t001~land1 = t005~land1
          INTO lv_kalsm
          WHERE t001~bukrs = iv_bukrs.
        SELECT SINGLE invty taxex taxty
          FROM /itetr/inv_taxm
          INTO ls_tax_data
          WHERE kalsm = lv_kalsm
            AND mwskz = ls_komv-mwsk1.
        IF sy-subrc = 0.
          IF ls_document-invty IS INITIAL.
            ls_document-invty = ls_tax_data-invty.
          ENDIF.
**          IF ls_document-taxex IS INITIAL.
**            ls_document-taxex = ls_tax_data-taxex.
**            ls_taxex_chck = ls_tax_data-taxex.
**            COLLECT ls_taxex_chck INTO lt_taxex_chck.
**          ENDIF.
          IF ls_document-taxty IS INITIAL.
            ls_document-taxty = ls_tax_data-taxty.
          ENDIF.
        ENDIF.
      ENDIF.
      "gkadioglu
      IF lv_inv_type EQ abap_true AND ls_document-invty NE 'YTBISTISNA'.
        CLEAR: lt_komv_temp[],lt_taxm_temp[].
        lt_komv_temp[] = lt_komv[].
        DELETE lt_komv_temp WHERE koaid NE  'D' OR kstat NE ''.
        DELETE lt_komv_temp WHERE mwsk1 EQ ''.
        IF lt_komv_temp IS NOT INITIAL.
          SELECT kalsm mwskz taxrt
            FROM /itetr/inv_taxm
            INTO CORRESPONDING FIELDS OF TABLE lt_taxm_temp
            WHERE kalsm = lv_kalsm   AND
                  taxrt = 0.
          LOOP AT lt_komv_temp INTO ls_komv_temp .
            READ TABLE lt_taxm_temp TRANSPORTING NO FIELDS WITH  KEY mwskz = ls_komv-mwsk1.
            IF sy-subrc EQ 0.
              ls_document-invty = 'ISTISNA'.
              EXIT.
            ENDIF.
          ENDLOOP.

***          SELECT COUNT(*) FROM /itetr/inv_taxm
***                          FOR ALL ENTRIES IN lt_komv_temp
***                              WHERE kalsm = lv_kalsm   AND
***                                    mwskz = lt_komv_temp-mwsk1 AND
***                                    taxrt = 0.
***          IF sy-subrc EQ 0.
***            ls_document-invty = 'ISTISNA'.
***          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    TRY .
        ls_document-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
        ls_document-invui = /itetr/cl_regulative_common=>generate_document_uuid_c36( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    ls_document-bukrs = iv_bukrs.
    ls_document-belnr = iv_belnr.
    ls_document-gjahr = iv_gjahr.
    ls_document-awtyp = iv_awtyp.
    ls_document-kunnr = ls_vbpa-kunnr.
    ls_document-uzeit = ls_vbrk-erzet.
    ls_document-kursf = ls_vbrk-kurrf.
    ls_document-waers = ls_vbrk-waerk.
    ls_document-ernam = ls_vbrk-ernam.
    ls_document-vkorg = ls_vbrk-vkorg.
    ls_document-vtweg = ls_vbrk-vtweg.
    ls_document-spart = ls_vbrk-spart.
    ls_document-aprvd = abap_true.

    SORT lt_komv BY  kposn koaid kstat.
    LOOP AT lt_vbrp INTO ls_vbrp.
      IF ls_vbrp-netwr IS INITIAL.
        IF ls_vbrp-mwsbp IS INITIAL.
          LOOP AT lt_vbrp TRANSPORTING NO FIELDS WHERE netwr NE 0.
            EXIT.
          ENDLOOP.
          IF sy-subrc IS INITIAL.
            CHECK 1 = 2.
          ENDIF.
        ENDIF.
      ENDIF.
      IF ls_vbrp-aubel IS NOT INITIAL.
        ls_document-vbeln_va = ls_vbrp-aubel. "gkadioglu
      ENDIF.
      CHECK ls_vbrp-fkimg IS NOT INITIAL.
      ADD ls_vbrp-netwr TO ls_document-wrbtr.
      ADD ls_vbrp-mwsbp TO ls_document-fwste.
      ADD ls_vbrp-mwsbp TO ls_document-wrbtr.
      CLEAR ls_komv.
      LOOP AT lt_komv INTO ls_komv WHERE kposn EQ ls_vbrp-posnr
                                     AND koaid EQ 'D'
                                     AND kinak EQ space
                                     AND kstat EQ space
                                     AND kwert IS INITIAL.
        EXIT.
      ENDLOOP.
      IF ls_vbrp-mwsbp IS INITIAL OR ls_vbrp-netwr IS INITIAL OR ls_komv IS NOT INITIAL.
        ls_document-texex = abap_true.
      ENDIF.
      ls_document-werks = ls_vbrp-werks.
      ls_document-gsber = ls_vbrp-gsber.

      IF ls_document-taxex IS INITIAL OR ls_document-taxty IS INITIAL.

        READ TABLE lt_komv INTO ls_komv WITH KEY  kposn = ls_vbrp-posnr
                                                  koaid = 'D'
                                                  kstat = '' BINARY SEARCH.
        IF sy-subrc = 0 AND ls_komv-mwsk1 IS NOT INITIAL.
          SELECT SINGLE t005~kalsm
            FROM t001
            LEFT OUTER JOIN t005
              ON t001~land1 = t005~land1
            INTO lv_kalsm
            WHERE t001~bukrs = iv_bukrs.
          SELECT SINGLE invty taxex taxty
            FROM /itetr/inv_taxm
            INTO ls_tax_data
            WHERE kalsm = lv_kalsm
              AND mwskz = ls_komv-mwsk1.
          IF sy-subrc = 0.
            IF ls_document-taxex IS INITIAL.
              ls_document-taxex = ls_tax_data-taxex.
              ls_taxex_chck = ls_tax_data-taxex.
              COLLECT ls_taxex_chck INTO lt_taxex_chck.
            ENDIF.
            IF ls_document-taxty IS INITIAL.
              ls_document-taxty = ls_tax_data-taxty.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    DATA: lv_taxex_count TYPE i .
    DESCRIBE TABLE lt_taxex_chck LINES lv_taxex_count.

    IF lv_taxex_count GT 1.
      CLEAR ls_document-taxex.
    ENDIF.
    DATA: lv_add_key_xslt	 TYPE /itetr/com_e_add_key,
          lv_add_key_sernr TYPE /itetr/com_e_add_key.




    set_specific_rules_exit( EXPORTING is_vbrk          = ls_vbrk
                                       is_vbpa          = ls_vbpa
                                       it_vbpa          = lt_vbpa
                                       it_vbrp          = lt_vbrp
                             IMPORTING ev_add_key_xslt  = lv_add_key_xslt
                                       ev_add_key_sernr = lv_add_key_sernr
                             CHANGING is_document        = ls_document ).


    CASE ls_document-prfid.
      WHEN 'EARSIV'.

        ls_earule_input-ityin = ls_document-invty.

        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_earule_output.
          ls_earule_output = get_earchive_rule( iv_rule_type   = 'S'
                                                is_rule_input  = ls_earule_input ).



          IF ls_earule_output IS NOT INITIAL AND lv_add_key_sernr IS INITIAL.
            ls_document-serpr = ls_earule_output-serpr.
          ELSE.
            SELECT SINGLE serpr
              FROM /itetr/inv_easr
              INTO ls_document-serpr
              WHERE bukrs = iv_bukrs
                AND add_key = lv_add_key_sernr
                AND maisp = abap_true.
          ENDIF.

        ENDIF.

        CLEAR ls_earule_output.

        ls_earule_output = get_earchive_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_earule_input ).
        IF ls_earule_output IS NOT INITIAL AND lv_add_key_xslt IS INITIAL.
          ls_document-xsltt = ls_earule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM /itetr/inv_eaxs
            INTO ls_document-xsltt
            WHERE bukrs   = iv_bukrs
              AND add_key = lv_add_key_xslt
              AND deflt   = abap_true.
        ENDIF.

      WHEN OTHERS.

        ls_eirule_input-ityin = ls_document-invty.
        ls_eirule_input-pidin = ls_document-prfid.

        IF ls_company_data-genid IS NOT INITIAL.
          CLEAR ls_eirule_output.
          ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'S'
                                                is_rule_input  = ls_eirule_input ).
          IF ls_eirule_output IS NOT INITIAL AND lv_add_key_sernr IS INITIAL.
            ls_document-serpr = ls_eirule_output-serpr.
          ELSE.
            CASE ls_document-prfid.
              WHEN 'IHRACAT'.
                lv_insrt = 'E'.
              WHEN 'YOLCU'.
                lv_insrt = 'T'.
              WHEN OTHERS.
                lv_insrt = 'D'.
            ENDCASE.
            SELECT SINGLE serpr
              FROM /itetr/inv_eisr
              INTO ls_document-serpr
              WHERE bukrs = iv_bukrs
                AND maisp = abap_true
                AND add_key = lv_add_key_sernr
                AND insrt = lv_insrt.
            IF sy-subrc NE 0.
              SELECT SINGLE serpr
                FROM /itetr/inv_eisr
                INTO ls_document-serpr
                WHERE bukrs = iv_bukrs
                  AND add_key = lv_add_key_sernr
                  AND maisp = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR ls_eirule_output.
        ls_eirule_output = get_einvoice_rule( iv_rule_type   = 'X'
                                              is_rule_input  = ls_eirule_input ).
        IF ls_eirule_output IS NOT INITIAL AND lv_add_key_xslt IS INITIAL.
          ls_document-xsltt = ls_eirule_output-xsltt.
        ELSE.
          SELECT SINGLE xsltt
            FROM /itetr/inv_eixs
            INTO ls_document-xsltt
            WHERE bukrs = iv_bukrs
              AND add_key = lv_add_key_xslt
              AND deflt = abap_true.
        ENDIF.
    ENDCASE.
* AS 07.01.2022
    IF ls_document-prfid EQ 'IHRACAT' .
      SELECT SINGLE * FROM /itetr/com_othp INTO ls_muhattap WHERE prtty EQ 'C'.

      SELECT aliass regdt defal
            FROM /itetr/inv_taxp
            INTO TABLE lt_taxpayer
            WHERE taxid = ls_muhattap-taxid
              AND regdt <= ls_document-bldat.
      IF sy-subrc = 0.
        SORT lt_taxpayer BY defal.
        READ TABLE lt_taxpayer INTO ls_taxpayer WITH KEY defal = abap_true BINARY SEARCH.
        IF sy-subrc = 0.
          ls_document-aliass = ls_taxpayer-aliass.
        ELSE.
          SORT lt_taxpayer DESCENDING BY regdt.
          READ TABLE lt_taxpayer INTO ls_taxpayer INDEX 1.
          IF sy-subrc EQ 0.
            ls_document-aliass = ls_taxpayer-aliass.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


    rs_document = ls_document.
  ENDMETHOD.


  METHOD save_incoming_invoices.
    INSERT /itetr/inv_icinv FROM TABLE it_list.
    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD set_initial_data.
    mv_company_code = iv_bukrs.
    SELECT * FROM /itetr/inv_eicp INTO TABLE mt_parameters.
  ENDMETHOD.


  method SET_SAVE_VBRK_EXIT.
  endmethod.


  method SET_SPECIFIC_RULES_EXIT.
  endmethod.


  method UPDATE_CHECK_OGINV_DATE_EXIT.
  endmethod.
ENDCLASS.