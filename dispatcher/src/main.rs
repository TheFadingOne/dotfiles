mod lib;

use std::fs::File;
use std::process::ExitCode;
use std::convert::TryFrom;
use std::io::Write;

use clap_v3::{App, Arg};

use lib::dispatch_rules::DispatchRules;

// TODO improve error handling

fn main() -> ExitCode {
    let matches = App::new("Dispatcher")
            .about("Dispatches or updates files")
            .arg(Arg::with_name("update")
                    .short('u')
                    .long("update")
                    .help("sets the program to update"))
            .arg(Arg::with_name("input")
                    .short('i')
                    .long("input")
                    .value_name("FILE")
                    .help("sets config file")
                    .takes_value(true)
                    .required(true))
            .get_matches();

    let file_name = matches.value_of("input").unwrap();

    let file = match File::open(file_name) {
        Ok(f) => f,
        Err(e) => {
            eprintln!("error: {}", e);
            // process::exit(1);
            return ExitCode::from(1);
        },
    };

    // parse dispatch rules
    let dr = DispatchRules::try_from(file).unwrap();

    // TODO this is all pretty ugly
    let update = matches.is_present("update");
    print!("Program is in {} mode. Proceed? [y/n]: ",
           if update { "update" } else { "dispatch" });

    std::io::stdout().flush().unwrap();     // TODO merkste selbst, ne?

    // get user input
    let mut input = String::new();
    if let Err(e) = std::io::stdin().read_line(&mut input) {
        eprintln!("error: unable to read user input: \"{}\"", e);
        // process::exit(1);
        return ExitCode::from(1);
    }

    if &input.to_lowercase() != "y\n" {
        // process::exit(2);
        return ExitCode::from(2);
    }

    if update {
        dr.update(1024);
    } else {
        dr.dispatch(1024);
    }

    // process::exit(0);
    ExitCode::SUCCESS
}
