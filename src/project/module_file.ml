(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

let put_content = function
  | Some v -> v
  | None -> ""

let generate ?(dir=Sys.getcwd ()) ?content ~name () =
  let create_ml_file = File.puts ~path:(dir ^ "/" ^ name ^ ".ml") in
  match create_ml_file (put_content content) with
    | Ok file -> Ok ()
    | Error e -> Error (File.string_of_error e)
