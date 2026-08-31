*&---------------------------------------------------------------------*
*& Report /ITETR/INV_TAXPAYERS_UPDATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/inv_taxpayers_update MESSAGE-ID /itetr/regulative.

PARAMETERS: p_bukrs TYPE bukrs OBLIGATORY.
PARAMETERS: p_upl   AS CHECKBOX.
PARAMETERS: p_zip   AS CHECKBOX.

DATA gs_return TYPE bapiret2.

INITIALIZATION.
  GET PARAMETER ID 'BUK' FIELD p_bukrs.

START-OF-SELECTION.
  IF p_upl IS INITIAL.
    CALL FUNCTION '/ITETR/INV_UPDATE_TAXPAYERS'
      EXPORTING
        iv_company = p_bukrs
      IMPORTING
        es_return  = gs_return.
    IF gs_return IS NOT INITIAL.
      MESSAGE ID gs_return-id TYPE 'I' NUMBER gs_return-number
        WITH gs_return-message_v1 gs_return-message_v2
             gs_return-message_v3 gs_return-message_v4
        DISPLAY LIKE gs_return-type.
    ELSE.
      MESSAGE s003.
    ENDIF.
  ELSE.

    PERFORM upload_txt.

  ENDIF.

FORM upload_txt.
  TYPES: BEGIN OF ty_itab,
           taxid  TYPE /itetr/inv_taxp-taxid,
           aliass TYPE /itetr/inv_taxp-aliass,
           title  TYPE /itetr/inv_taxp-title,
           regdt  TYPE char10, "/itetr/inv_taxp-regdt,
           regtm  TYPE char10, "/itetr/inv_taxp-regtm,
           defal  TYPE /itetr/inv_taxp-defal,
           txpty  TYPE /itetr/inv_taxp-txpty,
         END OF ty_itab.

  DATA: lt_itab TYPE TABLE OF ty_itab,
        ls_itab TYPE ty_itab,
        ls_line TYPE /itetr/inv_taxp.
  DATA : rt_list TYPE TABLE OF /itetr/inv_taxp.
  TYPES: BEGIN OF lty_upload,
           val(10000) TYPE c,
         END OF lty_upload.

  DATA:lt_file        TYPE filetable,
       ls_file        LIKE LINE OF lt_file,
       lv_return      TYPE i,
       lv_file_path   TYPE string,
       lt_upload      TYPE TABLE OF lty_upload,
       lv_file_length TYPE i.


  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    CHANGING
      file_table              = lt_file[]
      rc                      = lv_return
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0 OR lv_return EQ -1.
*    MOVE 4 TO gv_subrc.
    RETURN.
  ELSE.
    READ TABLE lt_file INTO ls_file INDEX 1.
    IF sy-subrc IS NOT INITIAL.
*      MOVE 4 TO gv_subrc.
      RETURN.
    ELSE.
      lv_file_path = ls_file-filename.
    ENDIF.
  ENDIF.

  DATA :lv_fname TYPE rlgrap-filename.
  DATA: BEGIN OF ls_taxp,
          taxid TYPE stcd2,
        END OF ls_taxp,
        lt_taxp     LIKE TABLE OF ls_taxp,
        lt_raw_data TYPE truxs_t_text_data,
        ls_data     TYPE /itetr/inv_s_incinv_list,
        ls_excel    TYPE /itetr/inv_s_incinv_excel.
  lv_fname = lv_file_path.
  IF p_zip IS INITIAL.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = lt_raw_data
        i_filename           = lv_fname
      TABLES
        i_tab_converted_data = lt_itab
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
*    IF sy-subrc <> 0.



    LOOP AT lt_itab INTO ls_itab .
      MOVE-CORRESPONDING ls_itab TO ls_line.
      CONCATENATE ls_itab-regdt+6(4) ls_itab-regdt+3(2) ls_itab-regdt+0(2) INTO ls_line-regdt.
      ls_line-regtm = '120000'.
      INSERT  /itetr/inv_taxp FROM ls_line.
      IF sy-subrc IS INITIAL.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDLOOP.

  ELSE.



    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
