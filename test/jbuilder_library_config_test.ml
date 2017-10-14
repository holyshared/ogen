open Sexplib
open OUnit2
open Ogen_project

module Library = Jbuilder_library_config

let test_library_conf ctx =
  let name_by s = Library.create ~name:s ~pub_name:s ~libs:[] in
  let lib_conf = name_by "test" in
  assert_equal (Library.name lib_conf) "test";
  assert_equal (Library.public_name lib_conf) (Some "test");
  assert_equal (Library.libraries lib_conf) []

let test_library_conf_to_sexp ctx =
  let name_by s = Library.create ~name:s ~pub_name:s ~libs:[] in
  let expected =
    Sexp.of_string "(library((public_name test)(name test)(libraries ())))" in
  assert_bool "sexp" ((Sexp.compare (Library.to_sexp (name_by "test")) expected) = 0)

let tests = "all_tests" >::: [
  ("test_library_conf" >:: test_library_conf);
  ("test_library_conf_to_string" >:: test_library_conf_to_sexp)
]
