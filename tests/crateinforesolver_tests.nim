import unittest
import crateinforesolver

suite "crateinforesolver":
  test "When name length is 1, then correct name is resolved":
    let name = getCratePath "n"
    check "1/n" == name

  test "When name length is 2, then correct name is resolved":
    let name = getCratePath "na"
    check "2/na" == name

  test "When name length is 3, then correct name is resolved":
    let name = getCratePath "nam"
    check "3/nam" == name

  test "When name length is 4, then correct name is resolved":
    let name = getCratePath "name"
    check "na/me/name" == name

  test "When name length is greater than 4, then correct name is resolved":
    let name = getCratePath "name_name_name"
    check "na/me/name_name_name" == name
