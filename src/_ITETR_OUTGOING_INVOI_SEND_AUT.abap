*&---------------------------------------------------------------------*
*& Report /ITETR/OUTGOING_DELIVERY_DRIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/outgoing_invoi_send_aut.


SET EXTENDED CHECK OFF.
INCLUDE astsotop.
SET EXTENDED CHECK ON.

*-> include RLB_INVOICE_DATA_DECLARE.
DATA: xscreen(1)   TYPE c.            "Output on printer or screen
DATA: repeat(1)    TYPE c.                                  "#EC NEEDED
*<- include RLB_INVOICE_DATA_DECLARE.


*$*$******************************************************************&*
*$*$--------  F I E L D - S Y M B O L S  -----------------------------&*
*$*$******************************************************************&*
FIELD-SYMBOLS: <gv_retcode> TYPE sysubrc.


SET EXTENDED CHECK OFF.
INCLUDE rlb_print_forms.
SET EXTENDED CHECK ON.



*&---------------------------------------------------------------------*
*&      Form  ENTRY
*&---------------------------------------------------------------------*
FORM entry USING return_code TYPE sy-subrc
                 us_screen   TYPE c.                        "#EC *
  DATA: lf_retcode TYPE sy-subrc.
*--------

* Assign RC
  ASSIGN lf_retcode TO <gv_retcode>.

  xscreen = us_screen.
  PERFORM processing CHANGING lf_retcode.
  IF lf_retcode IS NOT INITIAL.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*&---------------------------------------------------------------------*
*&      Form  PROCESSING
*&---------------------------------------------------------------------*
FORM processing CHANGING cf_retcode TYPE sy-subrc.
  DATA :
    lv_vbeln TYPE vbeln_vf,
    lv_mblnr TYPE mblnr,
    lv_mjahr TYPE mjahr.
*------
  DATA : lt_vbrk TYPE TABLE OF vbrk.
  DATA : ls_vbrk TYPE vbrk.
  DATA : lt_vbrp TYPE TABLE OF vbrp.
  DATA : ls_vbrp TYPE vbrp.
  DATA : ls_document TYPE /itetr/inv_oginv.
  DATA : ls_return TYPE bapiret2.
  DATA : lt_mkpf TYPE TABLE OF mkpf.
  DATA : ls_mkpf TYPE  mkpf.
*  DATA : ls_likp TYPE  likp.
  DATA : lv_bukrs TYPE bukrs.
  DATA : et_return TYPE  bapiret2_tab.
  DATA : lv_paramvalue TYPE  /itetr/inv_eicp-value.
  DATA : lv_parameter TYPE  /itetr/inv_eicp-cuspa.
  DATA : lt_inv_auto TYPE TABLE OF /itetr/inv_auto.
  DATA : ls_inv_auto TYPE /itetr/inv_auto.
  DATA : lv_background TYPE /itetr/com_e_value.
*  DATA : lt_lips TYPE TABLE OF lips.
*  DATA : ls_lips TYPE lips.
  CLEAR xscreen.


  CASE nast-objtype.
    WHEN 'VBRK'.
      lv_vbeln = nast-objky.

      DO 20 TIMES.
        SELECT * FROM vbrk INTO TABLE lt_vbrk WHERE vbeln = lv_vbeln.
        IF sy-subrc IS INITIAL.
          EXIT.
        ENDIF.
        WAIT UP TO '0.5' SECONDS.
      ENDDO.

      IF lt_vbrk[] IS NOT INITIAL.
        READ TABLE lt_vbrk INTO ls_vbrk INDEX 1.

        SELECT SINGLE value
            FROM /itetr/inv_eicp
            INTO  lv_paramvalue
        WHERE  bukrs = ls_vbrk-bukrs AND
         cuspa = 'NO_PGI_AUT'.
        IF lv_paramvalue IS NOT INITIAL.
          lv_parameter = 'NO_PGI_AUT'.
        ENDIF.

        SELECT * FROM /itetr/inv_auto INTO TABLE lt_inv_auto.

        SELECT * FROM vbrp INTO TABLE lt_vbrp WHERE vbeln = ls_vbrk-vbeln.

        READ TABLE lt_vbrp INTO ls_vbrp INDEX 1.

        LOOP AT lt_inv_auto INTO ls_inv_auto WHERE ( awtyp = 'VBRK' OR  awtyp = space ) AND
                                                   ( werks = ls_vbrp-werks OR werks = space ) AND
                                                   ( lgort = ls_vbrp-lgort OR lgort = space ).
          EXIT.
        ENDLOOP.

        IF sy-subrc IS INITIAL OR lt_inv_auto[] IS INITIAL.
          SELECT SINGLE value FROM /itetr/inv_eicp INTO lv_background WHERE cuspa = 'BACKGROUND'.
          IF lv_background IS NOT INITIAL.
            CALL FUNCTION '/ITETR/INV_OUTINV_SEND2TRA' IN BACKGROUND TASK
              EXPORTING
                iv_module    = 'SD'
                iv_bukrs     = ls_vbrk-bukrs
                it_vbrk      = lt_vbrk[]
                iv_parameter = 'NO_PGI_AUT'
              IMPORTING
                et_return    = et_return.
          ELSE.
            CALL FUNCTION '/ITETR/INV_OUTINV_SEND2TRA'
              EXPORTING
                iv_module    = 'SD'
                iv_bukrs     = ls_vbrk-bukrs
                it_vbrk      = lt_vbrk[]
                iv_parameter = 'NO_PGI_AUT'
              IMPORTING
                et_return    = et_return.
          ENDIF.
        ELSE.
          cf_retcode = 8.
        ENDIF.

