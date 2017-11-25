open Sexplib
open OUnit2
open Ogen_jbuilder

let test_library_conf ctx =
  let name_by s = Library.create ~name:s ~pub_name:s in
  let lib_conf = name_by "test" () in
  assert_equal (Library.name lib_conf) "test";
  assert_equal (Library.public_name lib_conf) (Some "test");
  assert_equal (Library.libraries lib_conf) None

let test_library_conf_to_string ctx =
  let name_by s = Library.create ~name:s ~pub_name:s () in
  let expected = "(library (\n  (name        test)\n  (public_name test)))\n" in
  let acutual = Library.to_string (name_by "test") in
  assert_equal acutual expected

let tests = "all_tests" >::: [
  ("test_library_conf" >:: test_library_conf);
  ("test_library_conf_to_string" >:: test_library_conf_to_string)
]
