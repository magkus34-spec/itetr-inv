*&---------------------------------------------------------------------*
*& Report /itetr/inv_taxpayers_list
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/inv_taxpayers_list.

TABLES /itetr/inv_taxp.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_taxid FOR /itetr/inv_taxp-taxid,
                  s_budat FOR /itetr/inv_taxp-regdt,
                  s_title FOR /itetr/inv_taxp-title.
SELECTION-SCREEN END OF BLOCK b1.

DATA gt_list TYPE TABLE OF /itetr/inv_taxpayers_list.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  CHECK gt_list IS NOT INITIAL.
  PERFORM display_data.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       Get Data
*----------------------------------------------------------------------*
FORM get_data .
  CALL FUNCTION '/ITETR/INV_GET_TAXPAYERS'
    EXPORTING
      it_taxid_range = s_taxid[]
      it_regdt_range = s_budat[]
      it_title_range = s_title[]
    IMPORTING
      et_list        = gt_list.
*  SELECT z~taxid
*         z~aliass
*         z~title
*         z~regdt
*         z~regtm
*         z~defal
*         z~txpty
*         k~kunnr
*         k~name1 AS kunnm
*         l~lifnr
*         l~name1 AS lifnm
*    INTO TABLE gt_list
*    FROM /itetr/inv_taxp AS z
*    LEFT OUTER JOIN kna1 AS k
*      ON k~stcd2 = z~taxid
*    LEFT OUTER JOIN lfa1 AS l
*      ON l~stcd2 = z~taxid
*    WHERE z~taxid IN s_taxid
*      AND z~title IN s_title
*      AND z~regdt IN s_budat.
ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       Display Data
*----------------------------------------------------------------------*
FORM display_data .
  DATA: lt_fcat  TYPE lvc_t_fcat,
        ls_layo  TYPE lvc_s_layo,
        ls_vari  TYPE disvariant,
        lv_title TYPE lvc_title,
        lt_list  TYPE TABLE OF /itetr/inv_taxpayers_list,
        lv_count TYPE i.

  FIELD-SYMBOLS <ls_fcat> TYPE lvc_s_fcat.

  SORT gt_list BY taxid aliass kunnr lifnr.
  DELETE ADJACENT DUPLICATES FROM gt_list COMPARING taxid aliass.

  ls_vari-username = sy-uname.
  ls_vari-report = sy-repid.
  ls_vari-handle = 'LIST'.

  ls_layo-cwidth_opt = abap_true.
  ls_layo-zebra = abap_true.
  ls_layo-sel_mode = 'A'.

  lt_list = gt_list.
  SORT lt_list BY taxid.
  DELETE ADJACENT DUPLICATES FROM lt_list COMPARING taxid.
  DESCRIBE TABLE lt_list LINES lv_count.
  WRITE lv_count TO lv_title LEFT-JUSTIFIED.
  CONCATENATE TEXT-002 lv_title INTO lv_title SEPARATED BY space.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = '/ITETR/INV_TAXPAYERS_LIST'
      i_bypassing_buffer     = abap_true
      i_internal_tabname     = 'GT_LIST'
    CHANGING
      ct_fieldcat            = lt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    LOOP AT lt_fcat ASSIGNING <ls_fcat>.
      CASE <ls_fcat>-fieldname.
        WHEN 'DEFAL'.
          <ls_fcat>-checkbox = abap_true.
          <ls_fcat>-hotspot = abap_true.
      ENDCASE.
    ENDLOOP.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'ALV_USER_COMMAND'
      i_grid_title            = lv_title
      is_layout_lvc           = ls_layo
      it_fieldcat_lvc         = lt_fcat
      i_save                  = ' '
      is_variant              = ls_vari
    TABLES
      t_outtab                = gt_list
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " DISPLAY_DATA

*&---------------------------------------------------------------------*
*&      Form  ALV_USER_COMMAND
*&---------------------------------------------------------------------*
*       ALV User Command
*----------------------------------------------------------------------*
*      -->r_ucomm       Command
*      -->rs_selfield   Selected field info
*----------------------------------------------------------------------*
FORM alv_user_command USING r_ucomm LIKE sy-ucomm
                            rs_selfield TYPE slis_selfield.
  DATA: ls_return TYPE bapiret2.
  FIELD-SYMBOLS: <ls_list> TYPE /itetr/inv_taxpayers_list.

  CASE r_ucomm.
    WHEN '&IC1'.
      IF rs_selfield-fieldname = 'DEFAL'.
        READ TABLE gt_list ASSIGNING <ls_list> INDEX rs_selfield-tabindex.
        CHECK sy-subrc = 0.
        CALL FUNCTION '/ITETR/INV_TAXPAYER_CHG_DEFAL'
          EXPORTING
            iv_taxid         = <ls_list>-taxid
            iv_alias         = <ls_list>-aliass
          IMPORTING
            es_return        = ls_return
            ev_default_alias = <ls_list>-defal.
        IF ls_return IS NOT INITIAL.
          MESSAGE ID ls_return-id TYPE 'S' NUMBER ls_return-number
            WITH ls_return-message_v1 ls_return-message_v2
                 ls_return-message_v3 ls_return-message_v4
            DISPLAY LIKE ls_return-type.
        ELSE.
          rs_selfield-refresh = abap_true.
          rs_selfield-col_stable = abap_true.
          rs_selfield-row_stable = abap_true.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDFORM.                    "user_command