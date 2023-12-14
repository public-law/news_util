# Bibliographic Info Crawler


## Retrieves legal citations and bibliograhic info from a web page

It outputs JSON or Ruby code.


```bash
$ retrieve https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/
```

produces...

```json
{
  "title": "What Not to Say at a Drunk Driving Stop",
  "citations": [
    "Tex. Transp. Code Title 7 Subtitle J Chapter 724"
  ],
  "description": "During a DUI or DWI stop in Orange, TX, it's crucial to navigate the situation wisely. Refrain from admissions of guilt, making incriminating statements, and oversharing personal details. Stay calm, avoid arguing, cooperate without compromising rights, and wisely choose when to mention legal counsel. Making the right choices during the stop can protect your interests. The Bearden Law Firm is here to help.",
  "source_name": "The Bearden Law Firm",
  "source_url": "https://beardenlawfirm.net",
  "date_modified": "2023-10-30"
}
```


## To auto-run tests

```bash
fswatch lib test | xargs -I {} sh -c 'clear && mix test'
```
