class /ITETR/CL_EINVOICE_WS_BIM definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
  final
  create public .

public section.

  methods SET_INCOMING_INVOICE_RECEIVED
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DUICH
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods READ_FILE
    importing
      !IV_SRVPATH type /ITETR/COM_E_SFTPPATH
      !IV_FILENAM type FILENAME_AL11
    exporting
      !EV_FILEDAT type DB2_T_STRING
      !EV_FILEXSTRING type XSTRING
    returning
      value(RT_RETURN) type BAPIRET2
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods RUN_COMMAND
    importing
      !IM_COMMANDNAME type SXPGLOGCMD
      value(IM_PARAMETER) type BTCXPGPAR
    exporting
      !EV_STATUS type BTCXPGSTAT
      !EV_EXIT_CODE type BTCXPGEXIT
      !ET_PROTOCOL type DBA_EXEC_PROTOCOL
    returning
      value(RT_RETURN) type BAPIRET2_TAB
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .

  methods DOWNLOAD_REGISTERED_TAXPAYERS
    redefinition .
  methods DOWNLOAD_REGISTERED_TAXP_TIME
    redefinition .
  methods GET_INCOMING_INVOICES
    redefinition .
  methods INCOMING_INVOICE_DOWNLOAD
    redefinition .
  methods INCOMING_INVOICE_GET_STATUS
    redefinition .
  methods INCOMING_INVOICE_RESPONSE
    redefinition .
  methods OUTGOING_INVOICE_CANCEL
    redefinition .
  methods OUTGOING_INVOICE_DOWNLOAD
    redefinition .
  methods OUTGOING_INVOICE_GET_EXPORT
    redefinition .
  methods OUTGOING_INVOICE_GET_STATUS
    redefinition .
  methods OUTGOING_INVOICE_PREVIEW
    redefinition .
  methods OUTGOING_INVOICE_RESPONSE
    redefinition .
  methods OUTGOING_INVOICE_SEND
    redefinition .
  methods OUTGOING_INVOICE_SEND_AGAIN
    redefinition .
protected section.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ITETR/CL_EINVOICE_WS_BIM IMPLEMENTATION.


  METHOD download_registered_taxpayers.
*    DATA: lv_request_xml    TYPE string,
*          lv_response_xml   TYPE string,
*          lv_base64_content TYPE string,
*          lv_zipped_file    TYPE xstring,
*          lt_xml_table      TYPE TABLE OF smum_xmltb,
*          ls_xml_line       TYPE smum_xmltb,
*          lv_taxpayers_raw  TYPE xstring,
*          lv_taxpayers_xml  TYPE string,
*          lt_request_header TYPE mty_service_header_tab.
*    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
*                   <ls_taxpayer>       TYPE /itetr/inv_taxp.
*
*    CONCATENATE
*    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
*       '<soapenv:Header/>'
*       '<soapenv:Body>'
*          '<fat:EFaturaFirmalari>'
*             '<fat:Girdi>'
*                '<fat:Kimlik>'
*                   '<fat:Sistem></fat:Sistem>'
*                   '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
*                   '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
*                '</fat:Kimlik>'
*                '<fat:SorgulamaZamani>1900-01-01T00:00:00Z</fat:SorgulamaZamani>'
*                '<fat:VKN></fat:VKN>'
*             '</fat:Girdi>'
*          '</fat:EFaturaFirmalari>'
*       '</soapenv:Body>'
*    '</soapenv:Envelope>'
*
*    INTO lv_request_xml.
**    mv_request_url = '/Faturaservice.asmx'.
*
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'SOAPAction'.
*    <ls_request_header>-value = 'http://fatura.edoksis.net/EFaturaFirmalari'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'Content-Type'.
*    <ls_request_header>-value = 'text/xml; charset=utf-8'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'Accept-Encoding'.
*    <ls_request_header>-value = 'gzip,deflate,br'.
*
*    lv_response_xml = run_service( iv_request = lv_request_xml
*                                   it_request_header = lt_request_header ).
*    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
*    LOOP AT lt_xml_table INTO ls_xml_line.
*      CASE ls_xml_line-cname.
*        WHEN 'EFaturaFirma'.
*          APPEND INITIAL LINE TO rt_list ASSIGNING <ls_taxpayer>.
*        WHEN 'Identifier'.
*          <ls_taxpayer>-taxid = ls_xml_line-cvalue.
*        WHEN 'Alias'.
*          <ls_taxpayer>-aliass = ls_xml_line-cvalue.
*        WHEN 'Title'.
*          <ls_taxpayer>-title = ls_xml_line-cvalue.
*        WHEN 'Type'.
*          CASE ls_xml_line-cvalue.
*            WHEN 'Özel'.
*              <ls_taxpayer>-txpty = 'OZEL'.
*            WHEN 'Kamu'.
*              <ls_taxpayer>-txpty = 'KAMU'.
*          ENDCASE.
*        WHEN 'RegisterTime'.
*          CONCATENATE ls_xml_line-cvalue(4)
*                      ls_xml_line-cvalue+5(2)
*                      ls_xml_line-cvalue+8(2)
*                      INTO <ls_taxpayer>-regdt.
*          CONCATENATE ls_xml_line-cvalue+11(2)
*                      ls_xml_line-cvalue+14(2)
*                      ls_xml_line-cvalue+17(2)
*                      INTO <ls_taxpayer>-regtm.
*      ENDCASE.
*    ENDLOOP.

**************************************** FTP Serv **************************************************
    "YiğitcanÖ. 20092023

    DATA:
      lv_spath     TYPE /itetr/inv_einp-sftpsappath,
      lt_protocol  TYPE dba_exec_protocol,
      lv_filename  TYPE filename_al11 VALUE 'EFaturaFirmalari.zip',
      lt_filedat   TYPE db2_t_string,
      lv_message   TYPE bapi_msg,
      lx_exception TYPE REF TO /itetr/cx_regulative_exception,
      ls_return    TYPE bapiret2,
      lt_return    TYPE TABLE OF bapiret2.

    DATA: lv_taxpayers_raw TYPE xstring,
          ls_taxpayer      TYPE /itetr/inv_taxp..

