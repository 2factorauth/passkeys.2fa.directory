<h1 align="center">Passkeys Directory - Frontend</h1>

<p align="center">
  <a href="https://twitter.com/2faorg/"><img src="https://img.shields.io/badge/X/Twitter-@2faorg-1DA1F2.svg?style=for-the-badge&logo=x"/></a>
  <a href="https://infosec.exchange/@2factorauth"><img src="https://img.shields.io/badge/Mastodon-@2factorauth-6364FF?style=for-the-badge&logo=mastodon"/></a>
  <a href="https://github.com/sponsors/2factorauth/"><img src="https://img.shields.io/github/sponsors/2factorauth?color=db61a2&logo=GitHub&style=for-the-badge"/></a>
</p>

[Passkeys Directory][website] is an open-source project that aims to improve online security by providing a directory of
websites and services that support passkey authentication. Our community-driven platform allows anyone to contribute to
the list, making it the most comprehensive directory of its kind.

This repository contains the HTML, JavaScript and CSS for [passkeys.2fa.directory][website].  
The data used to populate the categories is located in [2factorauth/passkeys][data_repo].

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://i.imgur.com/JnnjEyg.png">
  <source media="(prefers-color-scheme: light)" srcset="https://i.imgur.com/92cAVal.png">
  <img alt="screenshot" src="https://i.imgur.com/mNW7Dnp.png">
</picture>

## Local installation

The website is based on the static site generator [Hugo][hugo].
To build locally you will need to follow the [installation instructions][hugo_install] for Hugo. [Ruby][ruby_install] is also required for some scripts.

After you've installed Hugo and Ruby, follow these steps to build the site locally:

1. Install NPM packages
   `npm install`
1. Install Ruby gems
   `bundle install`
1. Fetch entries:
   `./scripts/generate_entries.rb`
1. Generate regional pages:
   `./scripts/generate_regions.rb`
1. Run Hugo locally:
   `hugo serve`  
   The site should then be reachable at [127.0.0.1:1313][localhost].

> [!Note]
> The [region-redirection](/functions/redirect.js) script does not run locally. You will therefore always be directed to
> the international page when using `hugo serve`.

## Publishing forks

This repository is built on the frameworks of [Cloudflare Pages][cf_pages] and requires the build process to be done via
Cloudflare.

To publish your fork of this repo, follow these steps:

1. Log in to your Cloudflare [Dashboard][cf_dash] and select Pages. Create a new project and select
   your fork as the source.
2. When prompted for build configuration, enter the following:
   * **Framework preset:** `None`
   * **Build command:** `./scripts/build.sh`
   * **Build output directory:** `/public`

## Contributing

When contributing changes to this repository, please make sure your IDE follows
our [editorconfig][editorconfig].

The general file structure is as follows:

|     Type     | Path                  |
|:------------:|-----------------------|
|  JavaScript  | `assets/js`           |
|     CSS      | `assets/css`          |
|   Layouts    | `layouts/_default`    |
|    Pages     | `content`             |
| Translations | `data/languages.json` |

## License

This project is licensed under GPLv3. For the entire license see [LICENSE](/LICENSE).

Before you make changes to the code, please keep the following in mind:

* The data is [licensed separately][data_license].
* Attribution is required if you use this project as a template for your own website.
* The initial contents of [LICENSE](/LICENSE) must still be included in distributions and forks but we allow (and
  encourage) you to prepend your own copyright and GPLv3-compatible license for changes you make.

For a more information on what is and isn't allowed under a GPLv3 license, see
this [guide][gplv3_guide].

[cf_dash]: https://dash.cloudflare.com/
[cf_pages]: https://pages.cloudflare.com/
[data_repo]: https://github.com/2factorauth/passkeys.git
[data_license]: https://github.com/2factorauth/passkeys/blob/master/LICENSE.md
[editorconfig]: https://editorconfig.org/
[gplv3_guide]: https://www.gnu.org/licenses/quick-guide-gplv3.html
[hugo]: https://gohugo.io/
[localhost]: http://127.0.0.1:1313/
[hugo_install]: https://gohugo.io/installation/
[ruby_install]: https://www.ruby-lang.org/en/documentation/installation/
[website]: https://passkeys.2fa.directory/
