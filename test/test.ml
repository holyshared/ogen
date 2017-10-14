open OUnit2

let () =
  run_test_tt_main ("all_tests" >::: [
    File_test.tests;
    Library_test.tests;
  ])