****************************************************************************************************

    DATA(lv_pathtext) = |{ cl_abap_char_utilities=>newline }option batch abort { cl_abap_char_utilities=>newline }option confirm off { cl_abap_char_utilities=>newline }open sftp://{
                         ms_company_parameters-sftpusr }:{
                         ms_company_parameters-sftppwd }@sftp.sabancidx.com -hostkey="ssh-rsa 2048 CRb0k7HkaNTaNXqnhX4V4y2mwTDNkQurLg10/+lCEWU=" {
                         cl_abap_char_utilities=>newline }get -resumesupport=off -nopreservetime /{
                         lv_filename } { ms_company_parameters-sftpsappath }* { cl_abap_char_utilities=>newline }close { cl_abap_char_utilities=>newline }exit {
                         cl_abap_char_utilities=>newline }| .



    CLEAR: lv_spath.
    lv_spath = |{ ms_company_parameters-sftpsappath }getuserlist.txt|.
    OPEN DATASET lv_spath FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
    IF sy-subrc IS INITIAL.
      TRANSFER lv_pathtext TO lv_spath.
    ELSE.
      lv_message = 'Dataset Error'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message
                                                                       ).
      RAISE EXCEPTION lx_exception.

    ENDIF.
    CLOSE DATASET lv_spath.

    CLEAR: lt_protocol[].

    me->run_command(
         EXPORTING
           im_commandname = CONV #( ms_company_parameters-commname )
           im_parameter   = CONV #( lv_spath )
         IMPORTING
           et_protocol    = lt_protocol
           RECEIVING
           rt_return      = lt_return
           ).
    DELETE DATASET lv_spath.
    READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
    IF sy-subrc EQ 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = ls_return-number
                                                                        iv_msgv1 = ls_return-message_v1
                                                                        iv_msgv2 = ls_return-message_v2
                                                                        iv_msgv3 = ls_return-message_v3
                                                                        iv_msgv4 = ls_return-message_v4
                                                                       ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    CLEAR : ls_return,lt_return.

    DATA : lv_filexsting TYPE xstring.

    me->read_file(
      EXPORTING
        iv_srvpath     = ms_company_parameters-sftpsappath
        iv_filenam     = lv_filename
      IMPORTING
        ev_filedat     = lt_filedat
        ev_filexstring = lv_filexsting
      RECEIVING
        rt_return      = ls_return ).

    IF ls_return-type EQ 'E'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = ls_return-number
                                                                        iv_msgv1 = ls_return-message_v1
                                                                        iv_msgv2 = ls_return-message_v2
                                                                        iv_msgv3 = ls_return-message_v3
                                                                        iv_msgv4 = ls_return-message_v4
                                                                       ).
      RAISE EXCEPTION lx_exception.
    ELSE.
      DATA : lv_taxpayers_xml TYPE string,
             ls_user_list     TYPE /itetr/inv_s_userlist,
             ls_user_list2    TYPE /itetr/inv_s_userlist.

**      /itetr/cl_regulative_common=>unzip_file_single(
**        EXPORTING
***          iv_zipped_file_str = lv_filedat
**          iv_zipped_file_xstr = lv_filexsting
**        IMPORTING
**          ev_output_data_str = lv_taxpayers_xml ).

      "begin partial for memory

      DATA: lo_zip           TYPE REF TO cl_abap_zip,
            lv_input_xstring TYPE xstring,
            ls_file          TYPE cl_abap_zip=>t_file,
            lv_file_name     TYPE string,
            lv_xml_xstring   TYPE xstring,
            lv_xml_xstring1  TYPE xstring,
            lv_xml_xstring2  TYPE xstring,
            lv_xml_xstring3  TYPE xstring.


      lv_input_xstring = lv_filexsting.
      .
      CREATE OBJECT lo_zip.
      lo_zip->load(
        EXPORTING
          zip             = lv_input_xstring
        EXCEPTIONS
          zip_parse_error = 1
          OTHERS          = 2 ).
      CHECK sy-subrc IS INITIAL.

      READ TABLE lo_zip->files INTO ls_file INDEX 1.
      CHECK sy-subrc IS INITIAL.

      lv_file_name = ls_file-name.
      lo_zip->get(
        EXPORTING
          name                    = lv_file_name
        IMPORTING
          content                 = lv_xml_xstring
        EXCEPTIONS
          zip_index_error         = 1
          zip_decompression_error = 2
          OTHERS                  = 3 ).


      DATA: lv_user_list_e TYPE xstring , "</UserList>
            lv_user_s      TYPE xstring . "<User>

      DATA: lt_user_open TYPE match_result_tab,
            ls_userss    LIKE LINE OF lt_user_open.

      DATA: lv_proc_xml TYPE xstring,
            lv_count    TYPE i.

      DATA: lv_start_i TYPE i,
            lv_end_i   TYPE i,
            lv_length  TYPE i,
            lv_cycle   TYPE i.

      DATA: lv_datum TYPE sy-datum,
            lv_uzeit TYPE sy-uzeit.



      lv_user_list_e = '3C2F557365724C6973743E'.
      lv_user_s = '3C557365723E'.

      DATA : lv_parcali TYPE /itetr/inv_eicp-value.
      DATA : lv_parca_sayi TYPE i.
      SELECT SINGLE value FROM /itetr/inv_eicp INTO lv_parcali WHERE cuspa = 'PARTITE'.
      IF lv_parcali IS NOT INITIAL.
        lv_parca_sayi = lv_parcali.
      ELSE.
        lv_parca_sayi = 100000.
      ENDIF.

      lv_cycle = lv_parca_sayi + 1.

      lv_datum = sy-datum.
      lv_uzeit = sy-uzeit.

      FIND ALL OCCURRENCES OF lv_user_s IN lv_xml_xstring IN BYTE MODE RESULTS lt_user_open.

      READ TABLE lt_user_open INTO ls_userss INDEX 1.
      lv_start_i = ls_userss-offset.
      CLEAR ls_userss.

      DO.

        FIND ALL OCCURRENCES OF lv_user_s IN lv_xml_xstring IN BYTE MODE RESULTS lt_user_open.
        DESCRIBE TABLE lt_user_open LINES lv_count.

        "IF lv_count LE 100000.
        IF lv_count LE lv_parca_sayi.

          lv_taxpayers_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_xml_xstring ).

          CALL TRANSFORMATION /itetr/inv_userlist
            SOURCE XML lv_taxpayers_xml
            RESULT userlist = ls_user_list2.
          APPEND LINES OF ls_user_list2-user TO ls_user_list-user.


          EXIT.
        ELSE.

          READ TABLE lt_user_open INTO ls_userss INDEX lv_cycle.

          lv_end_i = ls_userss-offset.
          lv_length = ls_userss-offset - lv_start_i.
          CONCATENATE  lv_xml_xstring(lv_end_i)
                       lv_user_list_e
                INTO lv_proc_xml IN BYTE MODE.

          lv_length = xstrlen( lv_xml_xstring ).
          lv_length = lv_length - lv_end_i.

          lv_xml_xstring1 = lv_xml_xstring(lv_start_i).
          lv_xml_xstring2 =  lv_xml_xstring+lv_end_i(lv_length).

