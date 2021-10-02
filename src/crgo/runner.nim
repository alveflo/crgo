let doc = """
Crgo

Usage:
  crgo add <pkgname> [version <version>] [features <features>]


Examples:
  crgo add pkg --version 1.0.0 --features "foo, bar"
"""

import docopt
import strutils
import crateinforesolver
import asyncdispatch
import options

proc getPackage(name: string) {.async.} =
  let res = await getCrateInfo(name)
  if res.isSome:
    let info = res.get()
    echo "completed"
    echo "Name: " & info.name
    echo "Version: " & info.version

    echo "Features:"
    for feature in info.features:
      echo "- " & feature
  else:
    echo "Unable to find crate."

proc run* {.async.} =
  let args = docopt(doc, version = "Crgo 1.0")

  if args["add"]:
    let pkg = args["<pkgname>"]
    if pkg.kind != ValueKind.vkStr:
      echo "Unknown package $#".format(pkg)
    elif pkg.option.isNone:
      echo "Please provide a package name."
    else:
      await getPackage($args["<pkgname>"])
    # echo "Adding $# into Cargo.toml".format(args["<pkgname>"])
    # if args["version"]:
    #   echo "With version $#".format(args["<version>"])
    # if args["features"]:
    #   echo "With features $#".format(args["<features>"])