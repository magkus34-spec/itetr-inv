interface /ITETR/IF_INV_INCINV_GET_LIST
  public .


  types:
    BAPI_MTYPE type C length 000001 .
  types:
    SYMSGID type C length 000020 .
  types:
    SYMSGNO type N length 000003 .
  types:
    BAPI_MSG type C length 000220 .
  types:
    BALOGNR type C length 000020 .
  types:
    BALMNR type N length 000006 .
  types:
    SYMSGV type C length 000050 .
  types:
    BAPI_PARAM type C length 000032 .
  types:
    BAPI_FLD type C length 000030 .
  types:
    BAPILOGSYS type C length 000010 .
  types:
    begin of BAPIRET2,
      TYPE type BAPI_MTYPE,
      ID type SYMSGID,
      NUMBER type SYMSGNO,
      MESSAGE type BAPI_MSG,
      LOG_NO type BALOGNR,
      LOG_MSG_NO type BALMNR,
      MESSAGE_V1 type SYMSGV,
      MESSAGE_V2 type SYMSGV,
      MESSAGE_V3 type SYMSGV,
      MESSAGE_V4 type SYMSGV,
      PARAMETER type BAPI_PARAM,
      ROW type INT4,
      FIELD type BAPI_FLD,
      SYSTEM type BAPILOGSYS,
    end of BAPIRET2 .
  types:
    /ITETR/INV_E_RESST type C length 000001 .
  types:
    /ITETR/COM_E_RADSC type C length 000004 .
  types:
    /ITETR/COM_E_STAEX type C length 000255 .
  types:
    begin of /ITETR/INV_INCINV_STATUS,
      RESST type /ITETR/INV_E_RESST,
      RADSC type /ITETR/COM_E_RADSC,
      STAEX type /ITETR/COM_E_STAEX,
    end of /ITETR/INV_INCINV_STATUS .
  types:
    MANDT type C length 000003 .
  types:
    /ITETR/COM_E_DOCUI type X length 000016 .
  types:
    BUKRS type C length 000004 .
  types:
    /ITETR/COM_E_AGENT type C length 000010 .
  types:
    /ITETR/COM_E_ENVUI type C length 000036 .
  types:
    /ITETR/COM_E_DUICH type C length 000036 .
  types:
    /ITETR/COM_E_DOCNO type C length 000016 .
  types:
    /ITETR/COM_E_DOCII type C length 000050 .
  types:
    /ITETR/COM_E_DOCQI type C length 000050 .
  types:
    STCD2 type C length 000011 .
  types:
    /ITETR/COM_E_ALIAS type C length 000100 .
  types:
    /ITETR/COM_E_DMBTR type P length 7  decimals 000002 .
  types:
    /ITETR/COM_E_WRBTR type P length 9  decimals 000002 .
  types:
    /ITETR/COM_E_FWSTE type P length 7  decimals 000002 .
  types:
    WAERS type C length 000005 .
  types:
    /ITETR/INV_E_PRFID type C length 000020 .
  types:
    /ITETR/INV_E_INVTY type C length 000020 .
  types:
    /ITETR/COM_E_PRINT type C length 000001 .
  types:
    /ITETR/COM_E_APRVD type C length 000001 .
  types:
    /ITETR/COM_E_PROCS type C length 000001 .
  types:
    AWTYP type C length 000005 .
  types:
    BELNR_D type C length 000010 .
  types:
    GJAHR type N length 000004 .
  types:
    /ITETR/COM_E_ARCHV type C length 000001 .
  types:
    /ITETR/COM_E_ATTEX type C length 000001 .
  types:
    /ITETR/COM_E_LNOTE type C length 000255 .
  types:
    /ITETR/COM_E_ORDERID type C length 000255 .
  types:
    /ITETR/COM_E_WITHHOLDING type P length 7  decimals 000002 .
  types:
    /ITETR/COM_E_ALLOWANCE type P length 7  decimals 000002 .
  types:
    /ITETR/COM_E_DRAFT type C length 000001 .
  types:
    KURSF type P length 5  decimals 000005 .
  types:
    /ITETR/INV_E_HASHCODE type C length 000255 .
  types:
    /ITETR/COM_E_ATTAX type C length 000001 .
  types:
    /ITETR/COM_E_TITLE type C length 000255 .
  types:
    /ITETR/COM_E_DEPCD type C length 000010 .
  types:
    /ITETR/INV_E_APPROVAL_STAT type C length 000020 .
  types:
    begin of /ITETR/INV_ICINV,
      MANDT type MANDT,
      DOCUI type /ITETR/COM_E_DOCUI,
      BUKRS type BUKRS,
      AGENT type /ITETR/COM_E_AGENT,
      ENVUI type /ITETR/COM_E_ENVUI,
      INVUI type /ITETR/COM_E_DUICH,
      INVNO type /ITETR/COM_E_DOCNO,
      INVII type /ITETR/COM_E_DOCII,
      INVQI type /ITETR/COM_E_DOCQI,
      TAXID type STCD2,
      ALIASS type /ITETR/COM_E_ALIAS,
      BLDAT type DATS,
      RECDT type DATS,
      DMBTR type /ITETR/COM_E_DMBTR,
      WRBTR type /ITETR/COM_E_WRBTR,
      FWSTE type /ITETR/COM_E_FWSTE,
      WAERS type WAERS,
      PRFID type /ITETR/INV_E_PRFID,
      INVTY type /ITETR/INV_E_INVTY,
      PRNTD type /ITETR/COM_E_PRINT,
      APRVD type /ITETR/COM_E_APRVD,
      PROCS type /ITETR/COM_E_PROCS,
      AWTYP type AWTYP,
      BELNR type BELNR_D,
      GJAHR type GJAHR,
      ARCHV type /ITETR/COM_E_ARCHV,
      ATTEX type /ITETR/COM_E_ATTEX,
      LNOTE type /ITETR/COM_E_LNOTE,
      DESPID type /ITETR/COM_E_DOCNO,
      ORDERID type /ITETR/COM_E_ORDERID,
      WITHHOLDING type /ITETR/COM_E_WITHHOLDING,
      ALLOWANCE type /ITETR/COM_E_ALLOWANCE,
      DRAFT type /ITETR/COM_E_DRAFT,
      KURSF type KURSF,
      HASHCODE type /ITETR/INV_E_HASHCODE,
      ATTAX type /ITETR/COM_E_ATTAX.
    include type /ITETR/INV_INCINV_STATUS.
    types:
      TITLE type /ITETR/COM_E_TITLE,
      DEPCD type /ITETR/COM_E_DEPCD,
      APPROVAL_STATUS type /ITETR/INV_E_APPROVAL_STAT,
    end of /ITETR/INV_ICINV .
  types:
    /ITETR/INV_TT_ICINV            type standard table of /ITETR/INV_ICINV               with non-unique default key .
  types DATUM type DATS .
endinterface.