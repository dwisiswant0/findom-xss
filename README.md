# FinDOM-XSS

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/dwisiswanto/findom-xss/issues)


FinDOM-XSS is a tool that allows you to finding for possible and/ potential DOM based XSS vulnerability in a fast manner.

<img src="https://user-images.githubusercontent.com/25837540/95422191-0c72d380-0969-11eb-8119-3c6f00945674.png" alt="findom-xss" width="750">

---

### Installation

```
$ git clone https://github.com/dwisiswant0/findom-xss.git
```

**Dependencies:** [LinkFinder](https://github.com/GerbenJavado/LinkFinder)

### Usage

To run the tool on a target, just use the following command.
```
$ ./findom-xss.sh https://target.host/about-us.html
```

This will run the tool against `target.host`.


URLs can also be piped to findom-xss and scan on them. For example:
```
$ cat urls.txt | ./findom-xss.sh
```

The second argument can be used to specify an output file.
```
$ ./findom-xss.sh https://target.host/about-us.html /path/to/output.txt
```

By default, output will be stored in the `results/` directory in the repository with `target.host.txt` name.

### License

**FinDOM-XSS** is licensed under the Apache. Take a look at the [LICENSE](https://github.com/dwisiswant0/findom-xss/blob/master/LICENSE) for more information.

### Thanks

- [@dark_warlord14](https://twitter.com/dark_warlord14) - Inspired by the JSScanner tool, that's why this tool was made.
- [@aslanewre](https://twitter.com/aslanewre) - With possible patterns.
- [All Contributors](../../graphs/contributors)