*        CONCATENATE  lv_xml_xstring(lv_start_i)
*                     lv_xml_xstring+lv_end_i(lv_length)
*              INTO lv_xml_xstring IN BYTE MODE.

          CLEAR lv_xml_xstring.
          CONCATENATE  lv_xml_xstring1
                       lv_xml_xstring2
                INTO lv_xml_xstring3 IN BYTE MODE.

          lv_xml_xstring = lv_xml_xstring3.

          CLEAR: lv_xml_xstring3,
                 lv_xml_xstring2,
                 lv_xml_xstring1.

          lv_taxpayers_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_proc_xml ).

          CALL TRANSFORMATION /itetr/inv_userlist
            SOURCE XML lv_taxpayers_xml
            RESULT userlist = ls_user_list2.

          APPEND LINES OF ls_user_list2-user TO ls_user_list-user.


          CLEAR lv_proc_xml.
          CLEAR lv_taxpayers_xml.
          CLEAR ls_user_list2.

        ENDIF.

      ENDDO.


      " end partial for memory


*      CALL TRANSFORMATION /itetr/inv_userlist
*        SOURCE XML lv_taxpayers_xml
*        RESULT userlist = ls_user_list.

      DATA: lv_deletion_date TYPE datum.
      DATA : lt_default_allias TYPE TABLE OF /itetr/inv_allis.
      SELECT * FROM /itetr/inv_allis INTO TABLE lt_default_allias .
      "SELECT * FROM /itetr/inv_taxp INTO TABLE lt_default_allias.
      SORT lt_default_allias BY taxid aliass.


      LOOP AT ls_user_list-user INTO DATA(ls_list).

        ls_taxpayer-taxid  = ls_list-identifier.
        ls_taxpayer-title  = ls_list-title.
        ls_taxpayer-txpty  = ls_list-type.

        LOOP AT ls_list-documents INTO DATA(ls_document) WHERE document = 'Invoice'.

          LOOP AT ls_document-alias INTO DATA(ls_alias) .

            CHECK ls_alias-deletiontime IS INITIAL.
            CONCATENATE ls_alias-creationtime(4)
                        ls_alias-creationtime+5(2)
                        ls_alias-creationtime+8(2)
                        INTO ls_taxpayer-regdt.
            CONCATENATE ls_alias-creationtime+11(2)
                        ls_alias-creationtime+14(2)
                        ls_alias-creationtime+17(2)
                        INTO ls_taxpayer-regtm.

            CLEAR: lv_deletion_date."gkadioglu
            IF ls_alias-deletiontime IS NOT INITIAL.
              lv_deletion_date = ls_alias-deletiontime(8).
            ENDIF.


            IF lv_deletion_date LE sy-datum AND lv_deletion_date IS NOT INITIAL.
              CHECK 1 = 2.
            ENDIF.

            ls_taxpayer-aliass = ls_alias-name.

            READ TABLE lt_default_allias TRANSPORTING NO FIELDS WITH KEY taxid  = ls_taxpayer-taxid
                                                                         aliass = ls_taxpayer-aliass  BINARY SEARCH.
            IF sy-subrc  IS INITIAL.
              ls_taxpayer-defal = 'X'.
            ENDIF.


            APPEND ls_taxpayer TO rt_list.
            CLEAR: ls_taxpayer-defal.
          ENDLOOP.

        ENDLOOP.

        CLEAR ls_taxpayer.

      ENDLOOP.

    ENDIF.


