CLASS lcl_conversion_tests DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    CLASS lcl_conversion_tests IMPLEMENTATION.
      DATA mo_conv TYPE REF TO lcl_conversion.

    METHODS: setup,
             teardown,
             test_fill_bapiret2 FOR TESTING,
             test_get_domain_fixed_val_positive FOR TESTING,
             test_get_domain_fixed_val_negative FOR TESTING.
ENDCLASS.

CLASS lcl_conversion_tests IMPLEMENTATION.
  METHOD setup.
    CREATE OBJECT mo_conv.
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_conv.
  ENDMETHOD.

  METHOD test_fill_bapiret2.
    DATA lo_return TYPE REF TO cl_bapiret2.
    mo_conv->fill_bapiret2(
      EXPORTING
        type       = 'E'
        cl         = 'CL_CALC'
        number     = '1'
      RETURNING
        return     = lo_return ).

    cl_abap_unit_assert=>assert_not_initial( lo_return ).
    cl_abap_unit_assert=>assert_equals( act = lo_return->type exp = 'E' ).
    cl_abap_unit_assert=>assert_equals( act = lo_return->number exp = '1' ).
  ENDMETHOD.

  METHOD test_get_domain_fixed_val_positive.
    DATA lv_domname TYPE domname VALUE 'S_SYSTL'.
    DATA lt_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value.
    DATA lt_return TYPE TABLE OF bapiret2.

    mo_conv->get_domain_fixed_val(
      IMPORTING
        iv_domname     = lv_domname
      EXPORTING
        ev_domname     = DATA(lv_out_domname)
      TABLES
        et_domain_fixed_val = lt_domain_fixed_val
        return           = lt_return ).

    cl_abap_unit_assert=>assert_equals( act = lv_out_domname exp = lv_domname ).
    cl_abap_unit_assert=>assert_not_initial( lt_domain_fixed_val ).
    cl_abap_unit_assert=>assert_initial( lt_return ).
  ENDMETHOD.

  METHOD test_get_domain_fixed_val_negative.
    DATA lv_domname TYPE domname VALUE 'INVALID_DOM'.
    DATA lt_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value.
    DATA lt_return TYPE TABLE OF bapiret2.

    mo_conv->get_domain_fixed_val(
      IMPORTING
        iv_domname     = lv_domname
      EXPORTING
        ev_domname     = DATA(lv_out_domname)
      TABLES
        et_domain_fixed_val = lt_domain_fixed_val
        return           = lt_return ).

    cl_abap_unit_assert=>assert_initial( lv_out_domname ).
    cl_abap_unit_assert=>assert_initial( lt_domain_fixed_val ).
    cl_abap_unit_assert=>assert_not_initial( lt_return ).
  ENDMETHOD.

ENDCLASS.