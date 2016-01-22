FROM debian:jessie
MAINTAINER orangain

ENV LANG en_US.UTF-8
ENV REVIEW_VERSION 1.7.2

# Setup and Install
#   * texlive-*: for LaTeX
#   * zip: for review-epubmaker
#   * curl & bzip2: for installing jlisting.sty
#   * ruby & ruby-pygments.rb: for review
#   * rake & git: for specific_install
#   * imagemagick: convert images
RUN apt-get update && \
	apt-get install -y locales && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen en_US.UTF-8 && \
	update-locale en_US.UTF-8 && \
	apt-get install -y \
		texlive-lang-cjk \
		texlive-fonts-recommended \
		zip \
		curl \
		bzip2 \
		ruby \
		ruby-pygments.rb \
		rake \
		git \
		imagemagick && \
	apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install jlisting.sty
RUN mkdir -p /usr/share/texlive/texmf-dist/tex/latex/jlisting && \
	curl http://iij.dl.sourceforge.jp/mytexpert/26068/jlisting.sty.bz2 | \
		bunzip2 > /usr/share/texlive/texmf-dist/tex/latex/jlisting/jlisting.sty && \
	mktexlsr

# Install review
RUN gem install review -v $REVIEW_VERSION

# Install kindlegen
ENV KINDLEGEN_VERSION=kindlegen_linux_2.6_i386_v2_9
RUN mkdir -p /tmp/kindlegen && \
	cd /tmp/kindlegen && \
	curl http://kindlegen.s3.amazonaws.com/${KINDLEGEN_VERSION}.tar.gz -o kindlegen.tar.gz && \
	tar xvf kindlegen.tar.gz && \
	chown root. kindlegen && \
	chmod 755 kindlegen && \
	mv kindlegen /usr/local/bin/ && \
	rm -rf /tmp/kindlegen

# Install node.js to use textlint
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
	apt-get install -y nodejs && \
	apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
