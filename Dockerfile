FROM trzeci/emscripten:sdk-tag-1.38.18-64bit

WORKDIR /

RUN apt-get update \
	&& apt-get install -y git \ 
	&& apt-get install -y wget \
	&& apt-get install -y libtool

RUN wget "https://ftp.gnu.org/gnu/gsl/gsl-latest.tar.gz"
RUN mkdir /gsl-latest
RUN tar -xzvf gsl-latest.tar.gz -C /gsl-latest
RUN mv /gsl-latest/** /gsl-latest/gsl
WORKDIR /
WORKDIR /gsl-latest/gsl/
RUN emconfigure ./configure 

WORKDIR /
RUN git clone "https://github.com/libamtrack/library.git"
WORKDIR /library
RUN git checkout forjs
RUN rm /library/js/libgsl.a
RUN rm /library/js/libgsl.so
RUN cp /gsl-latest/gsl/.libs/libgsl.a /library/js/
RUN cp /gsl-latest/gsl/.libs/libgsl.so /library/js/
WORKDIR /library
RUN ls
RUN chmod +x compile_to_js.sh
RUN bash compile_to_js.sh