***        CALL FUNCTION '/ITETR/INV_INVOICE_CHECK_SAVE' DESTINATION 'NONE'
***          EXPORTING
***            iv_awtyp    = 'VBRK'
***            iv_bukrs    = ls_vbrk-bukrs
***            iv_belnr    = ls_vbrk-belnr
***            iv_gjahr    = ls_vbrk-gjahr
***          IMPORTING
***            es_document = ls_document
***            es_return   = ls_return.
***
***        APPEND ls_return TO et_return.
      ENDIF.

***      DO 20 TIMES.
***        SELECT * FROM likp INTO TABLE lt_likp WHERE vbeln = lv_vbeln.
***        IF sy-subrc IS INITIAL.
***          EXIT.
***        ENDIF.
***        WAIT UP TO '0.5' SECONDS.
***      ENDDO.
***
***      IF lt_likp[] IS NOT INITIAL.
***
***        READ TABLE lt_likp INTO ls_likp INDEX 1.
***
***        SELECT SINGLE bukrs FROM tvko INTO lv_bukrs WHERE vkorg = ls_likp-vkorg.
***
***        SELECT SINGLE value
***            FROM /itetr/dlv_edcp
***            INTO  lv_paramvalue
***        WHERE  bukrs = lv_bukrs AND
***         cuspa = 'NO_PGI_AUT'.
***        IF lv_paramvalue IS NOT INITIAL.
***          lv_parameter = 'NO_PGI_AUT'.
***        ENDIF.
***
***        SELECT * FROM /itetr/dlv_auto INTO TABLE lt_dlv_auto.
***
***        SELECT * FROM lips INTO TABLE lt_lips WHERE vbeln = ls_likp-vbeln.
***
***        READ TABLE lt_lips INTO ls_lips INDEX 1.
***
***        LOOP AT lt_dlv_auto INTO ls_dlv_auto WHERE ( awtyp = 'LIKP' OR  awtyp = space ) AND
***                                                   ( werks = ls_lips-werks OR werks = space ) AND
***                                                   ( lgort = ls_lips-lgort OR lgort = space ).
***          EXIT.
***        ENDLOOP.
***
***        IF sy-subrc IS INITIAL OR lt_dlv_auto[] IS INITIAL.
***          DATA : lv_value TYPE /itetr/com_e_value.
***          SELECT SINGLE value FROM /itetr/dlv_edcp INTO lv_value WHERE cuspa = 'BACKGROUND'.
***          IF lv_value IS NOT INITIAL.
***            CALL FUNCTION '/ITETR/DLV_OUTDLV_SEND2TRA' IN BACKGROUND TASK
***              EXPORTING
***                iv_module    = 'SD'
***                iv_bukrs     = lv_bukrs
***                it_likp      = lt_likp[]
***                iv_parameter = 'NO_PGI_AUT'
***              IMPORTING
***                et_return    = et_return.
***          ELSE.
***            CALL FUNCTION '/ITETR/DLV_OUTDLV_SEND2TRA' " DESTINATION 'NONE'
***              EXPORTING
***                iv_module    = 'SD'
***                iv_bukrs     = lv_bukrs
***                it_likp      = lt_likp[]
***                iv_parameter = 'NO_PGI_AUT'
***              IMPORTING
***                et_return    = et_return.
***          ENDIF.
***        ELSE.
***          cf_retcode = 8.
***        ENDIF.
***      ELSE.
***
***      ENDIF.

    WHEN 'MKPF' OR 'MSEG'.
      lv_mblnr = nast-objky+0(10).
      lv_mjahr = nast-objky+10(4).


      DO 20 TIMES.
        SELECT * FROM mkpf INTO TABLE lt_mkpf WHERE mblnr = lv_mblnr AND
                                                    mjahr = lv_mjahr.
        IF sy-subrc IS INITIAL.
          SELECT SINGLE bukrs FROM mseg INTO lv_bukrs WHERE mblnr = lv_mblnr AND
                                                            mjahr = lv_mjahr.
          EXIT.
        ENDIF.
        WAIT UP TO '0.5' SECONDS.
      ENDDO.

      IF lt_mkpf[] IS NOT INITIAL.
        READ TABLE lt_mkpf INTO ls_mkpf INDEX 1.

        CALL FUNCTION '/ITETR/DLV_OUTDLV_SEND2TRA' DESTINATION 'NONE'
          EXPORTING
            iv_module = 'MM'
            iv_bukrs  = lv_bukrs
            it_data   = lt_mkpf[]
          IMPORTING
            et_return = et_return.
      ENDIF.
  ENDCASE.

  LOOP AT et_return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
