import
    std/[httpclient, base64, json],
    tokengen

proc join*(invite: string, token: string): void =
    let 
        client = newHttpClient()
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
    client.headers = newHttpHeaders({"Content-Type": "application/json"})
    client.headers = newHttpHeaders({"Authorization": token})
    client.headers = newHttpHeaders({"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"})
    client.headers = newHttpHeaders({"Host": "staging.fosscord.com"})
    client.headers = newHttpHeaders({"Origin": "https://staging.fosscord.com"})
    client.headers = newHttpHeaders({"Origin": "https://staging.fosscord.com"})
    client.headers = newHttpHeaders({"Referer": "https://staging.fosscord.com/invite" & invite})
    client.headers = newHttpHeaders({"X-Discord-Locale": "en-GB"})
    client.headers = newHttpHeaders({"X-Super-Properties": encode($super)})
    var res = client.request("https://staging.fosscord.com/api/v9/invites/" & invite, HttpPost)
    echo token
    case res.code:
        of Http200:
            echo "[+] Guild Joined ✅"
        of Http400:
            echo "[-] This account is already appart of this guild ❌"
        of Http404:
            echo "[-] Invalid guild invite ❌"
            quit(0)
        else:
            echo res.body