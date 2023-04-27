Now, let's create an ABAP Unit test class to test this implementation with positive and negative scenarios.

```ABAP
CLASS ltc_cnv_2010c DEFINITION FINAL
  FOR TESTING INHERITING FROM zcl_cnv_2010c
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PROTECTED SECTION.
    DATA: lt_fixed_values TYPE cnv_2010c_t_domain_fixed_value.

  PRIVATE SECTION.
    METHODS: setup,
             test_positive_scenario FOR TESTING,
             test_negative_scenario FOR TESTING.

ENDCLASS.

CLASS ltc_cnv_2010c IMPLEMENTATION.

  METHOD setup.
    lt_fixed_values = VALUE #(
      ( dlanguage = 'EN' valpos = 1 domvalue_l = 'X' ddtext = 'Indicator X' )
      ( dlanguage = 'EN' valpos = 2 domvalue_l = 'Y' ddtext = 'Indicator Y' )
      ( dlanguage = 'EN' valpos = 3 domvalue_l = 'Z' ddtext = 'Indicator Z' )
    ).
  ENDMETHOD.

  METHOD test_positive_scenario.
    DATA: lv_domname        TYPE domname,
          lt_fixed_val      TYPE cnv_2010c_t_domain_fixed_value,
          lt_mesages_return TYPE STANDARD TABLE OF bapiret2.

    lv_domname = 'ZINDICATOR'.

    lt_mesages_return = get_domain_fixed_val(
      EXPORTING
        iv_domname = lv_domname
      IMPORTING
        ev_domname = lv_domname
      TABLES
        et_domain_fixed_val = lt_fixed_val
    ).

    cl_abap_unit_assert=>assert_equals(
      exp         = lt_fixed_values
      act         = lt_fixed_val
      msg         = 'The obtained fixed values differ from the expected ones'
    ).

    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_initial( ref = lt_mesages_return ).
  ENDMETHOD.

  METHOD test_negative_scenario.
    DATA: lv_domname        TYPE domname,
          lt_fixed_val      TYPE cnv_2010c_t_domain_fixed_value,
          lt_mesages_return TYPE STANDARD TABLE OF bapiret2.

    lv_domname = ''.

    lt_mesages_return = get_domain_fixed_val(
      EXPORTING
        iv_domname = lv_domname
      IMPORTING
        ev_domname = lv_domname
      TABLES
        et_domain_fixed_val = lt_fixed_val
    ).

    cl_abap_unit_assert=>assert_initial( ref = lt_fixed_val ).
    cl_abap_unit_assert=>assert_not_initial( ref = lt_mesages_return ).

    LOOP AT lt_mesages_return INTO DATA(ls_msg).
      cl_abap_unit_assert=>assert_equals(
        exp = 'E'
        act = ls_msg-type
        msg = 'Expected an error message'
      ).

      cl_abap_unit_assert=>assert_equals(
        exp = 'IV_DOMNAME is initial'
        act = ls_msg-message
        msg = 'Expected error message: IV_DOMNAME is initial'
      ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
```
This unit test class (ltc_cnv_2010c) inherits from the implementation class (zcl_cnv_2010c) and contains two test methods; one for the positive scenario (test_positive_scenario) and one for the negative scenario (test_negative_scenario).

In the setup method, we initialize the sample fixed values to be used in test_positive_scenario. In the test_positive_scenario, we execute the get_domain_fixed_val method and assert that the obtained fixed values are equal to the expected ones, and there are no error messages.

In the test_negative_scenario, we pass an initial DOMNAME value, and after executing the get_domain_fixed_val method, we expect an error message to be present in the return table, and the fixed values' internal table should be initial.