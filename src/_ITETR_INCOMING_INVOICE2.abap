*&---------------------------------------------------------------------*
*& Report /ITETR/INCOMING_INVOICE
*&---------------------------------------------------------------------*
*& Mustafa Sadık
*&---------------------------------------------------------------------*
REPORT /itetr/incoming_invoice2 MESSAGE-ID /itetr/regulative NO STANDARD PAGE HEADING.

INCLUDE /itetr/inv_version2.
*INCLUDE /itetr/inv_version.
INCLUDE /itetr/incoming_invoice2_top.
*INCLUDE /itetr/incoming_invoice_top.
INCLUDE /itetr/incoming_invoice2_c01.
*INCLUDE /itetr/incoming_invoice_c01.
INCLUDE /itetr/incoming_invoice2_mdl.
*INCLUDE /itetr/incoming_invoice_mdl.

INITIALIZATION.
  go_main_controller = lcl_main_controller=>get_instance( ).
  go_main_controller->selscr_init( ).

AT SELECTION-SCREEN OUTPUT.
  go_main_controller->selscr_output( ).

START-OF-SELECTION.
  go_main_controller->get_data( ).

END-OF-SELECTION.
  go_main_controller->display_data( ).