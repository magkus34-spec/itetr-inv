class /ITETR/CL_EARCHIVE_WS_EFN definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  create public .

public section.

  methods DOWNLOAD_REGISTERED_TAXPAYERS
    redefinition .
  methods GET_INCOMING_ARCHIVES
    redefinition .
  methods INCOMING_ARCHIVE_DOWNLOAD
    redefinition .
  methods OUTGOING_INVOICE_CANCEL
    redefinition .
  methods OUTGOING_INVOICE_DOWNLOAD
    redefinition .
  methods OUTGOING_INVOICE_GET_STATUS
    redefinition .
  methods OUTGOING_INVOICE_SEND
    redefinition .
  methods OUTGOING_INVOICE_PREVIEW
    redefinition .
protected section.

  methods GET_INCOMING_ARCHIVES_INT
    importing
      !IV_DATE_FROM type BEGDA
      !IV_DATE_TO type ENDDA
    returning
      value(RT_INVOICES) type MTY_INCOMING_DOCUMENTS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
private section.
ENDCLASS.



CLASS /ITETR/CL_EARCHIVE_WS_EFN IMPLEMENTATION.


  METHOD download_registered_taxpayers.

  ENDMETHOD.


  METHOD get_incoming_archives.
    DATA: lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          lt_service_return   TYPE mty_incoming_documents,
          lv_zipped_file      TYPE xstring,
          lv_xml_file         TYPE string,
          ls_invoice_status   TYPE mty_document_status,
          lv_attachment_count TYPE i,
          ls_invoice          TYPE /itetr/com_message1,
          ls_return           TYPE bapiret2,
          lv_content          TYPE xstring,
          ls_document_numbers TYPE /itetr/com_s_document_numbers,
          ls_doc_ref          TYPE /itetr/com_despatch_document_r,
          ls_tevkifat         TYPE /itetr/com_withholding_tax_tot,
          ls_despatch         TYPE /itetr/inv_icdes,
          ls_additional       TYPE /itetr/com_additional_document,
          ls_taxes            TYPE /itetr/com_tax_total,
          lv_invui            TYPE /itetr/com_e_duich,
          lv_message          TYPE string,
          lx_root             TYPE REF TO cx_root,
          lt_icinv            TYPE TABLE OF /itetr/inv_icinv,
          lv_tabix            TYPE sy-tabix,
          lx_etr_exception    TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <ls_service_return> TYPE mty_incoming_document,
                   <ls_list>           TYPE /itetr/inv_icinv.


    lt_service_return = get_incoming_archives_int( iv_date_from = iv_date_from
                                                   iv_date_to = iv_date_to ).

    IF lt_service_return[] IS NOT INITIAL.
      SELECT *
        FROM /itetr/inv_icinv
        INTO TABLE lt_icinv
        FOR ALL ENTRIES IN lt_service_return
        WHERE invno = lt_service_return-faturano
          AND taxid = lt_service_return-mukellefvkn
          AND bukrs = ms_company_parameters-bukrs.

      LOOP AT lt_service_return ASSIGNING <ls_service_return>.
        lv_tabix = sy-tabix.
        READ TABLE lt_icinv TRANSPORTING NO FIELDS WITH KEY invno = <ls_service_return>-faturano
                                                            taxid = <ls_service_return>-mukellefvkn.
        IF sy-subrc EQ 0 .
          DELETE lt_service_return INDEX lv_tabix.
        ELSE.
          APPEND INITIAL LINE TO rt_list ASSIGNING <ls_list>.

          <ls_list>-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
          <ls_list>-invno = <ls_service_return>-faturano.
          IF <ls_service_return>-duzenlenmetarihi IS NOT INITIAL.
            <ls_list>-bldat = <ls_service_return>-duzenlenmetarihi+0(8).
          ENDIF.
          <ls_list>-recdt = <ls_service_return>-insertdate.
          <ls_list>-bukrs = ms_company_parameters-bukrs.
          <ls_list>-taxid = <ls_service_return>-mukellefvkn.
          <ls_list>-wrbtr = <ls_service_return>-odenecektutar.
          <ls_list>-dmbtr = <ls_service_return>-toplamtutar.
          <ls_list>-waers = <ls_service_return>-parabirimi.
          <ls_list>-fwste = <ls_service_return>-vergilertutari.
          <ls_list>-aprvd = abap_true.
          <ls_list>-prfid = 'EARSIV'.
