*&---------------------------------------------------------------------*
*& Report /itetr/outgoing_invoice_snd
*&---------------------------------------------------------------------*
*& Mustafa Sadık
*&---------------------------------------------------------------------*
REPORT /itetr/outgoing_invoice_snd.

TABLES: /itetr/inv_oginv.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bukrs FOR /itetr/inv_oginv-bukrs,
                  s_belnr FOR /itetr/inv_oginv-belnr,
                  s_bldat FOR /itetr/inv_oginv-bldat,
                  s_gjahr FOR /itetr/inv_oginv-gjahr,
                  s_docty FOR /itetr/inv_oginv-doctype,
                  s_awtyp FOR /itetr/inv_oginv-awtyp,
                  s_vkorg FOR /itetr/inv_oginv-vkorg,
                  s_vtweg FOR /itetr/inv_oginv-vtweg.
SELECTION-SCREEN END OF BLOCK b1.

TYPES BEGIN OF ty_company.
TYPES bukrs TYPE bukrs.
TYPES END OF ty_company.

TYPES BEGIN OF ty_invoices.
TYPES bukrs TYPE bukrs.
TYPES docui TYPE /itetr/com_e_docui.
TYPES belnr TYPE belnr_d.
TYPES gjahr TYPE gjahr.
TYPES awtyp	TYPE /itetr/inv_e_awtyp.
TYPES prfid TYPE /itetr/inv_e_prfid.
TYPES END OF ty_invoices.

DATA: gt_einvoices        TYPE /itetr/com_tt_document_id,
      gt_earchives        TYPE /itetr/com_tt_document_id,
      gs_sendable_invoice TYPE /itetr/com_s_document_id,
      gt_invoices         TYPE SORTED TABLE OF ty_invoices WITH UNIQUE KEY bukrs docui,
      gs_invoice          TYPE ty_invoices,
      gt_company          TYPE TABLE OF ty_company,
      gs_company          TYPE ty_company,
      lt_no_send          TYPE TABLE OF /itetr/inv_nosnd,
      ls_no_send          TYPE /itetr/inv_nosnd.

START-OF-SELECTION.
  SELECT bukrs docui belnr gjahr awtyp prfid
    FROM /itetr/inv_oginv                 "#EC CI_NOFIELD
    INTO TABLE gt_invoices
    WHERE bukrs   IN s_bukrs
      AND belnr   IN s_belnr
      AND gjahr   IN s_gjahr
      AND awtyp   IN s_awtyp
      AND doctype IN s_docty
      AND vkorg   IN s_vkorg
      AND vtweg   IN s_vtweg
      AND stacd   IN ('','2')
      AND bldat   IN s_bldat
      AND revch   EQ abap_false.


  CHECK sy-subrc IS INITIAL.

*Out of Scope E-Invoice and E-Archive
  SELECT *
    FROM /itetr/inv_nosnd
    INTO TABLE lt_no_send
    WHERE  bukrs IN s_bukrs
       AND belnr IN s_belnr
       AND gjahr IN s_gjahr
       AND awtyp IN s_awtyp.
  IF sy-subrc EQ 0 AND lt_no_send[] IS NOT INITIAL.
    LOOP AT lt_no_send INTO ls_no_send.
      DELETE gt_invoices WHERE  bukrs = ls_no_send-bukrs
                            AND belnr = ls_no_send-belnr
                            AND gjahr = ls_no_send-gjahr
                            AND awtyp = ls_no_send-awtyp.
    ENDLOOP.
  ENDIF.

  IF gt_invoices[] IS NOT INITIAL.

    MOVE-CORRESPONDING gt_invoices TO gt_company.

    LOOP AT gt_company INTO gs_company.
      CLEAR: gt_einvoices, gt_earchives.
      LOOP AT gt_invoices INTO gs_invoice WHERE bukrs = gs_company-bukrs.
        MOVE-CORRESPONDING gs_invoice TO gs_sendable_invoice.
        CASE gs_invoice-prfid.
          WHEN 'EARSIV'.
            APPEND gs_sendable_invoice TO gt_einvoices.
          WHEN OTHERS.
            APPEND gs_sendable_invoice TO gt_earchives.
        ENDCASE.
        CLEAR gs_sendable_invoice.
      ENDLOOP.
      IF gt_einvoices IS NOT INITIAL.
        CALL FUNCTION '/ITETR/INV_OUTINV_SEND'
          EXPORTING
            iv_company_code = gs_company-bukrs
            it_documents    = gt_einvoices.
      ENDIF.
      IF gt_earchives IS NOT INITIAL.
        CALL FUNCTION '/ITETR/INV_OUTINV_SEND'
          EXPORTING
            iv_company_code = gs_company-bukrs
            it_documents    = gt_earchives.
      ENDIF.
    ENDLOOP.
  ENDIF.