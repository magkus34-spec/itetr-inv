interface /ITETR/OUTGOING_IF_BADI
  public .


  interfaces IF_BADI_INTERFACE .

  methods CHANGE_PATH
    changing
      value(CV_PATH) type STRING optional .
endinterface.