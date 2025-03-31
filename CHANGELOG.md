# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-03-31

### Fixed
- Performance: Avoid intermediate strings

## [1.1.0] - 2024-08-06

### Added
- Add `Markout::Component#render` method

### Changed
- Accept arbitrary HTML attribute names

## [1.0.0] - 2023-05-29

### Added
- First stable release

## [0.8.1] - 2022-03-17

### Added
- Ensure support for *Crystal* v1.1, v1.2 and v1.3

## [0.8.0] - 2021-04-13

### Added
- Add support for [Vue JS](https://vuejs.org) template syntax
- Add support for block components

### Changed
- Bump minimum required *Crystal* version to v1.0
- Rename `Markout::HTML` to just `Markout`.
- Rename `Markout::Version` to `Markout::HtmlVersion`
- Rename `Markout#version` to `Markout#html_version`

## Remove
- Remove support for [Onyx framework](https://onyxframework.org)

## [0.7.0] - 2020-03-09

### Added
- Add support for Crystal version 0.33.0
- Add support for [Onyx framework](https://onyxframework.org)

### Changed
- Convert `Markout::HTML` from a class into a module

## [0.6.1] - 2020-01-15

### Fixed
- Fix incorrect boolean attribute syntax for XHTML

## [0.6.0] - 2020-01-04

### Added
- Add support for components/partials
- Add support for valueless [boolean attributes](https://html.spec.whatwg.org/multipage/common-microsyntaxes.html#boolean-attributes)

### Changed
- Move types into a new `Markout::HTML` namespace

### Fixed
- Fix unquoted path in shell command for `Markout::VERSION`
- Allow setting HTML version in pages and components

### Removed
- Remove `Markout::Page#initialize`

## [0.5.0] - 2019-12-21

### Changed
- Move `src/tags.cr` into `src/markout/`
- Avoid sharing a Markout object across pages/templates
- Rename `Markout::Template::Base` to `Markout::Page`

## [0.4.0] - 2019-12-20

### Added
- Add `Markout::VERSION`
- Add `#tag` to render custom tags

### Changed
- Use `struct` (instead of `class`) for page templates

## 0.3.0 - 2019-03-29

### Added
- Add a cursory validation for HTML tags

### Changed
- Use `yield...` instead of `with...yield` for building HTML
- Rename `Markout::BaseTemplate` to `Markout::Template::Base`

### Removed
- Remove transitional, strict, frameset variations from Markout::Version

## 0.2.0 - 2018-10-10

### Changed
- Explicitly assign a receiver to instance methods called inside `with ... yield` block
- Allow creating non-void elements without passing a block
- Remove pre-defined charset meta element in base template

## 0.1.0 - 2018-10-02

### Added
- Initial public release