*          lt_request_header TYPE mty_service_header_tab,
          lv_sessionid      TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp,
          ls_user_list      TYPE /itetr/inv_s_userlist,
          ls_user           TYPE /itetr/inv_s_user,
          ls_documents      TYPE /itetr/inv_s_userlist_doc,
          ls_alias          TYPE /itetr/inv_s_userlist_alias,
          lv_base64_content TYPE string.



**    cl_gui_frontend_services=>gui_upload(
**       EXPORTING
**         filename                = lv_file_path
**         filetype                = 'BIN' " File Type
**       IMPORTING
**         filelength              = lv_file_length
**       CHANGING
**         data_tab                = lt_itab
**       EXCEPTIONS
**         file_open_error         = 1
**         OTHERS                  = 2
**     ).

    DATA: t_data_tab TYPE TABLE OF x255,
          bin_size   TYPE i,
          buffer_x   TYPE xstring,
          buffer_zip TYPE xstring,
          lv_fname2  TYPE string.

    CLEAR: t_data_tab[],bin_size.
    lv_fname2 = lv_file_path.
    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename   = lv_fname2
        filetype   = 'BIN'
      IMPORTING
        filelength = bin_size
*       header     =
      TABLES
        data_tab   = t_data_tab.


    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = bin_size
      IMPORTING
        buffer       = buffer_x
      TABLES
        binary_tab   = t_data_tab.


**    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
**      EXPORTING
**        input_length = bin_size
**      IMPORTING
**        text_buffer  = lv_base64_content
**      TABLES
**        binary_tab   = t_data_tab
**      EXCEPTIONS
**        failed       = 1
**        OTHERS       = 2.
**    IF sy-subrc <> 0.
***      CLEAR rv_output.
**    ENDIF.

**    lv_base64_content = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_input = buffer_x ).
**    lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).

    /itetr/cl_regulative_common=>unzip_file_single(
      EXPORTING
        iv_zipped_file_xstr = buffer_x "lv_zipped_file
        iv_get_rawstring   = 'X'
      IMPORTING
        ev_output_data_str = lv_taxpayers_xml ).

    CALL TRANSFORMATION /itetr/inv_userlist
      SOURCE XML lv_taxpayers_xml
      RESULT userlist = ls_user_list.

    LOOP AT ls_user_list-user INTO ls_user.
      CLEAR ls_taxpayer.
      CASE ls_user-type.
        WHEN 'OZEL'.
          ls_taxpayer-txpty = 'OZEL'.
        WHEN OTHERS.
          ls_taxpayer-txpty = 'KAMU'.
      ENDCASE.
      LOOP AT ls_user-documents INTO ls_documents WHERE document = 'Invoice' .
        LOOP AT ls_documents-alias INTO ls_alias WHERE deletiontime IS INITIAL.
          IF ls_alias IS NOT INITIAL.
            REPLACE ALL OCCURRENCES OF '-' IN ls_alias-creationtime WITH ''.
            REPLACE ALL OCCURRENCES OF ':' IN ls_alias-creationtime WITH ''.
            ls_taxpayer-regdt = ls_alias-creationtime(8).
            ls_taxpayer-regtm = ls_alias-creationtime+9(6).
          ENDIF.
          IF ls_alias-name IS NOT INITIAL.
            ls_taxpayer-aliass = ls_alias-name.
          ENDIF.
          ls_taxpayer-title = ls_user-title.
          ls_taxpayer-taxid = ls_user-identifier.
          APPEND ls_taxpayer TO rt_list.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    MODIFY /itetr/inv_taxp FROM TABLE rt_list.
    COMMIT WORK AND WAIT.

  ENDIF.

ENDFORM.