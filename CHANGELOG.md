# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.1.1 - 2017-3-13

* Initial release with `Instagram::User` supporting `find_by`, `find_by!` and `where`.

## 0.2.1 - 2017-3-14

* [FEATURE] Add `.posts` to instance of `Instagram::User`.

## 0.2.2 - 2017-3-14

* [IMPROVEMENT] Rename `.posts` to `.videos`.

## 0.2.5 - 2017-5-31

* [BUGFIX] Return nil for an Instagram video's caption if it doesn't exist.

## 0.2.6 - 2017-5-31

* [BUGFIX] Add missing tests and errors for a private Instagram user.

## 0.2.7 - 2017-7-26

* [FEATURE] Add `Instagram::Video` support for `find_by media_id:` and `find_by! media_id:`

## 0.2.8 - 2017-7-27

* [FEATURE] Add `Instagram::Video` support for `find_by shortcode:` and `find_by! shortcode:`

## 0.2.9 - 2017-11-30

* [FEATURE] Add `Instagram::Video` support for `find_by private_shortcode:` and `find_by! private_shortcode:`

## 0.2.10 - 2017-12-20

* [BUGFIX] Return nil for an Private Instagram video's caption if it doesn't exist.

## 0.2.11 - 2018-04-17

* [BUGFIX] Remove deprecated `find_by media_id` endpoint.
* [IMPROVEMENT] Remove `find_by private_shortcode`.

## 0.2.12 - 2018-06-04

* [BUGFIX] Update deprecated `user.videos` method and add scraping support.
