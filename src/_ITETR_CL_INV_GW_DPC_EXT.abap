class /ITETR/CL_INV_GW_DPC_EXT definition
  public
  inheriting from /ITETR/CL_INV_GW_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods AWTYPEVHSET_GET_ENTITYSET
    redefinition .
  methods INCINVOPRINTSET_GET_ENTITYSET
    redefinition .
  methods INVTYVHSET_GET_ENTITYSET
    redefinition .
  methods OUTINVODOCSTATUV_GET_ENTITYSET
    redefinition .
  methods OUTINVODOWNLOADI_GET_ENTITYSET
    redefinition .
  methods OUTINVOREADNOTES_GET_ENTITYSET
    redefinition .
  methods OUTINVOSENDSET_GET_ENTITYSET
    redefinition .
  methods PRFIDVHSET_GET_ENTITYSET
    redefinition .
  methods RESSTVHSET_GET_ENTITYSET
    redefinition .
  methods OUTINVOSENDAGAIN_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS /ITETR/CL_INV_GW_DPC_EXT IMPLEMENTATION.


METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

  DATA: ls_save         TYPE /itetr/inv_s_outinv_update,
        lv_note         TYPE string,
        lt_docuiditem   TYPE /itetr/com_tt_document_id,
        ls_from_HEADER  TYPE /itetr/inv_icinh,
        ls_to_HEADER    TYPE /itetr/inv_icinh,
        lt_ITEMS        TYPE /itetr/inv_tt_icini,
        lt_INV_ITEMS    TYPE /itetr/inv_tt_incinv_proc_invi,
        lt_TAXES        TYPE /itetr/inv_tt_icint,
        lt_TAXCODE_LIST TYPE /itetr/com_tt_value_text,
        lv_html_xstring TYPE xstring,
        lv_html_content TYPE string,
        lt_simulate     TYPE /itetr/inv_tt_incinv_proc_smlt,
        ls_return       TYPE bapiret2,
        lt_return       TYPE bapiret2_t.

  CASE io_tech_request_context->get_entity_type_name( ).
  WHEN 'OutInvoUpdateNote'.

    DATA:
    BEGIN OF ls_de_OutInvoUpdateNote.
      INCLUDE TYPE  /itetr/cl_inv_gw_mpc=>ts_outinvoupdatenote.
      DATA: to_Return       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_return WITH DEFAULT KEY,
    END OF ls_de_OutInvoUpdateNote.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_OutInvoUpdateNote ).

    CALL FUNCTION '/ITETR/INV_OUTINV_UPDATE_NOTE'
    EXPORTING
      iv_company_code       = ls_de_OutInvoUpdateNote-iv_company_code
      iv_document_uid       = ls_de_OutInvoUpdateNote-iv_document_uid
      iv_note              = ls_de_OutInvoUpdateNote-iv_note
    IMPORTING
      es_return             = ls_return
      ev_note               = lv_note.

    CLEAR ls_de_OutInvoUpdateNote.
    APPEND ls_return TO lt_return.
    ls_de_OutInvoUpdateNote-to_return = CORRESPONDING #( lt_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_outinvoupdatenote
    CHANGING cr_data = er_deep_entity ).

  WHEN 'OutInvoSave'.

    DATA:
    BEGIN OF ls_de_outinvosave.
      INCLUDE TYPE  /itetr/cl_inv_gw_mpc=>ts_outinvosave.
      DATA: to_Return       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_return WITH DEFAULT KEY,
    END OF ls_de_outinvosave.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_outinvosave ).
    ls_save = CORRESPONDING #( ls_de_outinvosave ).

    CALL FUNCTION '/ITETR/INV_OUTINV_UPDATE_FLD'
    EXPORTING
      iv_document_uid       = ls_de_outinvosave-iv_document_uid
      is_data               = ls_save
    IMPORTING
      es_return             = ls_return.

    CLEAR ls_de_outinvosave.
    APPEND ls_return TO lt_return.
    ls_de_outinvosave-to_return = CORRESPONDING #( lt_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_outinvosave
    CHANGING cr_data = er_deep_entity ).

  WHEN 'IncInvoAddNote'.

    DATA:
    BEGIN OF ls_de_IncInvoAddNote.
      INCLUDE TYPE  /itetr/cl_inv_gw_mpc=>ts_incinvoaddnote.
      DATA: to_Return      TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_return WITH DEFAULT KEY,
            to_DocuIdItem  TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvodocuiditem WITH DEFAULT KEY,
    END OF ls_de_IncInvoAddNote.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_IncInvoAddNote ).
    lt_docuiditem = CORRESPONDING #( ls_de_IncInvoAddNote-to_docuiditem ).

    CALL FUNCTION '/ITETR/INV_INCINV_ADD_NOTE'
    EXPORTING
      iv_company_code       = ls_de_IncInvoAddNote-iv_company_code
      it_documents          = lt_docuiditem
      iv_note               = ls_de_IncInvoAddNote-iv_note
    IMPORTING
      es_return             = ls_return.

    CLEAR ls_de_IncInvoAddNote.
    APPEND ls_return TO lt_return.
    ls_de_IncInvoAddNote-to_return = CORRESPONDING #( lt_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_IncInvoAddNote
    CHANGING cr_data = er_deep_entity ).

  WHEN 'IncInvoAccFchd'.

    DATA:
    BEGIN OF ls_de_incinvoaccfchd.
      INCLUDE TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoaccfchd.
      DATA:
            from_header    TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoheader,
            to_header      TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoheader,
            to_items       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoitems WITH DEFAULT KEY,
            to_invitems    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoinvitems WITH DEFAULT KEY,
            to_taxes       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxes WITH DEFAULT KEY,
            to_taxcodes    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxcodes WITH DEFAULT KEY,
            to_htmlcontent TYPE /itetr/cl_inv_gw_mpc=>ts_incinvohtmlcontent,
            to_return      TYPE /itetr/cl_inv_gw_mpc=>ts_return,
    END OF ls_de_incinvoaccfchd.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_incinvoaccfchd ).
    ls_from_header = CORRESPONDING #( ls_de_incinvoaccfchd-from_header  ).

    CALL FUNCTION '/ITETR/INV_INCINV_ACC_FCHD'
    EXPORTING
      iv_document_uid       = CONV /itetr/com_e_docui( ls_de_incinvoaccfchd-iv_document_uid )
      iv_transaction        = ls_de_incinvoaccfchd-iv_transaction
      is_header             = ls_from_header
    IMPORTING
      es_header             = ls_to_header
      et_items              = lt_items
      et_inv_items          = lt_inv_items
      et_taxes              = lt_taxes
      et_taxcode_list       = lt_taxcode_list
      ev_html_content       = lv_html_xstring
      es_return             = ls_return.

    lv_html_content = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_html_xstring ).
    ls_de_incinvoaccfchd-to_header   = CORRESPONDING #( ls_to_header ).
    ls_de_incinvoaccfchd-to_items    = CORRESPONDING #( lt_items ).
    ls_de_incinvoaccfchd-to_invitems = CORRESPONDING #( lt_inv_items ).
    ls_de_incinvoaccfchd-to_taxes    = CORRESPONDING #( lt_taxes ).
    ls_de_incinvoaccfchd-to_taxcodes = CORRESPONDING #( lt_taxcode_list ).
    ls_de_incinvoaccfchd-to_htmlcontent-ev_html_content = lv_html_content.
    ls_de_incinvoaccfchd-to_return   = CORRESPONDING #( ls_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_incinvoaccfchd
    CHANGING cr_data = er_deep_entity ).

  WHEN 'IncInvoAccFcpa'.

    DATA:
    BEGIN OF ls_de_incinvoaccfcpa.
      INCLUDE TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoaccfcpa.
      DATA:
            to_header      TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoheader,
            to_items       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoitems WITH DEFAULT KEY,
            to_invitems    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoinvitems WITH DEFAULT KEY,
            to_taxes       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxes WITH DEFAULT KEY,
            to_taxcodes    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxcodes WITH DEFAULT KEY,
            to_htmlcontent TYPE /itetr/cl_inv_gw_mpc=>ts_incinvohtmlcontent,
            to_return      TYPE /itetr/cl_inv_gw_mpc=>ts_return,
    END OF ls_de_incinvoaccfcpa.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_incinvoaccfcpa ).

    CALL FUNCTION '/ITETR/INV_INCINV_ACC_FCPA'
    EXPORTING
      iv_document_uid       = CONV /itetr/com_e_docui( ls_de_incinvoaccfcpa-iv_document_uid )
      iv_transaction        = ls_de_incinvoaccfcpa-iv_transaction
      iv_customer           = ls_de_incinvoaccfcpa-iv_customer
      iv_vendor             = ls_de_incinvoaccfcpa-iv_vendor
    IMPORTING
      es_header             = ls_to_header
      et_items              = lt_items
      et_inv_items          = lt_inv_items
      et_taxes              = lt_taxes
      et_taxcode_list       = lt_taxcode_list
      ev_html_content       = lv_html_xstring
      es_return             = ls_return.

    lv_html_content = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_html_xstring ).
    ls_de_incinvoaccfcpa-to_header   = CORRESPONDING #( ls_to_header ).
    ls_de_incinvoaccfcpa-to_items    = CORRESPONDING #( lt_items ).
    ls_de_incinvoaccfcpa-to_invitems = CORRESPONDING #( lt_inv_items ).
    ls_de_incinvoaccfcpa-to_taxes    = CORRESPONDING #( lt_taxes ).
    ls_de_incinvoaccfcpa-to_taxcodes = CORRESPONDING #( lt_taxcode_list ).
    ls_de_incinvoaccfcpa-to_htmlcontent-ev_html_content = lv_html_content.
    ls_de_incinvoaccfcpa-to_return   = CORRESPONDING #( ls_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_incinvoaccfcpa
    CHANGING cr_data = er_deep_entity ).

  WHEN 'IncInvoAccFctx'.

    DATA:
    BEGIN OF ls_de_incinvoaccfctx.
      INCLUDE TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoaccfctx.
      DATA:
            to_header      TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoheader,
            to_items       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoitems WITH DEFAULT KEY,
            to_invitems    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoinvitems WITH DEFAULT KEY,
            to_taxes       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxes WITH DEFAULT KEY,
            to_taxcodes    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxcodes WITH DEFAULT KEY,
            to_htmlcontent TYPE /itetr/cl_inv_gw_mpc=>ts_incinvohtmlcontent,
            to_return      TYPE /itetr/cl_inv_gw_mpc=>ts_return,
    END OF ls_de_incinvoaccfctx.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_incinvoaccfctx ).

    CALL FUNCTION '/ITETR/INV_INCINV_ACC_FCTX'
    EXPORTING
      iv_document_uid       = CONV /itetr/com_e_docui( ls_de_incinvoaccfctx-iv_document_uid )
      iv_transaction        = ls_de_incinvoaccfctx-iv_transaction
      iv_taxcode            = ls_de_incinvoaccfctx-iv_taxcode
      iv_change_items       = ls_de_incinvoaccfctx-iv_change_items
    IMPORTING
      es_header             = ls_to_header
      et_items              = lt_items
      et_inv_items          = lt_inv_items
      et_taxes              = lt_taxes
      et_taxcode_list       = lt_taxcode_list
      ev_html_content       = lv_html_xstring
      es_return             = ls_return.

    lv_html_content = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_html_xstring ).
    ls_de_incinvoaccfctx-to_header   = CORRESPONDING #( ls_to_header ).
    ls_de_incinvoaccfctx-to_items    = CORRESPONDING #( lt_items ).
    ls_de_incinvoaccfctx-to_invitems = CORRESPONDING #( lt_inv_items ).
    ls_de_incinvoaccfctx-to_taxes    = CORRESPONDING #( lt_taxes ).
    ls_de_incinvoaccfctx-to_taxcodes = CORRESPONDING #( lt_taxcode_list ).
    ls_de_incinvoaccfctx-to_htmlcontent-ev_html_content = lv_html_content.
    ls_de_incinvoaccfctx-to_return   = CORRESPONDING #( ls_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_incinvoaccfctx
    CHANGING cr_data = er_deep_entity ).

  WHEN 'IncInvoAccFdue'.

    DATA:
    BEGIN OF ls_de_incinvoaccfdue.
      INCLUDE TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoaccfdue.
      DATA:
            to_header      TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoheader,
            to_items       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoitems WITH DEFAULT KEY,
            to_invitems    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoinvitems WITH DEFAULT KEY,
            to_taxes       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxes WITH DEFAULT KEY,
            to_taxcodes    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxcodes WITH DEFAULT KEY,
            to_htmlcontent TYPE /itetr/cl_inv_gw_mpc=>ts_incinvohtmlcontent,
            to_return      TYPE /itetr/cl_inv_gw_mpc=>ts_return,
    END OF ls_de_incinvoaccfdue.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_incinvoaccfdue ).

    CALL FUNCTION '/ITETR/INV_INCINV_ACC_FDUE'
    EXPORTING
      iv_document_uid        = CONV /itetr/com_e_docui( ls_de_incinvoaccfdue-iv_document_uid )
      iv_transaction         = ls_de_incinvoaccfdue-iv_transaction
      iv_payment_terms       = ls_de_incinvoaccfdue-iv_payment_terms
      iv_baseline_date       = ls_de_incinvoaccfdue-iv_baseline_date
    IMPORTING
      es_header             = ls_to_header
      et_items              = lt_items
      et_inv_items          = lt_inv_items
      et_taxes              = lt_taxes
      et_taxcode_list       = lt_taxcode_list
      ev_html_content       = lv_html_xstring
      es_return             = ls_return.

    lv_html_content = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_html_xstring ).
    ls_de_incinvoaccfdue-to_header   = CORRESPONDING #( ls_to_header ).
    ls_de_incinvoaccfdue-to_items    = CORRESPONDING #( lt_items ).
    ls_de_incinvoaccfdue-to_invitems = CORRESPONDING #( lt_inv_items ).
    ls_de_incinvoaccfdue-to_taxes    = CORRESPONDING #( lt_taxes ).
    ls_de_incinvoaccfdue-to_taxcodes = CORRESPONDING #( lt_taxcode_list ).
    ls_de_incinvoaccfdue-to_htmlcontent-ev_html_content = lv_html_content.
    ls_de_incinvoaccfdue-to_return   = CORRESPONDING #( ls_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_incinvoaccfdue
    CHANGING cr_data = er_deep_entity ).

  WHEN 'IncInvoAccFbco'.

    DATA:
    BEGIN OF ls_de_incinvoaccfbco.
      INCLUDE TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoaccfbco.
      DATA:
            from_invitems   TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoinvitems WITH DEFAULT KEY,
            from_items      TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoitems WITH DEFAULT KEY,
            to_header       TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoheader,
            to_items        TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoitems WITH DEFAULT KEY,
            to_invitems     TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoinvitems WITH DEFAULT KEY,
            to_taxes        TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxes WITH DEFAULT KEY,
            to_taxcodes     TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxcodes WITH DEFAULT KEY,
            to_htmlcontent  TYPE /itetr/cl_inv_gw_mpc=>ts_incinvohtmlcontent,
            to_simulatelogs TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvosimulatelogs WITH DEFAULT KEY,
            to_return       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_return WITH DEFAULT KEY,
    END OF ls_de_incinvoaccfbco.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_de_incinvoaccfbco ).

    lt_items = CORRESPONDING #( ls_de_incinvoaccfbco-from_items ).

    CALL FUNCTION '/ITETR/INV_INCINV_ACC_FBCO'
    EXPORTING
      iv_document_uid       = CONV /itetr/com_e_docui( ls_de_incinvoaccfbco-iv_document_uid )
      iv_transaction        = ls_de_incinvoaccfbco-iv_transaction
      iv_button             = ls_de_incinvoaccfbco-iv_button
      et_inv_items          = ls_de_incinvoaccfbco-from_invitems
      et_item               = lt_items
      iv_ebeln              = ls_de_incinvoaccfbco-iv_ebeln
      iv_ebelp              = ls_de_incinvoaccfbco-iv_ebelp
      iv_lfsnr              = ls_de_incinvoaccfbco-iv_lfsnr
    IMPORTING
      es_header             = ls_to_header
      et_items              = lt_items
      et_inv_items          = lt_inv_items
      et_taxes              = lt_taxes
      et_taxcode_list       = lt_taxcode_list
      ev_html_content       = lv_html_xstring
      et_simulate           = lt_simulate
      es_return             = ls_return
      et_return             = lt_return.

    lv_html_content = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_html_xstring ).
    ls_de_incinvoaccfbco-to_header   = CORRESPONDING #( ls_to_header ).
    ls_de_incinvoaccfbco-to_items    = CORRESPONDING #( lt_items ).
    ls_de_incinvoaccfbco-to_invitems = CORRESPONDING #( lt_inv_items ).
    ls_de_incinvoaccfbco-to_taxes    = CORRESPONDING #( lt_taxes ).
    ls_de_incinvoaccfbco-to_taxcodes = CORRESPONDING #( lt_taxcode_list ).
    ls_de_incinvoaccfbco-to_htmlcontent-ev_html_content = lv_html_content.
    ls_de_incinvoaccfbco-to_simulatelogs = CORRESPONDING #( lt_simulate ).
    ls_de_incinvoaccfbco-to_return   = CORRESPONDING #( lt_return ).

    copy_data_to_ref(
    EXPORTING is_data = ls_de_incinvoaccfbco
    CHANGING cr_data = er_deep_entity ).

  ENDCASE.

ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

  FIELD-SYMBOLS: <ls_entity> TYPE ANY.

  DATA: lv_docuid       TYPE /itetr/com_e_docui,
        lv_forceupdate  TYPE xfeld,
        ls_return       TYPE bapiret2,
        lv_response     TYPE /itetr/inv_e_apres,
        lv_note         TYPE /itetr/com_e_lnote,
        lt_logs         TYPE /itetr/com_tt_log_list.

  DATA(lt_parameter)   = io_tech_request_context->get_parameters( ).
  DATA(lv_func_name)   = io_tech_request_context->get_function_import_name( ).
  DATA(lv_return_type) = io_tech_request_context->get_function_return_type( ).
  DATA(lt_return)      = VALUE bapiret2_t( ).

  CASE iv_action_name.
  WHEN 'OutInvoSetReject'.

    lv_docuid = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_OUTINV_SET_REJECTED'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'OutInvoArchive'.

    lv_docuid = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_OUTINV_ARCHIVE'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'OutInvoUpdateStatu'.

    lv_docuid      = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).
    lv_forceupdate = CONV xfeld( lt_parameter[ name = 'IV_FORCE_UPDATE' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_OUTINV_UPDATE_STA'
    EXPORTING
      iv_document_uid       = lv_docuid
      iv_force_update       = lv_forceupdate
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'OutInvoDelete'.

    lv_docuid = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_OUTINV_DELETE'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'OutInvoDelete'.

    lv_docuid = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_OUTINV_DELETE'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'OutInvoLog'.

    lv_docuid = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_OUTINV_GET_LOGS'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      et_logs               = lt_logs.

    copy_data_to_ref( EXPORTING is_data = lt_logs
    CHANGING cr_data = er_data ).

  WHEN 'IncInvoArchive'.

    lv_docuid = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_INCINV_ARCHIVE'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'IncInvoUpdateStatu'.

    lv_docuid      = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_INCINV_UPDATE_STAT'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'IncInvoProcess'.

    lv_docuid      = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_INCINV_PROCESS'
    EXPORTING
      iv_document_uid       = lv_docuid
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  WHEN 'IncInvoResponse'.

    lv_docuid      = CONV /itetr/com_e_docui( lt_parameter[ name = 'IV_DOCUMENT_UID' ]-VALUE ).
    lv_response = CONV /itetr/inv_e_apres( lt_parameter[ name = 'IV_RESPONSE' ]-VALUE ).
    lv_note = CONV /itetr/com_e_lnote( lt_parameter[ name = 'IV_NOTE' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_INCINV_RESPONSE'
    EXPORTING
      iv_document_uid       = lv_docuid
      iv_response           = lv_response
      IV_NOTE               = lv_note
    IMPORTING
      es_return             = ls_return.

    copy_data_to_ref( EXPORTING is_data = ls_return
    CHANGING cr_data = er_data ).

  ENDCASE.

ENDMETHOD.


method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET.
    FIELD-SYMBOLS: <lt_data> TYPE table.
    DATA(lt_orderby) = io_tech_request_context->get_orderby( ).
    DATA(lt_sorter)  = VALUE esp6_sortfield_tab_type( ).
    TRY.
        CALL METHOD super->/iwbep/if_mgw_appl_srv_runtime~get_entityset
          EXPORTING
            iv_entity_name           = iv_entity_name
            iv_entity_set_name       = iv_entity_set_name
            iv_source_name           = iv_source_name
            it_filter_select_options = it_filter_select_options
            it_order                 = it_order
            is_paging                = is_paging
            it_navigation_path       = it_navigation_path
            it_key_tab               = it_key_tab
            iv_filter_string         = iv_filter_string
            iv_search_string         = iv_search_string
            io_tech_request_context  = io_tech_request_context
          IMPORTING
            er_entityset             = er_entityset
            es_response_context      = es_response_context.

        ASSIGN er_entityset->* TO <lt_data>.
        CHECK sy-subrc IS INITIAL.
        IF lt_orderby IS NOT INITIAL.
          LOOP AT lt_orderby ASSIGNING FIELD-SYMBOL(<ls_orderby>).
            APPEND INITIAL LINE TO lt_sorter ASSIGNING FIELD-SYMBOL(<ls_sorter>).
            <ls_sorter>-name     = <ls_orderby>-property.
            <ls_sorter>-flg_desc = COND #( WHEN <ls_orderby>-order EQ 'desc' THEN abap_true ).
          ENDLOOP.
          CALL FUNCTION 'C140_TABLE_DYNAMIC_SORT'
            TABLES
              i_sortfield_tab      = lt_sorter
              x_tab                = <lt_data>
            EXCEPTIONS
              sortfieldtab_too_big = 1
              OTHERS               = 2.
        ENDIF.
      CATCH /iwbep/cx_mgw_busi_exception.
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entity.

  DATA: lv_document_uid  TYPE /itetr/com_e_docui,
        lT_PRFID         TYPE /itetr/com_tt_value_text,
        lT_ALIASS        TYPE /itetr/com_tt_value_text,
        lT_INVTY         TYPE /itetr/com_tt_value_text,
        lT_TAXEX         TYPE /itetr/com_tt_value_text,
        lT_SERPR         TYPE /itetr/com_tt_value_text,
        lT_XSLTT         TYPE /itetr/com_tt_value_text,
        lT_TAXTY         TYPE /itetr/com_tt_value_text,
        lT_EATYP         TYPE /itetr/com_tt_value_text,
        lv_transaction   TYPE sytcode,
        ls_header        TYPE /itetr/inv_icinh,
        lt_items         TYPE /itetr/inv_tt_icini,
        lt_taxes         TYPE /itetr/inv_tt_icint,
        lt_inv_items     TYPE /itetr/inv_tt_incinv_proc_invi,
        lv_html_xstring  TYPE xstring,
        lv_html_content  TYPE string,
        lt_taxtcode_list TYPE /itetr/com_tt_value_text,
        ls_return        TYPE bapiret2.

  DATA:
  BEGIN OF ls_OutInvoEdit.
    INCLUDE TYPE /itetr/cl_inv_gw_mpc=>ts_outinvoeditlist.
    DATA: to_Prfid TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_Aliass TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_Invty TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_Taxex TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_Serpr TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_Xsltt TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_Taxty TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_Eatyp TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvoedititem WITH DEFAULT KEY,
          to_return TYPE /itetr/cl_inv_gw_mpc=>ts_return,
  END OF ls_OutInvoEdit.

  DATA:
  BEGIN OF ls_IncInvoAccData.
    INCLUDE TYPE /itetr/cl_inv_gw_mpc=>ts_outinvoeditlist.
    DATA: to_IncInvoHeader      TYPE /itetr/cl_inv_gw_mpc=>ts_incinvoheader,
          to_IncInvoItems       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoitems WITH DEFAULT KEY,
          to_IncInvoTaxes       TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxes WITH DEFAULT KEY,
          to_IncInvoInvItems    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvoinvitems WITH DEFAULT KEY,
          to_IncInvoHtmlContent TYPE /itetr/cl_inv_gw_mpc=>ts_incinvohtmlcontent,
          to_IncInvoTaxCodes    TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_incinvotaxcodes WITH DEFAULT KEY,
          to_Return             TYPE /itetr/cl_inv_gw_mpc=>ts_return,
  END OF ls_IncInvoAccData.

  CASE io_tech_request_context->get_entity_type_name( ).
  WHEN 'OutInvoEditList'.

    lv_document_uid = CONV /itetr/com_e_docui( it_key_tab[ name = 'IvDocumentUid' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_OUTINV_LIST_EDIT_F4'
    EXPORTING
      iv_document_uid       = lv_document_uid
    IMPORTING
      es_return             = ls_return
      et_prfid              = lt_prfid
      et_aliass             = lt_aliass
      et_invty              = lt_invty
      et_taxex              = lt_taxex
      et_serpr              = lt_serpr
      et_xsltt              = lt_xsltt
      et_taxty              = lt_taxty
      et_eatyp              = lt_eatyp.

    ls_OutInvoEdit-iv_document_uid = lv_document_uid.
    ls_OutInvoEdit-to_prfid  = CORRESPONDING #( lt_prfid ).
    ls_OutInvoEdit-to_aliass = CORRESPONDING #( lt_aliass ).
    ls_OutInvoEdit-to_invty  = CORRESPONDING #( lt_invty ).
    ls_OutInvoEdit-to_taxex  = CORRESPONDING #( lt_taxex ).
    ls_OutInvoEdit-to_serpr  = CORRESPONDING #( lt_serpr ).
    ls_OutInvoEdit-to_xsltt  = CORRESPONDING #( lt_xsltt ).
    ls_OutInvoEdit-to_taxty  = CORRESPONDING #( lt_taxty ).
    ls_OutInvoEdit-to_eatyp  = CORRESPONDING #( lt_eatyp ).
    ls_OutInvoEdit-to_return = CORRESPONDING #( ls_return ).

    copy_data_to_ref( EXPORTING is_data = ls_outinvoedit CHANGING cr_data = er_entity ).

    APPEND 'TO_PRFID' TO et_expanded_tech_clauses.
    APPEND 'TO_ALIASS' TO et_expanded_tech_clauses.
    APPEND 'TO_INVTY' TO et_expanded_tech_clauses.
    APPEND 'TO_TAXEX' TO et_expanded_tech_clauses.
    APPEND 'TO_SERPR' TO et_expanded_tech_clauses.
    APPEND 'TO_XSLTT' TO et_expanded_tech_clauses.
    APPEND 'TO_TAXTY' TO et_expanded_tech_clauses.
    APPEND 'TO_EATYP' TO et_expanded_tech_clauses.
    APPEND 'TO_RETURN' TO et_expanded_tech_clauses.

  WHEN 'IncInvoAccData'.

    lv_document_uid = CONV /itetr/com_e_docui( it_key_tab[ name = 'IvDocumentUid' ]-VALUE ).
    lv_transaction  = CONV sytcode( it_key_tab[ name = 'IvTransaction' ]-VALUE ).

    CALL FUNCTION '/ITETR/INV_INCINV_ACC_DATA'
    EXPORTING
      iv_document_uid       = lv_document_uid
      iv_transaction        = lv_transaction
    IMPORTING
      es_header             = ls_header
      et_items              = lt_items
      et_taxes              = lt_taxes
      et_inv_items          = lt_inv_items
      ev_html_content       = lv_html_xstring
      et_taxcode_list       = lt_taxtcode_list
      es_return             = ls_return.

    lv_html_content = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_html_xstring ).
    ls_incinvoaccdata-to_IncInvoHeader      = CORRESPONDING #( ls_header ).
    ls_incinvoaccdata-to_IncInvoItems       = CORRESPONDING #( lt_items ).
    ls_incinvoaccdata-to_IncInvoTaxes       = CORRESPONDING #( lt_taxes ).
    ls_incinvoaccdata-to_IncInvoInvItems    = CORRESPONDING #( lt_inv_items ).
    ls_incinvoaccdata-to_incinvohtmlcontent-ev_html_content = lv_html_content .
    ls_incinvoaccdata-to_IncInvoTaxCodes    = CORRESPONDING #( lt_taxtcode_list ).
    ls_incinvoaccdata-to_return             = CORRESPONDING #( ls_return ).

    copy_data_to_ref( EXPORTING is_data = ls_incinvoaccdata CHANGING cr_data = er_entity ).

    APPEND 'TO_INCINVOHEADER' TO et_expanded_tech_clauses.
    APPEND 'TO_INCINVOITEMS' TO et_expanded_tech_clauses.
    APPEND 'TO_INCINVOTAXES' TO et_expanded_tech_clauses.
    APPEND 'TO_INCINVOINVITEMS' TO et_expanded_tech_clauses.
    APPEND 'TO_INCINVOHTMLCONTENT' TO et_expanded_tech_clauses.
    APPEND 'TO_INCINVOTAXCODES' TO et_expanded_tech_clauses.
    APPEND 'TO_RETURN' TO et_expanded_tech_clauses.

  WHEN OTHERS.
    TRY.
      super->/iwbep/if_mgw_appl_srv_runtime~get_expanded_entity(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        io_expand                = io_expand
        io_tech_request_context  = io_tech_request_context
      IMPORTING
        er_entity                = er_entity
*        es_response_context      = es_response_context
        et_expanded_clauses      = et_expanded_clauses
        et_expanded_tech_clauses = et_expanded_tech_clauses ).
    CATCH /iwbep/cx_mgw_busi_exception /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDCASE.

ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

  DATA: ls_header      TYPE ihttpnvp,
        ls_stream      TYPE ty_s_media_resource,
        lv_mimetype    TYPE w3conttype,
        lv_docuid      TYPE /itetr/com_e_docui,
        lv_contentType TYPE /itetr/com_e_conty,
        lv_content     TYPE xstring,
        lv_filename    TYPE char40,
        ls_return TYPE bapiret2.

  lv_docuid = CONV /itetr/com_e_docui( it_key_tab[ name = 'IvDocumentUid' ]-VALUE ).
  IF line_exists( it_key_tab[ name = 'MimeType' ] ).
    lv_contentType = it_key_tab[ name = 'MimeType' ]-VALUE.
  ELSE.
    lv_contenttype = 'PDF'.
  ENDIF.

  CASE iv_entity_name.
  WHEN 'Attachment'.
    CALL FUNCTION '/ITETR/INV_OUTINV_DOWNLOAD'
    EXPORTING
      iv_document_uid       = lv_docuid
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_document           = lv_content
      ev_content_type       = lv_contenttype.

  WHEN 'AttachmentOutInv'.
    CALL FUNCTION '/ITETR/INV_OUTINV_DOWNLOAD'
    EXPORTING
      iv_document_uid       = lv_docuid
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_document           = lv_content
      ev_content_type       = lv_contenttype.

  WHEN 'AttachmentIncInvo'.
    CALL FUNCTION '/ITETR/INV_INCINV_DOWNLOAD'
    EXPORTING
      iv_document_uid       = lv_docuid
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_document           = lv_content.

  WHEN 'AttachmentIncInvo2'.
    CALL FUNCTION '/ITETR/INV_INCINV_DOWNLOAD'
    EXPORTING
      iv_document_uid       = lv_docuid
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_document           = lv_content.

  ENDCASE.

  IF ls_return IS NOT INITIAL.
* Call RFC call exception handling
  me->/iwbep/if_sb_dpc_comm_services~rfc_save_log(
    EXPORTING
      is_return      = ls_return
      iv_entity_type = iv_entity_name
      it_key_tab     = it_key_tab ).
ENDIF.

  " UBL ise XML olacak dosya.
  IF lv_contentType EQ 'UBL'.
    lv_contenttype = 'XML'.
  ENDIF.
  lv_filename = CONV stringval( lv_docuid ).
  CONCATENATE lv_filename '.' lv_contenttype INTO lv_filename.

  ls_stream-VALUE = lv_content.
  ls_stream-mime_type = /iwwrk/cl_mgw_workflow_rt_util=>get_mime_type_from_extension( lv_contenttype ).
  " 'application/octet-stream'.
  IF iv_entity_name EQ 'AttachmentIncInvo2'.
    ls_stream-mime_type = 'application/octet-stream'.
  ENDIF.

  CLEAR ls_header.
  ls_header-name = 'Content-Disposition'.
  CONCATENATE 'inline; filename="' lv_filename '"' INTO ls_header-VALUE.
  me->set_header( is_header = ls_header ).

  copy_data_to_ref( EXPORTING is_data = ls_stream
  CHANGING  cr_data = er_stream ).

  ls_header-name = 'Cache-Control'.
  ls_header-VALUE = 'no-cache, no-store'.
  set_header( EXPORTING is_header = ls_header ).

ENDMETHOD.


METHOD awtypevhset_get_entityset.
  DATA: lt_values TYPE STANDARD TABLE OF dd07v WITH DEFAULT KEY.

  CALL FUNCTION 'DDUT_DOMVALUES_GET'
  EXPORTING
    name      = '/ITETR/INV_D_AWTYP'
    langu     = sy-langu
  TABLES
    dd07v_tab = lt_values.

  et_entityset = CORRESPONDING #( lt_values ) .

ENDMETHOD.


 METHOD INCINVOPRINTSET_GET_ENTITYSET.

  DATA: lv_docuid                TYPE /itetr/com_e_docui,
        lv_companycode           TYPE bukrs,
        lv_OnlyChstat            TYPE xfeld,
        lv_contenttype           TYPE /itetr/com_e_conty,
        lv_content               TYPE xstring,
        lv_mimetype              TYPE w3conttype,
        lv_base64string          TYPE string,
        lv_url                   TYPE string,
        lv_filename              TYPE char40,
        ls_document_id           TYPE /itetr/com_s_document_id,
        lt_documents             TYPE /itetr/com_tt_document_id,
        ls_downloadinvo          TYPE /ITETR/CL_INV_GW_mpc=>ts_outinvodownloadinvo,
        lt_downloadinvo          TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvodownloadinvo WITH DEFAULT KEY,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        ls_filter                TYPE /iwbep/s_mgw_select_option,
        ls_filter_range          TYPE /iwbep/s_cod_select_option,
        ls_return                TYPE bapiret2.

  LOOP AT it_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-PROPERTY.
      WHEN 'Docui'.
        CLEAR ls_document_id.
        lv_docuid = ls_filter_range-low.
        ls_document_id-docui = CONV /itetr/com_e_docui( lv_docuid ).
        APPEND ls_document_id TO lt_documents.
      WHEN 'IvCompanyCode'.
        lv_companycode = ls_filter_range-low.
      WHEN 'IvOnlyChstat'.
        lv_OnlyChstat = ls_filter_range-low.
      WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  IF lv_OnlyChstat is INITIAL.

    lv_contentType = 'PDF'.

    CALL FUNCTION '/ITETR/INV_INCINV_PRINT'
    EXPORTING
      iv_company_code       = lv_companycode
      it_documents          = lt_documents
      iv_only_chstat        = ''
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_pdf_content        = lv_content.

    lv_mimetype     = /iwwrk/cl_mgw_workflow_rt_util=>get_mime_type_from_extension( lv_contenttype ).
    lv_base64string = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_content ).

    lv_url = |DATA:{ lv_mimetype };base64,{ lv_base64string }|.

  ELSE.

    CALL FUNCTION '/ITETR/INV_INCINV_PRINT'
    EXPORTING
      iv_company_code       = lv_companycode
      it_documents          = lt_documents
      iv_only_chstat        = 'X'
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_pdf_content        = lv_content.

  ENDIF.

  ls_downloadinvo = CORRESPONDING #( ls_return ).
  ls_downloadinvo-ev_pdf_content =  lv_url.
  APPEND ls_downloadinvo TO lt_downloadinvo.

  et_entityset = CORRESPONDING #( lt_downloadinvo ).

ENDMETHOD.


METHOD INVTYVHSET_GET_ENTITYSET.

  DATA: lt_values TYPE STANDARD TABLE OF dd07v WITH DEFAULT KEY.

  CALL FUNCTION 'DDUT_DOMVALUES_GET'
  EXPORTING
    name      = '/ITETR/INV_D_INVTY'
    langu     = sy-langu
  TABLES
    dd07v_tab = lt_values.

  et_entityset = CORRESPONDING #( lt_values ) .

ENDMETHOD.


METHOD outinvodocstatuv_get_entityset.

  DATA: lt_values TYPE STANDARD TABLE OF dd07v WITH DEFAULT KEY.

  CALL FUNCTION 'DDUT_DOMVALUES_GET'
  EXPORTING
    name      = '/ITETR/COM_D_DGSTA'
    langu     = 'T'
*     TEXTS_ONLY          = ''
  TABLES
    dd07v_tab = lt_values.

  et_entityset = CORRESPONDING #( lt_values ) .

ENDMETHOD.


METHOD outinvodownloadi_get_entityset.

  DATA: lv_docuid                TYPE /itetr/com_e_docui,
        lv_companycode           TYPE bukrs,
        lv_OnlyChstat            TYPE xfeld,
        lv_contenttype           TYPE /itetr/com_e_conty,
        lv_content               TYPE xstring,
        lv_mimetype              TYPE w3conttype,
        lv_base64string          TYPE string,
        lv_url                   TYPE string,
        lv_filename              TYPE char40,
        ls_document_id           TYPE /itetr/com_s_document_id,
        lt_documents             TYPE /itetr/com_tt_document_id,
        ls_downloadinvo          TYPE /ITETR/CL_INV_GW_mpc=>ts_outinvodownloadinvo,
        lt_downloadinvo          TYPE STANDARD TABLE OF /itetr/cl_inv_gw_mpc=>ts_outinvodownloadinvo WITH DEFAULT KEY,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        ls_filter                TYPE /iwbep/s_mgw_select_option,
        ls_filter_range          TYPE /iwbep/s_cod_select_option,
        ls_return                TYPE bapiret2.

  LOOP AT it_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-PROPERTY.
      WHEN 'Docui'.
        CLEAR ls_document_id.
        lv_docuid = ls_filter_range-low.
        ls_document_id-docui = CONV /itetr/com_e_docui( lv_docuid ).
        APPEND ls_document_id TO lt_documents.
      WHEN 'IvCompanyCode'.
        lv_companycode = ls_filter_range-low.
      WHEN 'IvOnlyChstat'.
        lv_OnlyChstat = ls_filter_range-low.
      WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  IF lv_OnlyChstat is INITIAL.

    lv_contentType = 'PDF'.

    CALL FUNCTION '/ITETR/INV_OUTINV_PRINT'
    EXPORTING
      iv_company_code       = lv_companycode
      it_documents          = lt_documents
      iv_only_chstat        = ''
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_pdf_content        = lv_content.

*  CALL FUNCTION '/ITETR/INV_OUTINV_DOWNLOAD'
*  EXPORTING
*    iv_document_uid       = lv_docuid
*    iv_content_type       = lv_contenttype
*  IMPORTING
*    es_return             = ls_return
*    ev_document           = lv_content
*    ev_content_type       = lv_contenttype.

    lv_mimetype     = /iwwrk/cl_mgw_workflow_rt_util=>get_mime_type_from_extension( lv_contenttype ).
    lv_base64string = /iwwrk/cl_mgw_workflow_rt_util=>base64_encode( lv_content ).

    lv_url = |DATA:{ lv_mimetype };base64,{ lv_base64string }|.

  ELSE.

    CALL FUNCTION '/ITETR/INV_OUTINV_PRINT'
    EXPORTING
      iv_company_code       = lv_companycode
      it_documents          = lt_documents
      iv_only_chstat        = 'X'
      iv_content_type       = lv_contenttype
    IMPORTING
      es_return             = ls_return
      ev_pdf_content        = lv_content.

  ENDIF.

  ls_downloadinvo = CORRESPONDING #( ls_return ).
  ls_downloadinvo-ev_pdf_content =  lv_url.
  APPEND ls_downloadinvo TO lt_downloadinvo.

  et_entityset = CORRESPONDING #( lt_downloadinvo ).

ENDMETHOD.


METHOD outinvoreadnotes_get_entityset.

  DATA: lv_docuid                TYPE /itetr/com_e_docui,
        lv_companycode           TYPE bukrs,
        lv_note                  TYPE string,
        ls_return                type bapiret2,
        ls_readnote              TYPE /ITETR/CL_INV_GW_MPC=>ts_outinvoreadnote,
        lt_readnotes             TYPE STANDARD TABLE OF /ITETR/CL_INV_GW_MPC=>ts_outinvoreadnote with DEFAULT KEY,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        ls_filter                TYPE /iwbep/s_mgw_select_option,
        ls_filter_range          TYPE /iwbep/s_cod_select_option.

  LOOP AT it_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-PROPERTY.
      WHEN 'IvDocumentUid'.
        lv_docuid = CONV /itetr/com_e_docui( ls_filter_range-low ).
      WHEN 'IvCompanyCode'.
        lv_companycode = ls_filter_range-low.
      WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  CALL FUNCTION '/ITETR/INV_OUTINV_READ_NOTE'
  EXPORTING
    iv_company_code       = lv_companycode
    iv_document_uid       = lv_docuid
  IMPORTING
    es_return             = ls_return
    ev_note               = lv_note.

    ls_readnote = CORRESPONDING #( ls_return ).
    ls_readnote-ev_note = lv_note.

  APPEND ls_readnote TO lt_readnotes.
  et_entityset = CORRESPONDING #( lt_readnotes ).

ENDMETHOD.


  method OUTINVOSENDAGAIN_GET_ENTITYSET.

  DATA: lv_docuid                TYPE /itetr/com_e_docui,
        lv_companycode           TYPE bukrs,
        ls_document_id           TYPE /itetr/com_s_document_id,
        lt_documents             TYPE /itetr/com_tt_document_id,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        ls_filter                TYPE /iwbep/s_mgw_select_option,
        ls_filter_range          TYPE /iwbep/s_cod_select_option,
        ls_returntab             TYPE bapiret2_tab.

  LOOP AT it_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-PROPERTY.
      WHEN 'Docui'.
        CLEAR ls_document_id.
        lv_docuid = ls_filter_range-low.
        ls_document_id-docui = CONV /itetr/com_e_docui( lv_docuid ).
        APPEND ls_document_id TO lt_documents.
      WHEN 'IvCompanyCode'.
        lv_companycode = ls_filter_range-low.
      WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

CALL FUNCTION '/ITETR/INV_OUTINV_SEND_AGAIN'
  EXPORTING
    iv_company_code       = lv_companycode
    it_documents          = lt_documents
  IMPORTING
    et_return             = ls_returntab.

  et_entityset = CORRESPONDING #( ls_returntab ).

  endmethod.


METHOD outinvosendset_get_entityset.

  DATA: lv_docuid                TYPE /itetr/com_e_docui,
        lv_companycode           TYPE bukrs,
        ls_document_id           TYPE /itetr/com_s_document_id,
        lt_documents             TYPE /itetr/com_tt_document_id,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        ls_filter                TYPE /iwbep/s_mgw_select_option,
        ls_filter_range          TYPE /iwbep/s_cod_select_option,
        ls_returntab             TYPE bapiret2_tab.

  LOOP AT it_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-PROPERTY.
      WHEN 'Docui'.
        CLEAR ls_document_id.
        lv_docuid = ls_filter_range-low.
        ls_document_id-docui = CONV /itetr/com_e_docui( lv_docuid ).
        APPEND ls_document_id TO lt_documents.
      WHEN 'IvCompanyCode'.
        lv_companycode = ls_filter_range-low.
      WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  CALL FUNCTION '/ITETR/INV_OUTINV_SEND'
  EXPORTING
    iv_company_code       = lv_companycode
    it_documents          = lt_documents
  IMPORTING
    et_return             = ls_returntab.

  et_entityset = CORRESPONDING #( ls_returntab ).

ENDMETHOD.


METHOD PRFIDVHSET_GET_ENTITYSET.
  DATA: lt_values TYPE STANDARD TABLE OF dd07v WITH DEFAULT KEY.

  CALL FUNCTION 'DDUT_DOMVALUES_GET'
  EXPORTING
    name      = '/ITETR/INV_D_PRFID'
    langu     = sy-langu
*     TEXTS_ONLY          = ''
  TABLES
    dd07v_tab = lt_values.

  et_entityset = CORRESPONDING #( lt_values ) .

ENDMETHOD.


METHOD RESSTVHSET_GET_ENTITYSET.
  DATA: lt_values TYPE STANDARD TABLE OF dd07v WITH DEFAULT KEY.

  CALL FUNCTION 'DDUT_DOMVALUES_GET'
  EXPORTING
    name      = '/ITETR/INV_D_RESST'
    langu     = sy-langu
  TABLES
    dd07v_tab = lt_values.

  et_entityset = CORRESPONDING #( lt_values ) .

ENDMETHOD.
ENDCLASS.