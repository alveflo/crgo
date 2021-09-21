import crateinforesolver
import asyncdispatch

let res = waitFor getCrateInfo("serde")
echo "completed"
echo "Name: " & res.name
echo "Version: " & res.version

echo "Features:"

for feature in res.features:
  echo feature
