*&---------------------------------------------------------------------*
*& Report /ITETR/INV_TAXPAYERS_CHECK
*&---------------------------------------------------------------------*
REPORT /itetr/inv_taxpayers_check.

INCLUDE /itetr/inv_taxpayers_top.
INCLUDE /itetr/inv_taxpayers_scr.
INCLUDE /itetr/inv_taxpayers_cls.
INCLUDE /itetr/inv_taxpayers_mdl.

START-OF-SELECTION.
  go_report = NEW gcl_report( ).
  go_report->start_of_selection( ).
  go_report->show_filter_screen( ).
  CALL SCREEN 0100.