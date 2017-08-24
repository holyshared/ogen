open OUnit2
open Project

let test_project_generate ctx =
  assert_equal (generate_to ".") "."

  let tests = "all_tests" >::: [
  ("test_project" >:: test_project_generate)
]
