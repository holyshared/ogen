open OUnit2
open Project

let test_library_conf ctx =
  let name_by s = Library.create ~name:s ~public_name:s ~libraries:[] in
  let lib_conf = name_by "test" in
  assert_equal (Library.name lib_conf) "test";
  assert_equal (Library.public_name lib_conf) (Some "test");
  assert_equal (Library.libraries lib_conf) []

let tests = "all_tests" >::: [
  ("test_library_conf" >:: test_library_conf)
]