****************************************************************************************************YiğitcanÖ. 20092023
  ENDMETHOD.


  METHOD DOWNLOAD_REGISTERED_TAXP_TIME.

  ENDMETHOD.


  METHOD get_incoming_invoices.
    DATA: lv_request_xml       TYPE string,
          lv_response_xml      TYPE string,
          lv_base64_content    TYPE string,
          lv_zipped_file       TYPE xstring,
          lt_xml_table         TYPE TABLE OF smum_xmltb,
          ls_xml_line          TYPE smum_xmltb,
          lv_taxpayers_raw     TYPE xstring,
          lv_taxpayers_xml     TYPE string,
          lt_request_header    TYPE mty_service_header_tab,
          lv_invui             TYPE /itetr/com_e_duich.
    DATA: lv_taraf      TYPE text1000,
          lv_difference TYPE i.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.


    CONCATENATE
   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
   '<soapenv:Header/>'
   '<soapenv:Body>'
      '<fat:GelenFaturaListeleme>'
         '<fat:Girdi>'
            '<fat:Kimlik>'
             '<fat:Sistem></fat:Sistem>'
               '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
               '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
            '</fat:Kimlik>'
            '<fat:Mukellef>'
               '<fat:KimlikNO>' mv_company_taxid '</fat:KimlikNO>'
            '</fat:Mukellef>'
            '<fat:FaturaDuzenlemeTarihiBaslangic>' iv_date_from+0(4) '-' iv_date_from+4(2) '-' iv_date_from+6(2) 'T00:00:00Z</fat:FaturaDuzenlemeTarihiBaslangic>'
            '<fat:FaturaDuzenlemeTarihiBitis>'     iv_date_to+0(4) '-' iv_date_to+4(2) '-' iv_date_to+6(2) 'T23:59:59Z</fat:FaturaDuzenlemeTarihiBitis>'
            '<fat:SubelerideIslemle>false</fat:SubelerideIslemle>'
            '<fat:KullaniciGrubu></fat:KullaniciGrubu>'
            '<fat:FaturaETTN></fat:FaturaETTN>'
            '<fat:TarihFormati>UTC</fat:TarihFormati>'
            '<fat:ErpNumarasi></fat:ErpNumarasi>'
         '</fat:Girdi>'
      '</fat:GelenFaturaListeleme>'
   '</soapenv:Body>'
'</soapenv:Envelope>'

INTO lv_request_xml.
*    mv_request_url = '/Faturaservice.asmx'.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/GelenFaturaListeleme'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'Host'.
*    <ls_request_header>-value = 'wstestefatura.edoksis.net'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).


    LOOP AT lt_xml_table INTO DATA(ls_xml_table).
      CASE ls_xml_table-cname.
        WHEN 'GelenFaturaListelemeYapisi'.
          APPEND INITIAL LINE TO rt_list ASSIGNING FIELD-SYMBOL(<fs_fatura>).
          <fs_fatura>-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
          <fs_fatura>-bukrs = ms_company_parameters-bukrs.
        WHEN 'ZarfETTN'.
          <fs_fatura>-envui = ls_xml_table-cvalue.
        WHEN 'FaturaETTN'.
          <fs_fatura>-invui = ls_xml_table-cvalue.
          <fs_fatura>-invqi = ls_xml_table-cvalue.
        WHEN 'FaturaNo'.
          <fs_fatura>-invno = ls_xml_table-cvalue.
        WHEN 'Satici'.
          DATA(lv_satici) = 'X'.
        WHEN 'KimlikNO'.
          IF lv_satici IS NOT INITIAL.
            <fs_fatura>-taxid = ls_xml_table-cvalue.
            CLEAR lv_satici.
          ENDIF.
        WHEN 'PKEtiketi'.
          <fs_fatura>-aliass = ls_xml_table-cvalue.
        WHEN 'FaturaDuzenlemeZamani'.
          <fs_fatura>-bldat = ls_xml_table-cvalue+0(4) && ls_xml_table-cvalue+5(2) && ls_xml_table-cvalue+8(2).
        WHEN 'OlusturmaZamani'.
          <fs_fatura>-recdt = ls_xml_table-cvalue+0(4) && ls_xml_table-cvalue+5(2) && ls_xml_table-cvalue+8(2).
        WHEN 'OdenecekTutar'.
          <fs_fatura>-wrbtr = ls_xml_table-cvalue.
        WHEN 'ToplamVergiTutari'.
          IF <fs_fatura>-fwste EQ 0.
            <fs_fatura>-fwste = ls_xml_table-cvalue.
          ENDIF.
        WHEN 'BelgeParaBirimiKoduDonusmus'.
          <fs_fatura>-waers = ls_xml_table-cvalue.
        WHEN 'Senaryo'.
          CALL FUNCTION 'CONVERSION_EXIT_YYPRF_INPUT'
            EXPORTING
              input  = ls_xml_table-cvalue
            IMPORTING
              output = <fs_fatura>-prfid.
        WHEN 'FaturaTipi'.
          CALL FUNCTION 'CONVERSION_EXIT_YYINT_INPUT'
            EXPORTING
              input  = ls_xml_table-cvalue
            IMPORTING
              output = <fs_fatura>-invty.
      ENDCASE.
    ENDLOOP.
    LOOP AT rt_list ASSIGNING <fs_fatura>.
      IF <fs_fatura>-prfid = 'TEMEL'.
        <fs_fatura>-resst = 'X'.
      ELSE.
        <fs_fatura>-resst = '0'.
        lv_difference = sy-datum - <fs_fatura>-recdt.
        IF lv_difference GT 8.
          <fs_fatura>-resst = '2'.
        ENDIF.
      ENDIF.

      SELECT SINGLE invui
          FROM /itetr/inv_icinv
          INTO lv_invui
          WHERE bukrs = ms_company_parameters-bukrs
            AND invui = <fs_fatura>-invui.
      IF sy-subrc NE 0.
        <fs_fatura>-aprvd = abap_true.
        IF <fs_fatura>-wrbtr IS INITIAL.
          <fs_fatura>-procs = abap_true.
        ENDIF.
        INSERT /itetr/inv_icinv FROM <fs_fatura>.
        COMMIT WORK AND WAIT.
        IF sy-subrc EQ 0.
          set_incoming_invoice_received( <fs_fatura>-invui ).
        ENDIF.
      ELSE.
        CLEAR <fs_fatura>-docui.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD incoming_invoice_download.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_raw  TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_content        TYPE string.
    DATA: lx_exception 	    TYPE REF TO /itetr/cx_regulative_exception.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.

    DATA(lv_format) = SWITCH char1( iv_content_type WHEN 'UBL'  THEN '1'
                                                    WHEN 'PDF'  THEN '2'
                                                    WHEN 'HTML' THEN '3'  ).

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<fat:FaturaIndir>'
         '<fat:Girdi>'
                '<fat:Kimlik>'
                   '<fat:Sistem></fat:Sistem>'
                   '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                   '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
                '</fat:Kimlik>'
            '<fat:FaturaETTN>' is_document_numbers-duich '</fat:FaturaETTN>'
            '<fat:Tipi>1</fat:Tipi>'
            '<fat:Format>' lv_format '</fat:Format>'
            '<fat:Pozisyon>1</fat:Pozisyon>'
         '</fat:Girdi>'
      '</fat:FaturaIndir>'
   '</soapenv:Body>'
