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

# proc getPackage(name: string) {.async.} =
#   let res = await getCrateInfo(name)
#   if res.isSome:
#     let info = res.get()
#     echo "completed"
#     echo "Name: " & info.name
#     echo "Version: " & info.version

#     echo "Features:"
#     for feature in info.features:
#       echo "- " & feature
#   else:
#     echo "Unable to find crate."

proc run* {.async.} =
  let args = docopt(doc, version = "Crgo 1.0")

  if args["add"]:
    let pkg = args["<pkgname>"]
    if pkg.kind != ValueKind.vkStr:
      echo "Unknown package $#".format(pkg)
    elif pkg.option.isNone:
      echo "Please provide a package name."
    else:
      let desiredVersion = (if args["version"]: some($args["<version>"]) else: none(string))

      let res = await getCrateInfo($args["<pkgname>"], desiredVersion)
      
      let desiredFeatures = (if args["features"]: some($args["<features>"]) else: none(string))

      if res.isSome:
        let crate = res.get()
        var featuresToAdd = newSeq[string]()
        
        if desiredFeatures.isSome:
          let features = desiredFeatures.get()

          for feature in features.split(','):
            let trimmedFeature = feature.strip()
            if not crate.features.contains(trimmedFeature):
              echo "Unsupported feature '$#'".format(trimmedFeature)
              return
            else:
              featuresToAdd.add(trimmedFeature)


      # await getPackage($args["<pkgname>"])


    # echo "Adding $# into Cargo.toml".format(args["<pkgname>"])
    # if args["version"]:
    #   echo "With version $#".format(args["<version>"])
    # if args["features"]:
    #   echo "With features $#".format(args["<features>"])