import strutils
import asyncdispatch, httpclient
from json import parseJson, to
import tables
import options

type CrateResponse = object
  name*, vers*: string
  features*: Table[string, seq[string]]

type CrateInfo* = object
  name*, version*: string
  features*: seq[string]

proc getCratePath*(name: string): string =
  if name.len < 4:
    result = intToStr(name.len) & "/" & name
  else:
    let a = substr(name, 0, 1)
    let b = substr(name, 2, 3)

    result = a & "/" & b & "/" & name

proc ResolveResponseEntry(response: string, version: Option[string]): Option[string] =
  let splitted = response.split("\n")

  if version.isNone:
    return some(splitted[splitted.len - 2])
  else:
    for line in splitted:
      if line.contains("\"vers\":\"$#\"".format(version.get())):
        return some(line)
  return none(string)

proc getCrateInfo*(name: string, version: Option[string]): Future[Option[CrateInfo]] {.async.} =
  let client = newAsyncHttpClient()
  let githubUrl = "https://raw.githubusercontent.com/rust-lang/crates.io-index/master/";

  try:
    let cratePath = getCratePath(name)
    let url = githubUrl & "/" & cratePath
    let response = await client.getContent(url)

    let entry = ResolveResponseEntry(response, version)
    if entry.isNone and version.isSome:
      echo "Version '$#' were not found for package '$#'."
        .format(version.get(), name)
      return none(CrateInfo)
    elif entry.isNone:
      return none(CrateInfo)

    let crateResponse = parseJson(entry.get()).to(CrateResponse)
    var features = newSeq[string]()
    for feature in crateResponse.features.keys:
      features.add(feature)

    return some(CrateInfo(name: crateResponse.name,
      version: crateResponse.vers,
      features: features))
  except HttpRequestError:
    return none(CrateInfo)