'</soapenv:Envelope>'

    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaIndir'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).


    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Sonuc'.
    IF ls_xml_line-cvalue  EQ '1'.

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'Icerik'.
            CONCATENATE lv_content
                ls_xml_line-cvalue
                INTO lv_content.
        ENDCASE.
      ENDLOOP.
      IF lv_content IS NOT INITIAL.
        rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
      ENDIF.

    ELSE.
      CLEAR ls_xml_line.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Mesaj'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_xml_line-cvalue(50)
                                                                       iv_msgv2 = ls_xml_line-cvalue+50(50)
                                                                       iv_msgv3 = ls_xml_line-cvalue+100(50)
                                                                       iv_msgv4 = ls_xml_line-cvalue+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

  ENDMETHOD.


  METHOD incoming_invoice_get_status.

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_raw  TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_resst          TYPE char1.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.

*    IF is_document_numbers-envui IS NOT INITIAL.
*
*    CONCATENATE
*    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
*    '<soapenv:Header/>'
*    '<soapenv:Body>'
*      '<fat:FaturaSorgulama>'
*         '<fat:Girdi>'
*            '<fat:Kimlik>'
*               '<fat:Sistem></fat:Sistem>'
*               '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
*               '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
*            '</fat:Kimlik>'
*            '<fat:ZarfETTN>' is_document_numbers-envui '</fat:ZarfETTN>'
*         '</fat:Girdi>'
*      '</fat:FaturaSorgulama>'
*   '</soapenv:Body>'
*'</soapenv:Envelope>'
*
*   INTO lv_request_xml.
**    mv_request_url = '/Faturaservice.asmx'.
*
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'SOAPAction'.
*    <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaSorgulama'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'Content-Type'.
*    <ls_request_header>-value = 'text/xml; charset=utf-8'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'Accept-Encoding'.
*    <ls_request_header>-value = 'gzip,deflate,br'.
*
*    lv_response_xml = run_service( iv_request = lv_request_xml
*                                   it_request_header = lt_request_header ).
*    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
*
*    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Durum'.
*    IF sy-subrc IS INITIAL.
*      rs_status-radsc = ls_xml_line-cvalue.
*    ENDIF.
*
*    IF rs_status-radsc IS NOT INITIAL.
*      SELECT SINGLE *
*        FROM /itetr/inv_inst
*        INTO @DATA(ls_int_status)
*        WHERE intid = 'BIM'
*          AND radsc = @rs_status-radsc.
*      IF sy-subrc IS INITIAL.
*        MOVE-CORRESPONDING ls_int_status TO rs_status.
*        SELECT SINGLE bezei
*          FROM /itetr/inv_instx
*          INTO rs_status-staex
*          WHERE spras = sy-langu
*            AND intid = 'BIM'
*            AND insta = ls_int_status-insta.
*      ENDIF.
*
*    ENDIF.
*
*   ENDIF.

    IF is_document_numbers-duich IS NOT INITIAL.

      CLEAR: lv_request_xml,lt_request_header,lv_response_xml,lt_xml_table, rs_status-resst.
      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<fat:FaturaStatuSorgulama>'
          '<fat:Girdi>'
             '<fat:Kimlik>'
               '<fat:Sistem></fat:Sistem>'
                 '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                 '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
              '</fat:Kimlik>'
              '<fat:FaturaETTN>' is_document_numbers-duich '</fat:FaturaETTN>'
              '<fat:Giden>false</fat:Giden>'
           '</fat:Girdi>'
        '</fat:FaturaStatuSorgulama>'
     '</soapenv:Body>'
  '</soapenv:Envelope>'
  INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaStatuSorgulama'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Accept-Encoding'.
      <ls_request_header>-value = 'gzip,deflate,br'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     it_request_header = lt_request_header ).
      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Statu'.
      IF sy-subrc IS INITIAL AND ( ls_xml_line-cvalue EQ 'KABUL' OR ls_xml_line-cvalue EQ 'RED' ).
        CASE ls_xml_line-cvalue.
          WHEN 'KABUL'.
            rs_status-resst = '2'.
          WHEN 'RED'.
            rs_status-resst = '1'.
        ENDCASE.
      ELSE.
        "" Edoksis servisinde response statusu geç güncellendiği için cevap tabloya atılıp oradan okunuyor.
        SELECT SINGLE resst FROM /itetr/inv_icinv
          INTO lv_resst
          WHERE docui EQ is_document_numbers-docui.
        IF lv_resst EQ '1' OR lv_resst EQ '2'.
          rs_status-resst = lv_resst.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD incoming_invoice_response.

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_raw  TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_request_header TYPE mty_service_header_tab.
    DATA: lv_resst TYPE /itetr/inv_icinv-resst.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.

    CHECK iv_response EQ 'KABUL' OR iv_response EQ 'RED'.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<fat:CevapVer>'
         '<fat:Girdi>'
            '<fat:Kimlik>'
               '<fat:Sistem></fat:Sistem>'
               '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
               '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
            '</fat:Kimlik>'
            '<fat:FaturaETTN>' is_document_numbers-duich '</fat:FaturaETTN>'
            '<fat:Cevap>' iv_response '</fat:Cevap>'
            '<fat:Aciklama>' iv_note '</fat:Aciklama>'
         '</fat:Girdi>'
      '</fat:CevapVer>'
   '</soapenv:Body>'
'</soapenv:Envelope>'

   INTO lv_request_xml.
