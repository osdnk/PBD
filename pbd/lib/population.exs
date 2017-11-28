import DataGenerator
{:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "pbd")
data = Postgrex.query!(pid, "SELECT * FROM conferences", [])


conferences_dates = generate_conferences()
conferenes_descriptions = []

private_clients = generate_private_clients()

company_clients = generate_company_clients()



IO.inspect conferences_dates

IO.inspect private_clients

IO.inspect company_clients

