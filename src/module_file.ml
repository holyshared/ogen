let generate ?(dir=Sys.getcwd ()) ?(content="") ~name () =
  let create_ml_file = File.puts ~path:(dir ^ "/" ^ name ^ ".ml") in
  match create_ml_file content with
    | Ok file -> Ok ()
    | Error e -> Error (File.string_of_error e)
