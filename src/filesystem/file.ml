(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

type t = {
  path: string;
  channel: out_channel;
  closed: bool
}

module File_error = struct
  type t =
    | CreateFailed of string
    | AlreadyClosed of string

  let create_failed path = CreateFailed (Printf.sprintf "%s is closed" path)
  let already_closed path = AlreadyClosed (Printf.sprintf "%s is closed" path)

  let to_string = function
    | CreateFailed s -> s
    | AlreadyClosed s -> s
end


let bind ~f = function
  | Ok t -> f t
  | Error e -> Error e

let is_closed t = t.closed

let create_failed path =
  File_error.create_failed path

let already_closed path =
  File_error.already_closed path

let process_if_file_opened t ~f =
  if is_closed t then Error (already_closed t.path)
  else f t

let open_write path =
  try
    Ok {
      path = path;
      channel = (open_out path);
      closed = false
    }
  with Sys_error e -> Error (create_failed e)

let write_string ~s t =
  let wrtie_to_file t =
    output_string t.channel s;
    Ok t in
  process_if_file_opened t ~f:wrtie_to_file

let write_buffer ~buf t =
  write_string ~s:(Buffer.contents buf) t

let close t =
  let close_file t =
    close_out t.channel;
    Ok ({ t with closed = true }) in
  process_if_file_opened t ~f:close_file

let path t = t.path

let create ?content ~path =
  let to_string = function
    | Some v -> v
    | None -> "" in
  open_write path
    |> bind ~f:(write_string ~s:(to_string content))
    |> bind ~f:close

let%test_module _ = (module struct
  open Base
  open Sexplib.Conv
  exception Assert_error of string
  let%test_unit "create a new file" =
    let temp_dir = Caml.Filename.get_temp_dir_name () in
    let test_file = temp_dir ^ "/" ^ "test.txt" in
    match create ~content:"ok" ~path:test_file with
      | Ok f -> [%test_eq: string] (path f) test_file
      | Error e -> raise (Assert_error (File_error.to_string e))
end)
