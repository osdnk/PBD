import DataGenerator
{:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "pbd")
data = Postgrex.query!(pid, "SELECT * FROM conferences", [])


conferences_dates = generate_conferences()
conferenes_descriptions = []



IO.inspect conferences_dates


