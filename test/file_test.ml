open OUnit2
open Project

let test_file ctx =
  let dir = bracket_tmpdir ctx in
  let test_file = dir ^ "/" ^ "test.txt" in
  match File.puts "ok" ~path:test_file with
    | Ok f -> assert_equal (File.path f) test_file
    | Error e -> assert_failure (File.string_of_error e)

let tests = "all_tests" >::: [
  ("test_file" >:: test_file)
]
