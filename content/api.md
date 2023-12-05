---
layout: page
title: API usage
---

## Introduction

The data collected for the [Passkeys Directory][site] website is available as JSON files to enable developers to
use it in their programs. You are free to use the API data as you wish, as long as you adhere to the repository [license][license].

Please be aware that any icons included in this repository are the intellectual property of their respective authors.
Redistribution of these icons freely through our API exceeds the bounds of normal fair-use principles.
The API does, therefore, not provide a means for fetching website icons. We appreciate your understanding and adherence
to these terms as we strive to respect the rights of icon creators.

### Optimizing API Usage and Dataset Retrieval

If you anticipate frequent and high-traffic queries on our JSON files, Cloudflare, our reverse proxy provider, may be
blocked. We recommend locally caching the files to optimize performance, especially for scenarios involving substantial
traffic. For specific datasets, such as all sites supporting passwordless authentication, consider utilizing the
corresponding URI for more targeted and efficient results. Refer to [URIs](#uris) for the available paths.

## Version 1 {#v1}

### URIs

| Coverage                                                 | Unsigned File                                             | PGP Signed File                                               |
|----------------------------------------------------------|-----------------------------------------------------------|---------------------------------------------------------------|
| All websites.                                            | `https://api.passkeys.2fa.directory/v1/all.json`          | `https://api.passkeys.2fa.directory/v1/all.json.sig`          |
| Websites with any form of passkey support.               | `https://api.passkeys.2fa.directory/v1/supported.json`    | `https://api.passkeys.2fa.directory/v1/supported.json.sig`    |
| Websites supporting passwordless authentication.         | `https://api.passkeys.2fa.directory/v1/passwordless.json` | `https://api.passkeys.2fa.directory/v1/passwordless.json.sig` |
| Websites supporting passkey multi factor authentication. | `https://api.passkeys.2fa.directory/v1/mfa.json`          | `https://api.passkeys.2fa.directory/v1/mfa.json.sig`          |

### Elements

Below you'll find a table describing all possible keys in the API files.  
You can also use the [JSON Schema][json_schema] for a more complete overview.

| Key                | Value Type     | Pattern                                                            | Description                                                                                                                                                                                             |
|--------------------|----------------|--------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| url                | URI            | [uri](https://www.rfc-editor.org/info/rfc6570)                     | URL of the site. If this is not defined, the url is https://`domain`                                                                                                                                    |
| additional-domains | Array\<String> | [hostname (RFC-1123 2.1)](https://www.rfc-editor.org/info/rfc1123) | Array of domains that the site exists at in addition to the main domain listed in the `domain` field.                                                                                                   |
| mfa                | String         | `/^(allowed\|required)$/`                                          | Contains `allowed` if passwordless authentication is supported but optional. Contains `required` if the service forces the usage of passwordless authentication.                                        |
| passwordless       | String         | `/^(allowed\|required)$/`                                          | Contains `allowed` if passkey as MFA authentication is supported but optional. Contains `required` if the service forces the usage of passkeys as MFA authentication.                                   |
| documentation      | URI            | [uri](https://www.rfc-editor.org/info/rfc6570)                     | URL to documentation page                                                                                                                                                                               |
| recovery           | URI            | [uri](https://www.rfc-editor.org/info/rfc6570)                     | URL to recovery documentation page                                                                                                                                                                      |
| notes              | String         | `/^(\w){10,}$/`                                                    | Text describing any discrepancies in the 2FA implementation                                                                                                                                             |
| contact            | Object         | [See Contact Object Elements](#contact)                            | Object containing contact details. See table below for elements                                                                                                                                         |
| regions            | Array\<String> | `/^-?[a-z]{2}$/`                                                   | Array containing ISO 3166-1 country codes of the regions in which the site is available. If the site is available everywhere apart from a specific region, that region will be prefixed by a `-` symbol |

#### Contact Object Elements {#contact}

| Key      | Value  | Pattern                                                           | Description                                                            |
|----------|--------|-------------------------------------------------------------------|------------------------------------------------------------------------|
| twitter  | String | `/^(\w){1,15}$/`                                                  | Twitter/X handle                                                       |
| facebook | String | `/^(\w){1,}$/`                                                    | Facebook page name                                                     |
| email    | String | [email (RFC-5321 4.1.2)](https://www.rfc-editor.org/info/rfc5321) | Email address to support                                               |
| form     | String | [uri](https://www.rfc-editor.org/info/rfc6570)                    | Support contact form                                                   |
| language | String | `/^[a-z]{2}$/`                                                    | Lowercase ISO 639-1 language code for the site if it is not in English |

### Example website with passkey support

```JSON
{
  "example.com": {
    "passwordless": "allowed",
    "mfa": "allowed",
    "documentation": "https://example.com/support/enable-passkey.html"
  }
}
```

### Example website without passkey support

```JSON
{
  "example.com": {
    "contact": {
      "twitter": "example",
      "facebook": "example",
      "email": "example@example.com"
    }
  }
}
``` 

[site]: https://passkeys.2fa.directory/
[json_schema]: https://github.com/2factorauth/passkeys/blob/master/tests/api_schema.json
[license]: https://github.com/2factorauth/passkeys/tree/master/LICENSE.md
