*&---------------------------------------------------------------------*
*& Report /ITETR/OUTGOING_INVOICE_MAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/outgoing_invoice_mail MESSAGE-ID /itetr/regulative.

INCLUDE /itetr/outgoing_inv_mail_top.
INCLUDE /itetr/outgoing_inv_mail_c01.

INITIALIZATION.
  go_main_controller = lcl_main_controller=>get_instance( ).

AT SELECTION-SCREEN.
  go_main_controller->free( ).
  go_main_controller->job_control( ).
  CHECK gv_subrc IS INITIAL.

START-OF-SELECTION.

  go_main_controller->authorization_control( ).
  CHECK gv_subrc IS INITIAL.

  go_main_controller->start_process( ).

END-OF-SELECTION.

  IF sy-batch EQ abap_true.
    WRITE:/ 'Bilgi:', gs_return-message.
  ENDIF.