*      <ls_list>-invty = <ls_service_return>-gonderimsekli.
          <ls_list>-title = <ls_service_return>-unvan.

          SELECT SINGLE invui
              FROM /itetr/inv_icinv
              INTO lv_invui
              WHERE bukrs = ms_company_parameters-bukrs
                AND docui = <ls_list>-docui.
          IF sy-subrc NE 0.
            INSERT /itetr/inv_icinv FROM <ls_list>.
            COMMIT WORK AND WAIT.
          ELSE.
            CLEAR <ls_list>-docui.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_incoming_archives_int.

    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_zipped_file      TYPE xstring,
          lv_xml_file         TYPE string,
          ls_invoice_status   TYPE mty_document_status.

    FIELD-SYMBOLS: <ls_list>          TYPE mty_incoming_document,
                   <lv_invoice_field> TYPE any.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
    '<soapenv:Header>'
    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
    '<wsse:UsernameToken>'
    '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
    '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
    '</wsse:UsernameToken>'
    '</wsse:Security>'
    '</soapenv:Header>'
    '<soapenv:Body>'
    '<ser:gibEarsivFaturaListesiAl>'
    '<vkn>' mv_company_taxid '</vkn>'
    '<faturaBaslangicTarihi>' iv_date_from '</faturaBaslangicTarihi>'
    '<faturaBitisTarihi>' iv_date_to '</faturaBitisTarihi>'
    '<belgeTipi>GIB_EARSIV_FATURA</belgeTipi>'
    '</ser:gibEarsivFaturaListesiAl>'
    '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'return'.
          APPEND INITIAL LINE TO rt_invoices ASSIGNING <ls_list>.
        WHEN OTHERS.
          TRANSLATE ls_xml_line-cname TO UPPER CASE.
          ASSIGN COMPONENT ls_xml_line-cname OF STRUCTURE <ls_list> TO <lv_invoice_field>.
          IF sy-subrc = 0.
            <lv_invoice_field> = ls_xml_line-cvalue.
          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD incoming_archive_download.

    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lv_content      TYPE string,
          lv_key          TYPE string.


    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
  '<soapenv:Header>'
  '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
  '<wsse:UsernameToken>'
  '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
  '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
  '</wsse:UsernameToken>'
  '</wsse:Security>'
  '</soapenv:Header>'
  '<soapenv:Body>'
  '<ser:gibEarsivFaturaPdfAl>'
  '<input>{ "firmaVkn":"' mv_company_taxid
            '","mukellefVkn":"' iv_taxid
            '","faturaNo":"' is_document_numbers-docno '"}</input>'
  '</ser:gibEarsivFaturaPdfAl>'
  '</soapenv:Body>'
  '</soapenv:Envelope>'
  INTO lv_request_xml.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.

      IF ls_xml_line-cname  EQ 'key'.
        lv_key = ls_xml_line-cvalue.
      ENDIF.
      IF  lv_key = 'belgeIcerigi' AND ls_xml_line-cname EQ 'value'.
        CONCATENATE lv_content
                    ls_xml_line-cvalue
                    INTO lv_content.
      ENDIF.
    ENDLOOP.
    IF lv_content IS NOT INITIAL.
      rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_cancel.

    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring,
          lv_status       TYPE text255,
          lv_description  TYPE string,
          lv_message      TYPE bapi_msg,
          lx_exception    TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS:  <lv_return_field> TYPE any.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:faturaIptalEt>'
           '<input>'
              '{"faturaUuid":"' is_document_numbers-duich '"}'
           '</input>'
        '</ser:faturaIptalEt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/earsiv/ws/EarsivWebService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'resultCode'.
          lv_status = ls_xml_line-cvalue.
        WHEN 'resultText'.
          CONCATENATE lv_description ls_xml_line-cvalue INTO lv_description.
      ENDCASE.
    ENDLOOP.
    IF lv_status <> 'AE00000'.