*    READ TABLE ls_result-messages INTO ls_message WITH KEY type = 'E'. "#EC CI_STDSEQ
*    IF sy-subrc EQ 0.
    cf_retcode = 8.
*      syst-msgty = 'E'.
*      PERFORM protocol_update_custom USING 'ED0_MC01' '000' ls_message-type ls_message-description.
*    ELSE.
*      cf_retcode = 0.
*      syst-msgty = 'S'.
*      PERFORM protocol_update_spool USING '342' space space space space.
*    ENDIF.
*  ELSE.
*    cf_retcode = 8.
*    syst-msgty = 'E'.
*    PERFORM protocol_update_custom USING 'ED1_MC01' '009' 'E' space.
  ENDIF.


ENDFORM.                    " PROCESSING
*&---------------------------------------------------------------------*
*&      Form  protocol_update_custom
*&---------------------------------------------------------------------*
FORM protocol_update_custom USING pv_msgid TYPE any
                                  pv_msgno TYPE any
                                  pv_type  TYPE any
                                  pv_message  TYPE any.

  DATA: lv_msg1  TYPE sy-msgv1,
        lv_msg2  TYPE sy-msgv2,
        lv_msg3  TYPE sy-msgv3,
        lv_msg4  TYPE sy-msgv4,
        lv_msgid TYPE sy-msgid,
        lv_msgno TYPE sy-msgno,
        lv_msgty TYPE sy-msgty,
        lv_len   TYPE i.

  IF pv_message IS NOT INITIAL.
    lv_len = strlen( pv_message ).

    IF lv_len LE 50.
      lv_msg1 = pv_message.
    ELSEIF lv_len LE 100.
      lv_msg1 = pv_message(50).
      lv_msg2 = pv_message+50(50).
    ELSEIF lv_len LE 150.
      lv_msg1 = pv_message(50).
      lv_msg2 = pv_message+50(50).
      lv_msg3 = pv_message+100(50).
    ELSE.
      lv_msg1 = pv_message(50).
      lv_msg2 = pv_message+50(50).
      lv_msg3 = pv_message+100(50).
      lv_msg4 = pv_message+150(50).
    ENDIF.
  ENDIF.

  lv_msgid = pv_msgid.
  lv_msgno = pv_msgno.
  lv_msgty = pv_type.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
    EXPORTING
      msg_arbgb = lv_msgid
      msg_nr    = lv_msgno
      msg_ty    = lv_msgty
      msg_v1    = lv_msg1
      msg_v2    = lv_msg2
      msg_v3    = lv_msg3
      msg_v4    = lv_msg4
    EXCEPTIONS
      OTHERS    = 1.                                        "#EC *
ENDFORM.                    "protocol_update_spool