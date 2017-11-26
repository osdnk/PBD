import List
defmodule DataGenerator do
  @moduledoc false
  def generate_conferences do
    first_date = ~D[2000-01-01]
    r = :rand.uniform(30)
    new_date = Date.add(first_date, r)
    get_dates([add_descrition(new_date)], 1095)

  end

  def get_dates(l, n) when n < 0 do
    l
  end

  def get_dates(l, n) do
    r = :rand.uniform(30)
    fst = first l
    new_date = Date.add(fst.date, r)
    inc_list = [add_descrition(new_date) | l]
    rem = n - r
    get_dates(inc_list, rem)
  end

  def print_multiple_times(msg, n) when n <= 1 do
    IO.puts msg
  end

  def print_multiple_times(msg, n) do
    IO.puts msg
    print_multiple_times(msg, n - 1)
  end

  def add_descrition (date) do
    %{date: date,
      name: Faker.App.name(),
      desc: Faker.Company.En.bs()
    }
  end

  def generate_privateclients do
    get_pclients(add_pcdescription(), 10)
  end

  def get_pclients(l, n) when n < 0 do
    l
  end

  def get_pclients(l, n) do
    inc_list = [add_pcdescription() | l]
    get_pclients(inc_list, n-1)
  end

  def add_pcdescription do
    %{FirstName: Faker.Name.first_name(),
      LastName: Faker.Name.last_name(),
      EMail: Faker.Internet.free_email(),
      Phone: Faker.Phone.EnUs.phone(),
      Address: Faker.Address.street_address()
    }
  end

  def generate_companyclients do
    get_cclients(add_ccdescription(), 10)
  end

  def get_cclients(l, n) when n < 0 do
    l
  end

  def get_cclients(l, n) do
    inc_list = [add_ccdescription() | l]
    get_cclients(inc_list, n-1)
  end

  def add_ccdescription do
    %{Name: Faker.Company.name(),
      EMail: Faker.Internet.free_email(),
      Phone: Faker.Phone.EnUs.phone(),
      Address: Faker.Address.street_address()
    }
  end
end