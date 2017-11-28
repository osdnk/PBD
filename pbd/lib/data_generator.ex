import List
defmodule DataGenerator do
  @moduledoc false
  def generate_conferences do
    first_date = ~D[2000-01-01]
    r = :rand.uniform(30)
    new_date = Date.add(first_date, r)
    get_dates([add_description(new_date)], 1095)

  end

  def get_dates(l, n) when n < 0 do
    l
  end

  def get_dates(l, n) do
    r = :rand.uniform(30)
    fst = first l
    new_date = Date.add(fst.date, r)
    inc_list = [add_description(new_date) | l]
    rem = n - r
    get_dates(inc_list, rem)
  end


  def add_description (date) do
    %{date: date,
      name: Faker.App.name(),
      desc: Faker.Company.En.bs()
    }
  end

  def generate_private_clients do
    get_private_clients(add_pcdescription(), 10)
  end

  def get_private_clients(l, n) when n < 0 do
    l
  end

  def get_private_clients(l, n) do
    inc_list = [add_private_client_description() | l]
    get_private_clients(inc_list, n-1)
  end

  def add_private_client_description do
    %{FirstName: Faker.Name.first_name(),
      LastName: Faker.Name.last_name(),
      EMail: Faker.Internet.free_email(),
      Phone: Faker.Phone.EnUs.phone(),
      Address: Faker.Address.street_address()
    }
  end

  def generate_company_clients do
    get_company_clients(add_ccdescription(), 10)
  end

  def get_company_clients(l, n) when n < 0 do
    l
  end

  def get_company_clients(l, n) do
    inc_list = [add_ccdescription() | l]
    get_cclients(inc_list, n-1)
  end

  def add_company_client_description do
    %{Name: Faker.Company.name(),
      EMail: Faker.Internet.free_email(),
      Phone: Faker.Phone.EnUs.phone(),
      Address: Faker.Address.street_address()
    }
  end

end