open Arg

let commands = [
  (module Lib_command: Command.S);
  (module Module_command: Command.S)
]

let list_of_commands () =
  let add_to_buffer buf cmd =
    let module Cmd = (val cmd: Command.S) in
    let description = Printf.sprintf "%s %s\n" Cmd.name Cmd.description in
    Buffer.add_string buf description;
    buf in
  let command_list = ListLabels.fold_left ~f:add_to_buffer
    ~init:(Buffer.create 1024) commands in
  Buffer.contents command_list

let run_command s =
  let gopts = Global_options.get () in
  match s with
    | "lib" -> Lib_command.run ~gopts
    | "mod" -> Module_command.run ~gopts
    | _ -> Lib_command.run ~gopts

let run () =
  let goptions_spec = ref Global_options.spec in
  let program_desc =
    let buf = Buffer.create 1024 in
    Buffer.(
      add_string buf "ogen [GLOBAL_OPTIONS] [COMMAND] [OPTIONS]";
      add_string buf (Global_options.usage_string ());
      contents buf
    ) in
  try
    parse_dynamic goptions_spec run_command program_desc;
  with
    | Help s -> print_endline s
    | Bad s -> print_endline s
