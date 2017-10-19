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

type file_error =
  | CreateFailed of string
  | AlreadyClosed of string

let bind ~f = function
  | Ok t -> f t
  | Error e -> Error e

let is_closed t = t.closed

let already_closed t =
  AlreadyClosed (Printf.sprintf "%s is closed" t.path)

let string_of_error = function
  | CreateFailed s -> s
  | AlreadyClosed s -> s

let process_if_file_opened t ~f =
  if is_closed t then Error (already_closed t)
  else f t

let create path =
  try
    Ok {
      path = path;
      channel = (open_out path);
      closed = false
    }
  with Sys_error e -> Error (CreateFailed e)

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

let puts ~path s =
  create path
  |> bind ~f:(write_string ~s)
  |> bind ~f:close
