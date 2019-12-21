# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Changed
- Move `src/tags.cr` into `src/markout/`

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
