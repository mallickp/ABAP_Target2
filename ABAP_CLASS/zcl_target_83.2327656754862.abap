Converted function module to a class with optimized source code using ABAP 7.40 syntax and features, like inline declarations and string templates:

```ABAP
CLASS zcl_cnv_2010c DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_domain_fixed_val,
             ddlanguage TYPE dd07t_ddlanguage,
             valpos TYPE dd07t_valpos,
             domvalue_l TYPE dd07t_domvalue_l,
             ddtext TYPE dd07t_ddtext,
           END OF ty_domain_fixed_val.
    
    TYPES: tt_domain_fixed_val TYPE TABLE OF ty_domain_fixed_val.

    CLASS-METHODS get_domain_fixed_val
      IMPORTING
        !iv_domname TYPE domname
      EXPORTING
        !out_domname TYPE domname
      CHANGING
        !ct_domain_fixed_val TYPE tt_domain_fixed_val
        !cs_bapiret TYPE bapiret2 .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_cnv_2010c IMPLEMENTATION.

  METHOD get_domain_fixed_val.
    DATA: lt_domain_fixed_val TYPE tt_domain_fixed_val.
  
    IF iv_domname IS INITIAL.
      cs_bapiret = VALUE #( type = 'E' id = 'CNV_2010C' number = '000' message = 'Domname cannot be empty' ).
      RETURN.
    ENDIF.
    
    SELECT ddlanguage valpos domvalue_l ddtext
      INTO TABLE lt_domain_fixed_val
      FROM dd07t
      WHERE domname = iv_domname
        AND ddlanguage = sy-langu
        AND as4local = 'A'.
          
    IF sy-subrc = 0.
      out_domname = iv_domname.
    ELSE.
      SELECT ddlanguage valpos domvalue_l ddtext
        INTO TABLE lt_domain_fixed_val
        FROM dd07t
        WHERE domname = iv_domname
          AND ddlanguage = 'E'
          AND as4local = 'A'.
          
      IF sy-subrc = 0.
        out_domname = iv_domname.
      ELSE.
        cs_bapiret = VALUE #( type = 'E' id = 'CNV_2010C' number = '000' message = 'Domname not found' ).
        RETURN.
      ENDIF.
    ENDIF.
      
    ct_domain_fixed_val = lt_domain_fixed_val.
    
  ENDMETHOD.

ENDCLASS.
```