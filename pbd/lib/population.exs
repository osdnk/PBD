import DataGenerator
import Postgrex.Extension
{:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "pbd")
data = Postgrex.query!(pid, "SELECT * FROM conferences", [])


conferences_dates = generate_conferences()

Postgrex.query!(pid, "DELETE FROM conferencedays", [])
Postgrex.query!(pid, "DELETE FROM conferences", [])


day_id = 0;
for v <- conferences_dates do
  conf = Postgrex.query!(pid,
  "insert into conferences (conferenceid, name, discountforstudents, description)
  values (#{v.id}, '#{v.name}', #{v.discount}, '#{v.description}')", [])
  for d <- [0 .. v.length-1] do
    date = Date.to_iso8601((Date.add(v.date, 1)))
    IO.inspect day_id
    Postgrex.query!(pid,
      "insert into conferencedays (conferencedayid, conferences_conferenceid, date, numberofparticipants)
      values (#{day_id}, #{v.id}, '#{date}', '#{:rand.uniform(100)+100}')", [])
      day_id = day_id + 1;
  end

end
{private_clients, last_client_id} = generate_private_clients()

{company_clients, last_client_id} = generate_company_clients(last_client_id+1)

number_of_clients  =last_client_id + 1;




#IO.inspect conferences_dates

#IO.inspect private_clients

#IO.inspect company_clients

