class /ITETR/CL_PRRECEIPT_WS_EFN definition
  public
  inheriting from /ITETR/CL_PRRECEIPT_WS
  final
  create public .

public section.

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
private section.
ENDCLASS.



CLASS /ITETR/CL_PRRECEIPT_WS_EFN IMPLEMENTATION.


  METHOD outgoing_invoice_cancel.
    "mustahsilMakbuzIptalEt

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
       '<ser:mustahsilMakbuzIptalEt>'
           '<input>'
              '{"uuid":"' is_document_numbers-duich '"}'
           '</input>'
        '</ser:mustahsilMakbuzIptalEt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

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
    "mustahsilMakbuzOnizleme
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

    IF sy-sysid EQ 'NP4'.
      mv_company_taxid = '0000000039'.
    ENDIF.

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
       '<ser:mustahsilMakbuzSorgula>'
           '<input>'
              '{"vkn":"' mv_company_taxid '",'
              '"donenBelgeFormati":"' lv_content_type '",'
              '"uuid":"' is_document_numbers-duich '"}'
***              '"gzip":"1"}'
           '</input>'
        '</ser:mustahsilMakbuzSorgula>'
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
      rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
    "mustahsilMakbuzSorgula

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

    IF sy-sysid EQ 'NP4'.
      mv_company_taxid = '0000000039'.
    ENDIF.

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
       '<ser:mustahsilMakbuzSorgula>'
           '<input>'
              '{"vkn":"' mv_company_taxid '",'
              '"donenBelgeFormati":"9",'
              '"uuid":"' is_document_numbers-duich '"}'
           '</input>'
        '</ser:mustahsilMakbuzSorgula>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

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
      '<ser:mustahsilMakbuzOnizleme>'
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
      '</ser:mustahsilMakbuzOnizleme>'
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
    "mustahsilMakbuzOlustur

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
    IF sy-sysid NE 'NP4'.
      READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = 'ERPCODE'.
    ELSE.
      mv_company_taxid = '0000000039'.
    ENDIF.
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
       '<ser:mustahsilMakbuzOlustur>'
           '<input>'
              '{"islemId":"' lv_document_uuid '",'
              '"vkn":"' mv_company_taxid '",'
              '"sube":"DFLT",'
              '"kasa":"DFLT",'
              '"donenBelgeFormati":"9",'
***              '"gzip":"1",'
              '"erpKodu":"' ls_custom_parameter-value '"}'
           '</input>'
           '<belge>'
           '<belgeFormati>UBL</belgeFormati>'
           '<belgeIcerigi>' lv_invoice_base64 '</belgeIcerigi>'
           '</belge>'
        '</ser:mustahsilMakbuzOlustur>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.


    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
***    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'uuid'.
***    IF sy-subrc = 0.
***      ev_integrator_uuid = ls_xml_line-cvalue.
***    ENDIF.

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