import
    std/[os, db_sqlite],
    generator/[tokengen, joiner, checker]

let db = open("./tokens.db", "", "", "")

proc initDB: void =
    db.exec(sql"""CREATE TABLE IF NOT EXISTS tokens (
        token TEXT NOT NULL
    )""")

proc main(): void =
    fossCordGen()

when isMainModule:
    discard execShellCmd("clear")
    main()
    #var toucan = db.getAllRows(sql"SELECT token FROM tokens")
    #for i in toucan:
        #join("SObG33", i[0])
        #checkToken(i[0])