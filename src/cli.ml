open Arg

let program_name = "ogen"
let program_version = "0.1.0"

let commands = [
  (module Lib_command: Command.S);
  (module Module_command: Command.S)
]

module Commands = MoreLabels.Map.Make (struct
  type t = string
  let compare = compare
end)

let registry_of_commands () =
  let add m cmd =
    let module C = (val cmd: Command.S) in
    Commands.add ~key:C.name ~data:(module C: Command.S) m in
  ListLabels.fold_left ~f:add ~init:(Commands.empty) commands

let list_of_commands () =
  let add_to_buffer buf cmd =
    let module Cmd = (val cmd: Command.S) in
    let description = Printf.sprintf "  %s %s\n" Cmd.name Cmd.description in
    Buffer.add_string buf description;
    buf in
  let command_header =
    let buf = Buffer.create 1024 in
    Buffer.add_string buf "Commands:\n";
    buf in
  let command_list = ListLabels.fold_left ~f:add_to_buffer
    ~init:command_header commands in
  Buffer.contents command_list

let program_desc () =
  let buf = Buffer.create 1024 in
  Buffer.(
    add_string buf (Printf.sprintf "%s v%s - Code generator for OCaml\n\n" program_name program_version);
    add_string buf "Usage:\n  ogen [GLOBAL_OPTIONS] [COMMAND] [OPTIONS]\n\n";
    add_string buf (list_of_commands ());
    add_string buf "\n";
    add_string buf (Global_options.usage_string ());
    contents buf
  )

let run_command s =
  let cmd_registry = registry_of_commands () in
  let gopts = Global_options.get () in
  match Commands.find_opt s cmd_registry with
    | Some cmd ->
      let module Cmd = (val cmd: Command.S) in
      Cmd.run ~gopts
    | None -> Lib_command.run ~gopts

let run () =
  let goptions_spec = ref Global_options.spec in
  let program_desc = program_desc () in
  try
    parse_dynamic goptions_spec run_command program_desc;
  with
    | Help s -> print_endline s
    | Bad s -> print_endline s