*    mv_request_url = '/Faturaservice.asmx'.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/CevapVer'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    "" Edoksis servisinde response statusu geç güncellendiği için cevap tabloya atılıp oradan okunuyor.
    CASE iv_response.
      WHEN 'KABUL'.
        lv_resst = '2'.
      WHEN 'RED'.
        lv_resst = '1'.
    ENDCASE.

    UPDATE /itetr/inv_icinv
       SET resst = lv_resst
     WHERE docui EQ is_document_numbers-docui.
    IF sy-subrc IS INITIAL.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_cancel.

  ENDMETHOD.


  METHOD outgoing_invoice_download.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_raw  TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_content        TYPE string.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.

    DATA(lv_format) = SWITCH char1( iv_content_type WHEN 'UBL'  THEN '1'
                                                    WHEN 'PDF'  THEN '2'
                                                    WHEN 'HTML' THEN '3'  ).

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<fat:FaturaIndir>'
         '<fat:Girdi>'
                '<fat:Kimlik>'
                   '<fat:Sistem></fat:Sistem>'
                   '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                   '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
                '</fat:Kimlik>'
            '<fat:FaturaETTN>' is_document_numbers-duich '</fat:FaturaETTN>'
            '<fat:Tipi>2</fat:Tipi>'
            '<fat:Format>' lv_format '</fat:Format>'
            '<fat:Pozisyon>1</fat:Pozisyon>'
         '</fat:Girdi>'
      '</fat:FaturaIndir>'
   '</soapenv:Body>'
'</soapenv:Envelope>'

    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaIndir'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    DATA: lx_exception 	    TYPE REF TO /itetr/cx_regulative_exception.
    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Sonuc'.
    IF ls_xml_line-cvalue  EQ '1'.

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'Icerik'.
            CONCATENATE lv_content
                ls_xml_line-cvalue
                INTO lv_content.
        ENDCASE.
      ENDLOOP.
      IF lv_content IS NOT INITIAL.
        rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
      ENDIF.

    ELSE.
      CLEAR ls_xml_line.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Mesaj'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_xml_line-cvalue(50)
                                                                       iv_msgv2 = ls_xml_line-cvalue+50(50)
                                                                       iv_msgv3 = ls_xml_line-cvalue+100(50)
                                                                       iv_msgv4 = ls_xml_line-cvalue+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_get_export.

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_day(2),
          lv_month(2),
          lv_year(4).

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:fat="http://fatura.edoksis.net">'
    '<soap:Header/>'
    '<soap:Body>'
       '<fat:FaturaGTBReferansNoSorgulama>'
          '<fat:Girdi>'
             '<fat:Kimlik>'
                '<fat:Sistem></fat:Sistem>'
                '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                '<fat:Sifre>'     ms_company_parameters-wspwd '</fat:Sifre>'
             '</fat:Kimlik>'
             '<fat:FaturaETTN>' is_document_numbers-duich '</fat:FaturaETTN>'
          '</fat:Girdi>'
       '</fat:FaturaGTBReferansNoSorgulama>'
     '</soap:Body>'
   '</soap:Envelope>'
  INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaGTBReferansNoSorgulama'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service(
                        iv_request                  = lv_request_xml
                        it_request_header           = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    DATA: lx_exception 	    TYPE REF TO /itetr/cx_regulative_exception.

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Sonuc'.
    IF ls_xml_line-cvalue EQ '1'.
      LOOP AT lt_xml_table INTO ls_xml_line.
        TRANSLATE ls_xml_line-cname TO UPPER CASE.
        CASE ls_xml_line-cname.
          WHEN 'GTBFIILIIHRACATTARIHI'.
            SPLIT ls_xml_line-cvalue AT '-' INTO lv_year lv_month lv_day.
            IF lv_day CO ' 0123456789' AND lv_month CO ' 0123456789' AND lv_year CO ' 0123456789'.
              rs_status-raded(4)   = lv_year.
              rs_status-raded+4(2) = lv_month.
              rs_status-raded+6(2) = lv_day.
            ENDIF.
          WHEN 'GTBTESCILNO'.
            rs_status-cedrn = ls_xml_line-cvalue.
          WHEN 'GTBREFERANSNO'.
            rs_status-radrn = ls_xml_line-cvalue.
        ENDCASE.
      ENDLOOP.
      rs_status-stacd = '5'.
    ELSE.
      CLEAR ls_xml_line.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Mesaj'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_xml_line-cvalue(50)
                                                                       iv_msgv2 = ls_xml_line-cvalue+50(50)
                                                                       iv_msgv3 = ls_xml_line-cvalue+100(50)
                                                                       iv_msgv4 = ls_xml_line-cvalue+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.


  ENDMETHOD.


  METHOD outgoing_invoice_get_status.

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_raw  TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_int_status     TYPE /itetr/inv_inst.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.

    IF is_document_numbers-envui IS NOT INITIAL.

      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
        '<fat:FaturaSorgulama>'
           '<fat:Girdi>'
              '<fat:Kimlik>'
                 '<fat:Sistem></fat:Sistem>'
                 '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                 '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
              '</fat:Kimlik>'
              '<fat:ZarfETTN>' is_document_numbers-envui '</fat:ZarfETTN>'
           '</fat:Girdi>'
        '</fat:FaturaSorgulama>'
     '</soapenv:Body>'
  '</soapenv:Envelope>'

     INTO lv_request_xml.
