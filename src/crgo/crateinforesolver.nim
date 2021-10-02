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

proc getCratePath*(name: string):string =
  if name.len < 4:
    result = intToStr(name.len) & "/" & name
  else:
    let a = substr(name, 0, 1)
    let b = substr(name, 2, 3)

    result = a & "/" & b & "/" & name

proc getCrateInfo*(name: string): Future[Option[CrateInfo]] {.async.} =
  let client = newAsyncHttpClient()
  let githubUrl = "https://raw.githubusercontent.com/rust-lang/crates.io-index/master/";

  try:
    let cratePath = getCratePath(name)
    let url = githubUrl & "/" & cratePath
    let response = await client.getContent(url)
    let splitted = response.split("\n")
    let latest = splitted[splitted.len - 2]

    let crateResponse = parseJson(latest).to(CrateResponse)
    var features = newSeq[string]()
    for feature in crateResponse.features.keys:
      features.add(feature)

    result = some(CrateInfo(name: crateResponse.name,
      version: crateResponse.vers,
      features: features))
  except HttpRequestError:
    result = none(CrateInfo)