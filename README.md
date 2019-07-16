[![Build Status](https://travis-ci.org/MLSDev/dinero.svg?branch=master)](https://travis-ci.org/MLSDev/dinero)


# Dinero
Elixir library for working with Money (slang Dinero)

## How to use
```elixir
  ten_bucks = Dinero.new(10, :USD) #%Dinero{amount: 1000, currency: :USD}
  twenty_bucks = Dinero.add(ten_bucks, 10) #%Dinero{amount: 2000, currency: :USD}
  two_bucks = Dinero.subtract(twenty_bucks, 18) #%Dinero{amount: 200, currency: :USD}
  four_bucks = Dinero.multiply(two_bucks, 2) #%Dinero{amount: 400, currency: :USD}
  convert = Dinero.convert(four_bucks, :UAH, 26.2) #%Dinero{amount: 10480, currency: :UAH}
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
    alter table (:some_table) do
      add :price, :dinero_with_currency
    end
    ```
3. Add field to the schema
    ```elixir
    schema "some_table" do
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


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dinero` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dinero, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dinero](https://hexdocs.pm/dinero).

## Authors
* [Slava Fir](mailto:fir@mlsdev.com) ([github profile][github-fir]), MLSDev 

## License
Dinero is released under the MIT license. See LICENSE for details.

## About MLSDev

[<img src="https://cloud.githubusercontent.com/assets/1778155/11761239/ccfddf60-a0c2-11e5-8f2a-8573029ab09d.png" alt="MLSDev.com">][mlsdev]

[Dinero](https://github.com/MLSDev/dinero) is maintained by MLSDev, Inc. We specialize in providing all-in-one solution in mobile and web development. Our team follows Lean principles and works according to agile methodologies to deliver the best results reducing the budget for development and its timeline. 

Find out more [here][mlsdev] and don't hesitate to [contact us][contact]!

[mlsdev]: https://mlsdev.com
[contact]: https://mlsdev.com/contact-us
[github-fir]: https://github.com/SlavaFir