*    mv_request_url = '/Faturaservice.asmx'.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaSorgulama'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Accept-Encoding'.
      <ls_request_header>-value = 'gzip,deflate,br'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     it_request_header = lt_request_header ).
      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Durum'.
      IF sy-subrc IS INITIAL.
        rs_status-radsc = ls_xml_line-cvalue.
      ENDIF.

      IF rs_status-radsc IS NOT INITIAL.
        SELECT SINGLE *
          FROM /itetr/inv_inst
          INTO ls_int_status
          WHERE intid = 'BIM'
            AND radsc = rs_status-radsc.
        IF sy-subrc IS INITIAL.
          MOVE-CORRESPONDING ls_int_status TO rs_status.
          SELECT SINGLE bezei
            FROM /itetr/inv_instx
            INTO rs_status-staex
            WHERE spras = sy-langu
              AND intid = 'BIM'
              AND insta = ls_int_status-insta.
        ENDIF.

      ENDIF.

    ENDIF.

    IF is_document_numbers-duich IS NOT INITIAL.

      CLEAR: lv_request_xml,lt_request_header,lv_response_xml,lt_xml_table, rs_status-resst.
      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<fat:FaturaStatuSorgulama>'
          '<fat:Girdi>'
             '<fat:Kimlik>'
               '<fat:Sistem></fat:Sistem>'
                 '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                 '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
              '</fat:Kimlik>'
              '<fat:FaturaETTN>' is_document_numbers-duich '</fat:FaturaETTN>'
              '<fat:Giden>true</fat:Giden>'
           '</fat:Girdi>'
        '</fat:FaturaStatuSorgulama>'
     '</soapenv:Body>'
  '</soapenv:Envelope>'
  INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaStatuSorgulama'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Accept-Encoding'.
      <ls_request_header>-value = 'gzip,deflate,br'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     it_request_header = lt_request_header ).
      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      "gkadioglu begin
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Sonuc'.
      IF sy-subrc IS INITIAL.
        CASE ls_xml_line-cvalue.
          WHEN '2'.
            rs_status-stacd = '2'.
        ENDCASE.
      ENDIF.
      IF rs_status-stacd EQ '2'.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Mesaj'.
        IF sy-subrc IS INITIAL.
          rs_status-staex = ls_xml_line-cvalue.
        ENDIF.
      ENDIF.
      "gkadioglu end

      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Statu'.
      IF sy-subrc IS INITIAL.
        CASE ls_xml_line-cvalue.
          WHEN 'KABUL' OR 'OTOKABUL'.
            rs_status-resst = '2'.
          WHEN 'RED'   OR 'OTORED'.
            rs_status-resst = '1'.
        ENDCASE.
      ENDIF.

      IF rs_status-resst EQ '1' OR rs_status-resst EQ '2'.
        rs_status-radsc = '1300'.
        SELECT SINGLE *
          FROM /itetr/inv_inst
          INTO ls_int_status
          WHERE intid = 'BIM'
            AND radsc = rs_status-radsc.
        IF sy-subrc IS INITIAL.
          rs_status-stacd = ls_int_status-stacd.
          SELECT SINGLE bezei
            FROM /itetr/inv_instx
            INTO rs_status-staex
            WHERE spras = sy-langu
              AND intid = 'BIM'
              AND insta = ls_int_status-insta.
        ENDIF.
      ENDIF.
    ENDIF.

    rs_status-envui = is_document_numbers-envui.
    rs_status-invui = is_document_numbers-duich.
    rs_status-invno = is_document_numbers-docno.

  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  method OUTGOING_INVOICE_RESPONSE.
  endmethod.


  METHOD outgoing_invoice_send.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_raw  TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_file_name      TYPE string,
          lv_content        TYPE string,
          lv_invoice_base64 TYPE string,
          lv_ubl_xml        TYPE string.

    DATA: lx_exception TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.
    lv_file_name = iv_document_uuid.
    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = iv_ubl_xstring
                                                                   iv_input_name = lv_file_name ).

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_invoice_base64.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<fat:ZarfGonder>'
        '<fat:Girdi>'
            '<fat:Kimlik>'
               '<fat:Sistem></fat:Sistem>'
               '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
               '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
             '</fat:Kimlik>'
            '<fat:Etiket>' iv_receiver_alias '</fat:Etiket>'
            '<fat:XSLTRumuzu></fat:XSLTRumuzu>'
            '<fat:Belgeler>'
               '<fat:UBLTRBelgesi>'
                  '<fat:Icerik>' lv_invoice_base64 '</fat:Icerik>'
                  '<fat:PKEtiketi></fat:PKEtiketi>'
                  '<fat:GBEtiketi></fat:GBEtiketi>'
                  '<fat:ERPInvoiceReference></fat:ERPInvoiceReference>'
                  '<fat:OlusturmaZamani>' sy-datum+0(4) '-' sy-datum+4(2) '-' sy-datum+6(2) 'T' sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2) 'Z</fat:OlusturmaZamani>'
               '</fat:UBLTRBelgesi>'
            '</fat:Belgeler>'
         '</fat:Girdi>'
      '</fat:ZarfGonder>'
   '</soapenv:Body>'
'</soapenv:Envelope>'

    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/ZarfGonder'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header
                                   iv_use_alternative_endpoint = 'X' ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Sonuc'.
    IF ls_xml_line-cvalue  EQ '1'.
      CLEAR ls_xml_line.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'ZarfETTN'.
      IF sy-subrc IS INITIAL.
        ev_envelope_uuid = ls_xml_line-cvalue.
      ENDIF.
    ELSE.
      CLEAR ls_xml_line.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Mesaj'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_xml_line-cvalue(50)
                                                                       iv_msgv2 = ls_xml_line-cvalue+50(50)
                                                                       iv_msgv3 = ls_xml_line-cvalue+100(50)
                                                                       iv_msgv4 = ls_xml_line-cvalue+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_send_again.
    outgoing_invoice_send(
      EXPORTING
        iv_document_uuid     = iv_document_uuid
        is_ubl_structure     = is_ubl_structure
        iv_ubl_xstring       = iv_ubl_xstring
        iv_ubl_hash          = iv_ubl_hash
        iv_receiver_alias    = iv_receiver_alias
        iv_receiver_taxid    = iv_receiver_taxid
        it_custom_parameters = it_custom_parameters
      IMPORTING
        ev_envelope_uuid     = ev_envelope_uuid
    ).
  ENDMETHOD.


  METHOD read_file.
    CONSTANTS: c_funcname TYPE rs38l-name VALUE 'PFL_CHECK_DIRECTORY'.

    DATA: l_directory TYPE btch0000-text80,
          l_spath     TYPE char255. "yittr_130_d_sap_path.


    DATA: lv_xstring TYPE xstring. "YiğitcanÖ. 12102023.

    DATA l_path TYPE dstring.
    CLEAR: l_directory. l_directory = iv_srvpath.
    CALL FUNCTION c_funcname
      EXPORTING
        directory                   = l_directory
        write_check                 = abap_true
      EXCEPTIONS
        pfl_dir_not_exist           = 1
        pfl_permission_denied       = 2
        pfl_cant_build_dataset_name = 3
        pfl_file_not_exist          = 4
        pfl_authorization_missing   = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
