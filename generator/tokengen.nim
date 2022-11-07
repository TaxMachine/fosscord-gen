import
    std/[json, random, strutils, db_sqlite, base64, httpclient, os],
    proxy

let db = open("./tokens.db", "", "", "")

proc loadProxy: string =
    return "http://" & sample(proxies)

proc rdnHash*: string =
    randomize()
    var res: string
    for _ in 0..20:
        res.add(char(rand(int('A') .. int('Z'))))
    return res

proc rdnClientBuild*: string =
    randomize()
    var res: string
    for _ in 0..6:
        res.add($rand(0..9))
    return res

proc fossCordGen*: void =
    var
        super: JsonNode = %*{
            "os":"Linux",
            "browser":"Chrome",
            "device":"",
            "system_locale":"en-GB",
            "browser_user_agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36",
            "browser_version":"106.0.0.0",
            "os_version":"",
            "referrer":"https://fosscord.com/",
            "referring_domain":"fosscord.com",
            "referrer_current":"https://fosscord.com/",
            "referring_domain_current":"fosscord.com",
            "release_channel":"stable",
            "client_build_number":rdnClientBuild(),
            "client_event_source":"null"
        }
        body: JsonNode = %*{
            "captcha_key": nil,
            "consent": true,
            "date_of_birth": "1945-07-07",
            "email": rdnHash() & "@nigger.black",
            "gift_code_sku_id": nil,
            "invite": nil,
            "password": rdnHash(),
            "promotional_email_opt_in": false,
            "username": "Taksgen-" & rdnHash(),
        }
        poxy = newProxy(loadProxy())
        client = newHttpClient(proxy = poxy)
    client.headers = newHttpHeaders({"Content-Type": "application/json"})
    client.headers = newHttpHeaders({"Host": "staging.fosscord.com"})
    client.headers = newHttpHeaders({"Origin": "https://staging.fosscord.com"})
    client.headers = newHttpHeaders({"Origin": "https://staging.fosscord.com"})
    client.headers = newHttpHeaders({"Referer": "https://staging.fosscord.com/register"})
    client.headers = newHttpHeaders({"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"})
    client.headers = newHttpHeaders({"X-Discord-Locale": "en-GB"})
    client.headers = newHttpHeaders({"X-Super-Properties": encode($super)})
    try:
        var res = client.request("https://staging.fosscord.com/api/v9/auth/register", HttpPost, $body)
        case res.code:
            of Http200:
                echo "[+] Token Created ✅"
                db.exec(sql"""INSERT INTO tokens VALUES (
                    ?
                )""", parseJson(res.body)["token"].getStr)
            of Http404:
                echo "[x] Failed to create token ❌"
                echo res.body
            else:
                if not parseJson(res.body){"retry_after"}.isNil:
                    echo "You are being ratelimited, retrying after cooldown..."
                    var ratelimit: int = parseJson(res.body)["retry_after"].getInt
                    sleep(ratelimit)
    except Exception:
        echo "Proxy failed"