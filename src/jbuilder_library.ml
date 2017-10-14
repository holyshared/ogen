let build_content ?pub_name ?(libs=[]) ~name =
  let version = Version.create () in
  let library_conf = Library.create ?pub_name ~name ~libs in
  let buf = Buffer.create 1024 in
  Buffer.add_string buf (Version.to_string version);
  Buffer.add_string buf (Library.to_string library_conf);
  Buffer.contents buf

let empty_source ?(dir=Sys.getcwd ()) ~name () =
  let ml_file dir = open_out (dir ^ "/" ^ name ^ ".ml") in
  let ml_f = (ml_file dir) in
  output_string ml_f "";
  close_out ml_f;
  Ok ()

let generate ?(dir=Sys.getcwd ()) ?pub_name ?(libs=[]) ~name () =
  let jbuild_file dir = open_out (dir ^ "/" ^ "jbuild") in
  let jbuild = (jbuild_file dir) in
  output_string jbuild (build_content ?pub_name ~name ~libs);
  close_out jbuild;
  Ok ()
