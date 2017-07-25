# QLCommonMark

## Introduction

`QLCommonMark` is a QuickLook generator for [CommonMark](http://commonmark.org/) and Markdown files.  It uses [cmark](https://github.com/jgm/cmark) to render the text, and Bootstrap to style it.

## Installation

[Download `QLCommonMark.qlgenerator`](https://github.com/digitalmoksha/QLCommonMark/releases/download/v1.1/QLCommonMark.qlgenerator.zip) and copy it to your `~/Library/QuickLook` or `/Library/QuickLook` folder.  If the plugin is not picked up immediately, you may need to run `qlmanage -r` from the Terminal.

### Homebrew

If you have [Homebrew-Cask](https://github.com/caskroom/homebrew-cask) installed, you can install `QLCommonMark` with the following

`$ brew update`

`$ brew cask install qlcommonmark`

and uninstall using

`$ brew cask uninstall qlcommonmark`


## Inspiration

This project was inspired by:

- [ttscoff/MMD-QuickLook: Improved QuickLook generator for MultiMarkdown files](https://github.com/ttscoff/MMD-QuickLook)
- [toland/qlmarkdown: QuickLook generator for Markdown files.](https://github.com/toland/qlmarkdown)

## CommonMark Editor for macOS

`Versatil Markdown` is a CommonMark compliant Markdown editor for macOS, and incorporates `QLCommonMark`.  You can check out a free trial on the [Versatil Markdown website](https://versatilapp.com).