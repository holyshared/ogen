open OUnit2

let () =
  run_test_tt_main ("all_tests" >::: [
    File_test.tests;
    Jbuilder_library_test.tests;
  ])
