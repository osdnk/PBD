import List
defmodule DataGenerator do
  @moduledoc false
  def generate_dates do
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

end