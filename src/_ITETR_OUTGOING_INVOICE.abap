*&---------------------------------------------------------------------*
*& Report /ITETR/OUTGOING_INVOICE
*&---------------------------------------------------------------------*
*& Mustafa Sadık
*&---------------------------------------------------------------------*
REPORT /itetr/outgoing_invoice MESSAGE-ID /itetr/regulative NO STANDARD PAGE HEADING.

INCLUDE /itetr/inv_version.
INCLUDE /itetr/outgoing_invoice_top.
INCLUDE /itetr/outgoing_invoice_c01.
INCLUDE /itetr/outgoing_invoice_mdl.

INITIALIZATION.
  go_main_controller = lcl_main_controller=>get_instance( ).
  go_main_controller->selscr_init( ).

AT SELECTION-SCREEN OUTPUT.
  go_main_controller->selscr_output( ).

START-OF-SELECTION.
  go_main_controller->get_data( ).

END-OF-SELECTION.
  go_main_controller->display_data( ).