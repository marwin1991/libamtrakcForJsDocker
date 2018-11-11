ARG EMSCRIPTEN_SDK=sdk-tag-1.38.18-64bit
FROM trzeci/emscripten:${EMSCRIPTEN_SDK}

WORKDIR /emsdk_portable/
RUN emsdk install latest
RUN emsdk activate latest

RUN apt-get update \
    && apt-get install -y git \ 
    && apt-get install -y wget

RUN wget "https://ftp.gnu.org/gnu/gsl/gsl-latest.tar.gz"
RUN mkdir /gsl-latest
RUN tar -xzvf gsl-latest.tar.gz -C /gsl-latest
RUN mv /gsl-latest/** /gsl-latest/gsl
WORKDIR /gsl-latest/gsl/
RUN /bin/bash -c "source /emsdk_portable/emsdk_env.sh && emconfigure ./configure"
RUN /bin/bash -c "source /emsdk_portable/emsdk_env.sh && emmake make"

WORKDIR /
RUN ls
RUN git clone "https://github.com/libamtrack/library.git"
WORKDIR /library
RUN git checkout forjs
RUN rm /library/js/libgsl.a
RUN rm /library/js/libgsl.so
RUN cp /gsl-latest/gsl/.libs/libgsl.a /library/js/
RUN cp /gsl-latest/gsl/.libs/libgsl.so /library/js/
WORKDIR /library
RUN chmod +x compile_to_js.sh
RUN /bin/bash -c "./compile_to_js.sh"

RUN cp /library/libat.js /
RUN cp /library/libat.wasm /

WORKDIR /
