# FinDOM-XSS

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/dwisiswanto/findom-xss/issues)


FinDOM-XSS is a tool that allows you to finding for possible and/ potential DOM based XSS vulnerability in a fast manner.

<img src="https://user-images.githubusercontent.com/25837540/79048310-7888af00-7c46-11ea-9133-5063cbd3580d.png" alt="findom-xss" width="750">

---

### Installation

```
$ git clone git@github.com:dwisiswant0/findom-xss.git
```

**Dependencies:** [LinkFinder](https://github.com/GerbenJavado/LinkFinder)

### Configuration

Change the value of `LINKFINDER` variable _[(on line 3)](https://github.com/dwisiswant0/findom-xss/blob/master/findom-xss.sh#L3)_ with your main LinkFinder file.

### Usage

To run the tool on a target, just use the following command.
```
$ ./findom-xss.sh https://target.host/about-us.html
```

This will run the tool against `target.host`. Or if you have a list of targets you want to scan.

```
$ cat urls.txt | xargs -I % ./findom-xss.sh %
```

The second argument can be used to specify an output file.
```
$ ./findom-xss.sh https://target.host/about-us.html /path/to/output.txt
```

By default, output will be stored in the `results/` directory in the repository with `target.host.txt` name.

### License

**FinDOM-XSS** is licensed under the Apache. Take a look at the [LICENSE](https://github.com/dwisiswant0/findom-xss/blob/master/LICENSE) for more information.
