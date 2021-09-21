import crateinforesolver
import asyncdispatch
import options

let res = waitFor getCrateInfo("serde")
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