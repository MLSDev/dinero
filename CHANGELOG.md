# Changelog
## `1.2.2` - 13.08.2019
 - Ability to create `Dinero` struct from String added. See `Dinero.parse/2`
 - Ability to create `Dinero` struct from [scientific notation](https://en.wikipedia.org/wiki/Scientific_notation)
## `1.2.1` - 10.08.2019
 - Convertation fixed
 - Default currency for sigil is USD
 - `String.Chars` implemented and now `Dinero` can be used as an argument for `to_string/1`
## `1.2.0` - 22.07.2019
 - Now it contains 2 methods `Dinero.multiply/2` and `Dinero.mulitply/3` for truncations and rounding up results of multiplying
 - Now there are `Dinero.divide/2` and `Dinero.divide/3` for truncations and rounding up results of dividing
 - Small docs fixes

## `1.1.0` - 19.07.2019
- Ability to add/subtract int or float values removed. Now `Dinero.add/2` and `Dinero.subtract/2` use only `Dinero` structs for calculations

## `1.0.0` - 15.07.2019
- Initial Release