*&---------------------------------------------------------------------*
*& Report /ITETR/INCOMING_INVOICE_MNR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/incoming_invoice_mnr.
TABLES: /itetr/inv_icinv.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS: s_bukrs FOR /itetr/inv_icinv-bukrs.
SELECTION-SCREEN END OF BLOCK b1.

TYPES BEGIN OF ty_invoices.
TYPES docui TYPE /itetr/com_e_docui.
TYPES bukrs TYPE bukrs.
TYPES invno TYPE /itetr/com_e_docno.
TYPES invui TYPE /itetr/com_e_duich.
TYPES taxid TYPE stcd2.
TYPES END OF ty_invoices.

DATA: gt_invoices_mail TYPE /itetr/inv_tt_inv_mail_list,
      gt_invoices      TYPE SORTED TABLE OF ty_invoices WITH UNIQUE KEY docui
                         WITH NON-UNIQUE SORTED KEY by_bukrs COMPONENTS bukrs,
      gs_invoice       TYPE ty_invoices,
      gv_receive_begin TYPE datum,
      gv_receive_end   TYPE datum,
      gt_company       TYPE TABLE OF ty_invoices,
      gs_company       TYPE ty_invoices,
      gv_subject       TYPE so_obj_des.
FIELD-SYMBOLS: <gs_invoices_mail> TYPE /itetr/inv_s_inv_mail_list.

START-OF-SELECTION.
  gv_receive_begin = sy-datum - 8.
  gv_receive_end = sy-datum - 6.
  SELECT docui bukrs invno invui taxid
    FROM /itetr/inv_icinv
    INTO TABLE gt_invoices
    WHERE bukrs IN s_bukrs
      AND resst EQ '0'
      AND recdt BETWEEN gv_receive_begin AND gv_receive_end.

END-OF-SELECTION.
  CHECK sy-subrc IS INITIAL.

  gt_company = gt_invoices.
  SORT gt_company BY bukrs.
  DELETE ADJACENT DUPLICATES FROM gt_company COMPARING bukrs.
  gv_subject = TEXT-001.
  LOOP AT gt_company INTO gs_company.
    CLEAR gt_invoices_mail.
    LOOP AT gt_invoices INTO gs_invoice USING KEY by_bukrs WHERE bukrs = gs_company-bukrs.
      APPEND INITIAL LINE TO gt_invoices_mail ASSIGNING <gs_invoices_mail>.
      MOVE-CORRESPONDING gs_invoice TO <gs_invoices_mail>.
    ENDLOOP.

    CALL FUNCTION '/ITETR/INV_MAIL_INVOICES'
      EXPORTING
        iv_company_code = gs_company-bukrs
        iv_email_time   = '2'
        iv_subject      = gv_subject
        it_invoices     = gt_invoices_mail.
  ENDLOOP.