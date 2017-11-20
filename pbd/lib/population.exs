{:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "pbd")
data = Postgrex.query!(pid, "SELECT * FROM conferences", [])
IO.inspect data
