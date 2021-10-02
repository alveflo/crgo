import docopt
import strutils

let doc = """
Crgo

Usage:
  crgo add <pkgname> [version <version>] [features <features>]


Examples:
  crgo add pkg --version 1.0.0 --features "foo, bar"
"""

proc parse* =
  let args = docopt(doc, version = "Crgo 1.0")

  if args["add"]:
    echo "Adding $# into Cargo.toml".format(args["<pkgname>"])
    if args["version"]:
      echo "With version $#".format(args["<version>"])
    if args["features"]:
      echo "With features $#".format(args["<features>"])