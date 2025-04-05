<!--markdownlint-disable MD041-->
## SanDisk Dashboard

SanDisk Dashboard (formerly Western Digital Dashboard) features the ability to:

- Maintain peak performance of the SanDisk and Western Digital solid state drives (SSD) in Windows® operating systems
- Analyze drives (including the disk model, capacity, firmware version, drive health and SMART attributes)
- Update drive firmware

![SanDisk Dashboard Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-sandisk-dashboard@ef302252ab8abcde52dfb74721cca2da24a9c42f/Screenshot.png)

## Package Parameters

- `/Language:UI_STRING_OR_LANGUAGE_TAG` - Overrides the default language configuration.

    Supported languages include:

    |UI String|Language Tag|Language Name|
    |-|-|-|
    |Čeština|cs-CZ|Czech|
    |Dansk|da-DK|Danish|
    |Deutsch|de-DE|German|
    |English|en-US|English|
    |Español|es-ES|Spanish|
    |Françias|fr-FR|French|
    |Italiano|it-IT|Italian|
    |日本語|ja-JP|Japanese|
    |한국어|ko-KR|Korean|
    |Nederlands|nl-NL|Dutch|
    |Polski|pl-PL|Polish|
    |Português|pt-PT|Portuguese|
    |Pусский|ru-RU|Russian|
    |Svenska|sv-SE|Swedish|
    |Türkçe|tr-TR|Turkish|
    |简体中文|zh-CN|Simplified Chinese|
    |繁體中文|zh-TW|Traditional Chinese|

- `/Start` - Automatically start Dashboard after the installation completes.

### Examples

```shell
choco install sandisk-dashboard --params="'/Language:Español'"
```

```shell
choco install sandisk-dashboard --params="'/Language:fr-FR'"
```

```shell
choco install sandisk-dashboard --params="'/Start'"
```

```shell
choco install sandisk-dashboard --params="'/Language:Deutsch /Start'"
```

## [Package Notes](https://github.com/brogers5/chocolatey-package-sandisk-dashboard/blob/v5.0.2.3/PACKAGE-NOTES.md)
