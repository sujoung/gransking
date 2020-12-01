FROM ubuntu:12.04
RUN mkdir /app
RUN apt-get update
RUN apt-get install -y sudo
RUN apt-get install -y apt-utils
RUN apt-get dist-upgrade
RUN apt-get -y install dialog
RUN apt-get install locales
RUN locale-gen sv_SE
ENV LC_ALL=sv_SE.iso88591

WORKDIR /app
RUN sudo apt-get install -y build-essential \
                          g++ \
                          xutils-dev \
                          flex \
                          bison \
                          libxerces-c-dev

ADD . /app

WORKDIR /app/granska/scrutinizer

RUN make
RUN sudo make install

ENV LD_LIBRARY_PATH $PWD:$LD_LIBRARY_PATH
RUN echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
ENV GRANSKA_HOME $PWD/..
RUN echo "GRANSKA_HOME = $GRANSKA_HOME"
ENV TAGGER_LEXICON $GRANSKA_HOME/lex
ENV DEVELOPERS_TAGGER_LEXICON $GRANSKA_HOME/lex
RUN echo "TAGGER_LEXICON = $TAGGER_LEXICON"
ENV STAVA_LEXICON $GRANSKA_HOME/stava/lib/
RUN echo "STAVA_LEXICON = $STAVA_LEXICON"
ENV SCRUTINIZER_RULE_FILE $GRANSKA_HOME/rulesets/wille/regelsamling.ver8
RUN echo "SCRUTINIZER_RULE_FILE = $SCRUTINIZER_RULE_FILE"
ENV SCRUTINIZER_TEST_TEXT $GRANSKA_HOME/rulesets/wille/regelsamling.ver8.testfil
ENV DEVELOPERS_TAGGER_OPT_TEXT $GRANSKA_HOME/rulesets/wille/regelsamling.ver8.testfil
RUN echo "SCRUTINIZER_TEST_TEXT = $SCRUTINIZER_TEST_TEXT"
RUN echo "Done"
ENV TAGGER_LEXICON /app/granska/scrutinizer/../lex
ENV SCRUTINIZER_RULE_FILE /app/granska/scrutinizer/../rulesets/wille/regelsamling.ver8
ENV LD_LIBRARY_PATH /app/granska/scrutinizer:
ENV SCRUTINIZER_TEST_TEXT /app/granska/scrutinizer/../rulesets/wille/regelsamling.ver8.testfil
ENV GRANSKA_HOME /app/granska/scrutinizer/..
ENV DEVELOPERS_TAGGER_LEXICON /app/granska/scrutinizer/../lex
ENV STAVA_LEXICON /app/granska/scrutinizer/../stava/lib/
ENV DEVELOPERS_TAGGER_OPT_TEXT /app/granska/scrutinizer/../rulesets/wille/regelsamling.ver8.testfil

RUN make test