*      rt_return = VALUE #( type = _cons_msg-error id = _cons_msg-id number = '004' message_v1 = iv_srvpath message_v2 = zcl_bc_winscp_toolkit=>exc_read_text( iv_funcname =  c_funcname iv_subrc = sy-subrc ) ). RETURN.
    ENDIF.

    CLEAR: l_spath.
    l_spath = |{ iv_srvpath }{ iv_filenam }|.

    OPEN DATASET l_spath FOR INPUT IN TEXT MODE ENCODING NON-UNICODE WITH WINDOWS LINEFEED.
    IF sy-subrc IS INITIAL.
      DO.
        READ DATASET l_spath INTO l_path.
        IF sy-subrc IS INITIAL.
          APPEND l_path TO ev_filedat.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ELSE.
*      rt_return = VALUE #( type = _cons_msg-error id = _cons_msg-id number = '006' message_v1 = l_spath ).
    ENDIF.

    CLOSE DATASET l_spath.

    OPEN DATASET l_spath FOR INPUT IN BINARY MODE. "YiğitcanÖ. 13101230
    READ DATASET l_spath INTO lv_xstring.          "YiğitcanÖ. 13101230
    CLOSE DATASET l_spath.                         "YiğitcanÖ. 13101230

    DELETE DATASET l_spath.
    ev_filexstring = lv_xstring.                   "YiğitcanÖ. 13101230

  ENDMETHOD.


  METHOD run_command.

    DATA: lv_error    TYPE char1,    "YiğitcanÖ. 16102023
          ls_protocol TYPE  btcxpm.  "YiğitcanÖ. 16102023

    im_parameter = |/script={ im_parameter }|.
    CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
      EXPORTING
        commandname                   = im_commandname
        additional_parameters         = im_parameter
      IMPORTING
        status                        = ev_status
        exitcode                      = ev_exit_code
      TABLES
        exec_protocol                 = et_protocol[]
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 4
        wrong_check_call_interface    = 5
        program_start_error           = 6
        program_termination_error     = 7
        x_error                       = 8
        parameter_expected            = 9
        too_many_parameters           = 10
        illegal_command               = 11
        wrong_asynchronous_parameters = 12
        cant_enq_tbtco_entry          = 13
        jobcount_generation_error     = 14
        OTHERS                        = 15.
    IF sy-subrc <> 0.
      rt_return = VALUE #( BASE rt_return ( type = sy-msgty
                                            id  = sy-msgid
                                            number = sy-msgno
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ). RETURN.
    ENDIF.

*    SELECT COUNT( * ) FROM @et_protocol AS itab
*      WHERE itab~message LIKE 'Error%'  OR
*            itab~message LIKE 'error%'  OR
*            itab~message LIKE '%Error%' OR
*            itab~message LIKE '%error%' OR
*            itab~message LIKE '%error%' OR
*            itab~message LIKE '%closed network connection%'
*            INTO @DATA(v_count).
*    IF v_count GT 0.
**      rt_return = VALUE #( BASE rt_return ( type = _cons_msg-error id  = _cons_msg-id number = '007' ) ).
*      LOOP AT et_protocol ASSIGNING FIELD-SYMBOL(<fs_protocol>).
**        rt_return = VALUE #( BASE rt_return ( type = _cons_msg-error
**                                              id  = _cons_msg-id
**                                              number = '000'
**                                              message_v1 = <fs_protocol>-message+0(50)
**                                              message_v2 = <fs_protocol>-message+50(50)
**                                              message_v3 = <fs_protocol>-message+100(28) ) ).
*      ENDLOOP.

    "YiğitcanÖ. 16102023
    LOOP AT et_protocol INTO ls_protocol.
      IF ls_protocol-message CP '*(Error|error)*' OR
         ls_protocol-message CP '*closed network connection*'.
        lv_error = 'X'.
      ENDIF.
    ENDLOOP.
    IF lv_error IS NOT INITIAL.
      APPEND VALUE #( type = 'E'
                   number = '000'
                   message_v1 = ls_protocol-message+0(50)
                   message_v2 = ls_protocol-message+50(50)
                   message_v3 = ls_protocol-message+100(28) ) TO rt_return.
    ENDIF.
    "YiğitcanÖ. 16102023

  ENDMETHOD.


  METHOD set_incoming_invoice_received.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lt_request_header TYPE mty_service_header_tab.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
     '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
   '<soapenv:Header/>'
   '<soapenv:Body>'
      '<fat:FaturaAlindi>'
         '<fat:Girdi>'
            '<fat:Kimlik>'
               '<fat:Sistem></fat:Sistem>'
               '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
               '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
            '</fat:Kimlik>'
            '<fat:Satici>'
               '<fat:KimlikNO>' mv_company_taxid '</fat:KimlikNO>'
            '</fat:Satici>'
            '<fat:FaturaETTN>' iv_document_uuid '</fat:FaturaETTN>'
            '<fat:TersIslem>false</fat:TersIslem>'
            '<fat:Giden>false</fat:Giden>'
            '<fat:ErpNumarasi></fat:ErpNumarasi>'
         '</fat:Girdi>'
      '</fat:FaturaAlindi>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
      INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaAlindi'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

  ENDMETHOD.
ENDCLASS.