*    IF lv_status <> 'AE00000' and lv_status <> 'AE00091'.
      lv_message = lv_description.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_download.
    DATA: lv_request_xml     TYPE string,
          lv_response_xml    TYPE string,
          lt_xml_table       TYPE TABLE OF smum_xmltb,
          ls_xml_line        TYPE smum_xmltb,
          lv_content         TYPE string,
          lv_zipped_file     TYPE xstring,
          lv_content_type(1).


    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CASE iv_content_type.
      WHEN 'PDF'.
        lv_content_type = '3'.
      WHEN 'UBL'.
        lv_content_type = '0'.
      WHEN 'HTML'.
        lv_content_type = '2'.
    ENDCASE.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:faturaSorgula>'
           '<input>'
              '{"faturaUuid":"' is_document_numbers-duich '",'
              '"vkn":"' mv_company_taxid '",'
              '"donenBelgeFormati":"' lv_content_type '"}'
           '</input>'
        '</ser:faturaSorgula>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/earsiv/ws/EarsivWebService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'belgeIcerigi'.
          CONCATENATE lv_content
              ls_xml_line-cvalue
              INTO lv_content.
      ENDCASE.
    ENDLOOP.
    IF lv_content IS NOT INITIAL.
      rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_get_status.

    TYPES: BEGIN OF ty_status,
             resultcode TYPE string,
             resulttext TYPE string,
           END OF ty_status.

    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring,
          ls_status       TYPE ty_status.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:faturaSorgula>'
           '<input>'
              '{"faturaUuid":"' is_document_numbers-duich '",'
              '"vkn":"' mv_company_taxid '",'
              '"donenBelgeFormati":"9"}'
           '</input>'
        '</ser:faturaSorgula>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/earsiv/ws/EarsivWebService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      TRANSLATE ls_xml_line-cname TO UPPER CASE.
      ASSIGN COMPONENT ls_xml_line-cname OF STRUCTURE ls_status TO <lv_return_field>.
      IF sy-subrc = 0.
        <lv_return_field> = ls_xml_line-cvalue.
      ENDIF.
    ENDLOOP.

    IF ls_status-resultcode EQ 'AE00000'. "İşlem başarılı
      rs_status-stacd = 'X'.
    ELSE.
      rs_status-stacd = '2'.
    ENDIF.
    rs_status-staex = ls_status-resulttext.

  ENDMETHOD.


  METHOD outgoing_invoice_preview.
    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          lv_content          TYPE string,
          lv_zipped_file      TYPE xstring,
          lv_invoice_base64   TYPE string,
          lv_document_uuid    TYPE /itetr/com_e_duich,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_content_type(1).

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = iv_ubl_xstring
      IMPORTING
        output = lv_invoice_base64.

    CASE iv_content_type.
      WHEN 'PDF'.
        lv_content_type = '3'.
      WHEN 'UBL'.
        lv_content_type = '0'.
      WHEN 'HTML'.
        lv_content_type = '2'.
    ENDCASE.

    lv_document_uuid = iv_document_uuid.
    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = 'ERPCODE'.

    CONCATENATE
 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
      '<ser:faturaOnizleme>'
           '<input>'
              '{ "islemId":"' lv_document_uuid '",'
                 '"vkn":"' mv_company_taxid '",'
                '"sube":"DFLT",'
                '"kasa":"DFLT",'
                '"donenBelgeFormati":"' lv_content_type '",'
                '"erpKodu":"' ls_custom_parameter-value '"}'
           '</input>'
         '<fatura>'
            '<belgeFormati>UBL</belgeFormati>'
            '<belgeIcerigi>' lv_invoice_base64 '</belgeIcerigi>'
         '</fatura>'
      '</ser:faturaOnizleme>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'belgeIcerigi'.
          CONCATENATE lv_content
              ls_xml_line-cvalue
              INTO lv_content.
      ENDCASE.
    ENDLOOP.

    IF lv_content IS NOT INITIAL.
      rv_invoice_data  = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_send.

    DATA: lv_invoice_base64   TYPE string,
          lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_content          TYPE string,
          lv_ubl_raw          TYPE xstring,
          lv_document_uuid    TYPE /itetr/com_e_duich,
          lv_message          TYPE bapi_msg,
          lx_exception        TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = iv_ubl_xstring
      IMPORTING
        output = lv_invoice_base64.

    lv_document_uuid = iv_document_uuid.
    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = 'ERPCODE'.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.earsiv.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:faturaOlustur>'
           '<input>'
              '{"vkn":"' mv_company_taxid '",'
              '"sube":"DFLT",'
              '"kasa":"DFLT",'
              '"islemId":"' lv_document_uuid '",'
              '"erpKodu":"' ls_custom_parameter-value '",'
              '"donenBelgeFormati":"9"}'
           '</input>'
           '<fatura>'
           '<belgeFormati>UBL</belgeFormati>'
           '<belgeIcerigi>' lv_invoice_base64 '</belgeIcerigi>'
           '</fatura>'
        '</ser:faturaOlustur>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/earsiv/ws/EarsivWebService'.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'belgeOid'.
    IF sy-subrc = 0.
      ev_integrator_uuid = ls_xml_line-cvalue.
    ENDIF.

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'resultCode'.
    IF sy-subrc = 0.
      IF ls_xml_line-cvalue NE 'AE00000'.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'resultText'.
        IF sy-subrc = 0.
          lv_message = ls_xml_line-cvalue.
        ENDIF.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                          iv_msgv1 = lv_message(50)
                                                                          iv_msgv2 = lv_message+50(50)
                                                                          iv_msgv3 = lv_message+100(50)
                                                                          iv_msgv4 = lv_message+150(50) ).
        RAISE EXCEPTION lx_exception.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.