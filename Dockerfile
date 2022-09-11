FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev libpng-dev gtk-doc-tools
RUN  git clone https://github.com/davisking/dlib.git
WORKDIR /dlib
RUN mkdir ./build
WORKDIR /dlib/build
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ ..
RUN make
RUN make install
COPY fuzzers/fuzz.cpp .
RUN afl-clang++ -I/usr/local/include fuzz.cpp -o /xml_fuzz /usr/local/lib/libdlib.a
RUN mkdir /dlibXmlCorpus
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/test.xml
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/mozilla/107518-1.xml
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/mozilla/1_original.xml
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/mozilla/226425.xml
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/mozilla/2_result_1.xml
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/mozilla/323737-1.xml
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/mozilla/323738-1.xml
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xml/mozilla/342954-2-xbl.xml
RUN cp *.xml /dlibXmlCorus

ENTRYPOINT ["afl-fuzz", "-i", "/dlibXmlCorpus", "-o", "/dlibOut"]
CMD  ["/xml_fuzz", "@@"]
