pub mod dispatch_rules {
    use std::convert::TryFrom;
    use std::io::prelude::*;
    use std::io::BufReader;
    use std::fs::{File, OpenOptions};
    use std::fmt::{self, Display, Formatter};

    use termion::color;

    pub struct DispatchRules(pub Vec<(String, String)>);

    impl DispatchRules {
        // dispatches source files to their destination
        pub fn dispatch(&self, bs: usize) {
            for (src_name, dst_name) in &self.0 {
                Self::write_from_into(src_name, dst_name, bs);
            }
        }

        // updates source files from their destination
        pub fn update(&self, bs: usize) {
            for (dst_name, src_name) in &self.0 {
                Self::write_from_into(src_name, dst_name, bs);
            }
        }

        // writes from the file at scr_name to the file at dst_name bs bytes at a time
        fn write_from_into(src_name: &str, dst_name: &str, bs: usize) {
            let mut src = match OpenOptions::new().read(true).open(src_name) {
                Ok(f) => f,
                Err(e) => {
                    eprintln!("{}warning{}: while opening \"{}\": \"{}\"",
                              color::Fg(color::LightYellow), color::Fg(color::Reset), src_name, e);
                    return;
                },
            };
            let mut dst = match OpenOptions::new().write(true).create(true).open(dst_name) {
                Ok(f) => f,
                Err(e) => {
                    eprintln!("{}warning{}: while opening \"{}\": \"{}\"",
                              color::Fg(color::LightYellow), color::Fg(color::Reset), dst_name, e);
                    return;
                },
            };

            // TODO there must be an easier way to do this
            let mut buf = vec![];
            buf.resize_with(bs, || 0);
        
            loop {
                match src.read(&mut buf) {
                    Ok(0) => break,
                    Ok(n) => {
                        if let Err(e) = dst.write(&buf[0..n]) {
                            eprintln!("{}warning{}: while reading from \"{}\": \"{}\"",
                                      color::Fg(color::LightYellow), color::Fg(color::Reset), src_name, e);
                            return;
                        }
                    },
                    Err(e) => {
                        eprintln!("{}warning{}: while writing to \"{}\": \"{}\"", 
                                  color::Fg(color::LightYellow), color::Fg(color::Reset), dst_name, e);
                        return;
                    },
                }
            }
        }
    }

    impl Display for DispatchRules {
        fn fmt(&self, f: &mut Formatter) -> fmt::Result {
            for (src, dst) in &self.0 {
                write!(f, "{} -> {}\n", src, dst)?;
            }
            Ok(())
        }
    }

    impl TryFrom<File> for DispatchRules {
        type Error = &'static str;

        fn try_from(f: File) -> Result<Self, Self::Error> {
            let reader = BufReader::new(f);
            let mut delim = ';';
            let mut vec = vec![];

            for line in reader.lines() {
                // TODO error handling
                let line = line.unwrap();
                if line.starts_with('#') || line.len() == 0 {
                    continue;
                }

                if line.starts_with("delim:") {
                    if line.len() > 6 && line.as_bytes()[6] != b'\n' {
                        delim = line.as_bytes()[6] as char;
                    }
                    continue;
                }

                let t = match line.split_once(delim) {
                    Some((a, b)) => (String::from(a), String::from(b)),
                    None => {
                        eprintln!("{}warning{}: \"{}\" might be missing a delimiter",
                                  color::Fg(color::LightYellow), color::Fg(color::Reset), line);
                        continue;
                    },
                };

                vec.push(t);
            }

            Ok(Self(vec))
        }
    }
}
