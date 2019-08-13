[![Build Status](https://travis-ci.org/MLSDev/dinero.svg?branch=master)](https://travis-ci.org/MLSDev/dinero)


# Dinero
Elixir library for working with Money (slang Dinero)

## How to use
```elixir
  iex> ten_bucks = Dinero.new(10, :USD)
  %Dinero{amount: 1000, currency: :USD}
  iex> twelve_bucks = Dinero.new(12, :USD)
  %Dinero{amount: 1200, currency: :USD}
  iex> two_bucks = Dinero.subtract(twenty_bucks, ten_bucks)
  %Dinero{amount: 200, currency: :USD}
  iex> four_bucks = Dinero.multiply(two_bucks, 2)
  %Dinero{amount: 400, currency: :USD}
  iex> convert = Dinero.convert(four_bucks, :UAH, 26.2)
  %Dinero{amount: 10480, currency: :UAH}
  iex> d = ~m[924.06]uah
  %Dinero{amount: 92406, currency: :UAH}
  iex> "Amount #{d}"
  "Amount 924.06"
  iex> Dinero.new(1.0e4, :USD) 
  %Dinero{amount: 1000000, currency: :USD}
  iex> Dinero.parse("1312.14")
  %Dinero{amount: 131214, currency: :USD}
```

### Using with Postgres
`Dinero.Ecto.DineroWithCurrency` is an Ecto type that allows saving amount of dinero with currency to database.

1. Create custom Postrgres type
    ```elixir
    def up do
      execute "CREATE TYPE public.dinero_with_currency AS (amount integer, currency char(3))"
    end
    
    def down do
      execute "DROP TYPE public.dinero_with_currency"
    end
    ```
2. Add column to the table
    ```elixir
    alter table (:products) do
      add :price, :dinero_with_currency
    end
    ```
3. Add field to the schema
    ```elixir
    schema "products" do
      field :price, Dinero.Ecto.DineroWithCurrency
    end
    ```
4. Save to DB:
    ```elixir
    iex> Repo.insert %Product{price: Dinero.new(20, :USD)}
    [debug] QUERY OK db=2.6ms decode=0.5ms queue=0.4ms
      INSERT INTO "products" ("price","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" [{2000, "USD"}, ~N[2019-07-15 12:47:38], ~N[2019-07-15 12:47:38]]
    {:ok,
      %EctoCustomType.Product{
      __meta__: #Ecto.Schema.Metadata<:loaded, "products">,
      id: 1,
      inserted_at: ~N[2019-07-15 12:47:38],
      price: %Dinero{amount: 2000, currency: :USD},
      updated_at: ~N[2019-07-15 12:47:38]
    }}
    ```
5. Get from DB:
    ```elixir
    iex> Repo.all(Product)
    [debug] QUERY OK source="products" db=1.2ms queue=1.3ms
    SELECT p0."id", p0."price", p0."inserted_at", p0."updated_at" FROM "products" AS p0 []
    [
      %EctoCustomType.Product{
        __meta__: #Ecto.Schema.Metadata<:loaded, "products">,
        id: 1,
        inserted_at: ~N[2019-07-15 12:47:38],
        price: %Dinero{amount: 2000, currency: :USD},
        updated_at: ~N[2019-07-15 12:47:38]
      }
    ]

    ```

### Dinero.Sigil

```elixir
# Sigils for Dinero
import Dinero.Sigil

iex> ~m[100]UAH
%Dinero{amount: 10000, currency: :UAH}

# Default currency is USD
iex> ~m[100]
%Dinero{amount: 10000, currency: :USD}
```

## Installation

It is [available in Hex](https://hex.pm/packages/dinero) and can be installed
by adding `dinero` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dinero, "~> 1.2.2"}
  ]
end
```

Documentation can be found [here](https://hexdocs.pm/dinero)

## Authors
* [Slava Fir][github-fir] , MLSDev 

## License
Dinero is released under the MIT license. See LICENSE for details.

## About MLSDev

[<img src="https://raw.githubusercontent.com/MLSDev/development-standards/master/mlsdev-logo.png" alt="MLSDev.com">][mlsdev]

[Dinero](https://github.com/MLSDev/dinero) is maintained by MLSDev, Inc. We specialize in providing all-in-one solution in mobile and web development. Our team follows Lean principles and works according to agile methodologies to deliver the best results reducing the budget for development and its timeline. 

Find out more [here][mlsdev] and don't hesitate to [contact us][contact]!

[mlsdev]: https://mlsdev.com
[contact]: https://mlsdev.com/contact-us
[github-fir]: https://github.com/SlavaFir