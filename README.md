# NewsUtil


## Retrieves legal citations and bibliograhic info from a web page

This is currently for internal use: It outputs Ruby code that creates
ActiveRecord objects. Next version will output JSON.


```bash
$ retrieve https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/
```

produces...

```ruby
Source.find_or_create_by!(name: "Probate Stars", url: "https://probatestars.com")

NewsImport.add(
  Item.find_or_create_by(
    url:              URI('https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/').to_s,
    title:            "Texas Trust Protector Has No Fiduciary Duty to Settlor",
    summary:          "Under Texas law a trust protector has no fiduciary duty to the settlor of the trust, but may have one to the trustee or beneficiaires.",
    secondary_source: Source.find_by!(name: 'Probate Stars'),
    published_on:     Date.parse('2020-05-19'),
  ),
  [
    'Tex. Prop. Code Section 114.0031'
  ]
)
```


## To auto-run tests

```bash
fswatch lib test | xargs -I {} sh -c 'clear && mix test'
```
