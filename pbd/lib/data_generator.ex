import List
defmodule DataGenerator do
  @moduledoc false

  #conferences

  def generate_conferences do
    first_date = ~D[2000-01-01]
    r = :rand.uniform(30)
    new_date = Date.add(first_date, r)
    get_dates([add_conference_description(new_date, 0)], 1095)

  end

  defp get_dates(l, n) when n < 0 do
    l
  end

  defp get_dates(l, n) do
    r = :rand.uniform(30)
    fst = first l
    new_date = Date.add(fst.date, r)
    inc_list = [add_conference_description(new_date, Kernel.length l) | l]
    rem = n - r
    get_dates(inc_list, rem)
  end


  defp add_conference_description(date, i) do
    %{
      date: date,
      name: Faker.App.name(),
      description: Faker.Company.En.bs(),
      length: :rand.uniform(2)+1,
      discount: :rand.uniform(100)-1,
      id: i
    }
  end

  # private clients

  def generate_private_clients do
    {get_private_clients(get_private_client_description(0), 99), 99}
  end

  defp get_private_clients(l, n) when n < 0 do
    l
  end

  defp get_private_clients(l, n) do
    inc_list = [get_private_client_description(n-1) | l]
    get_private_clients(inc_list, n - 1)
  end

  defp get_private_client_description(i) do
    %{
      first_name: Faker.Name.first_name(),
      last_name: Faker.Name.last_name(),
      email: Faker.Internet.free_email(),
      phone: Faker.Phone.EnUs.phone(),
      address: Faker.Address.street_address(),
      id: i,
      client_id: i
    }
  end

  # company clients

  def generate_company_clients(start_id) do
    {get_company_clients(get_company_client_description(99, start_id), 99, start_id), 99+start_id}
  end

  defp get_company_clients(l, n, s_i) when n < 0 do
    l
  end

  defp get_company_clients(l, n, s_i) do
    inc_list = [get_company_client_description(n-1, s_i) | l]
    get_company_clients(inc_list, n - 1, s_i)
  end

  defp get_company_client_description(i, s_i) do
    %{
      name: Faker.Company.name(),
      email: Faker.Internet.free_email(),
      phone: Faker.Phone.EnUs.phone(),
      address: Faker.Address.street_address(),
      id: i,
      client_id: i+s_i
    }
    end







end