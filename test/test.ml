open OUnit2

let () =
  run_test_tt_main ("all_tests" >::: [
    Project_test.tests;
    Library_test.tests;
  ])
