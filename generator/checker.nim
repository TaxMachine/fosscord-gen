import
    std/[httpclient, json]

proc checkToken*(token: string): void =
    let
        client = newHttpClient()
    client.headers = newHttpHeaders({"Authorization": token})
    var res = client.request("https://staging.fosscord.com/api/v9/users/@me", HttpGet)
    if res.code == Http200:
        var user = parseJson(res.body)
        echo token & " is valid ✅\n(" & "ID: " & user["id"].getStr & ")"
    else:
        echo token & " is invalid ❌"