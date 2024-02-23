FROM mycomicslibrary_base
RUN apt-get update && apt-get install -y python3.9
RUN apt-get update && apt-get install -y python3-pip
RUN pip install pillow
RUN apt-get install libzbar-dev -y
RUN pip install pyzbar
RUN pip install zbar-py
COPY renv.lock.prod renv.lock
RUN R -e 'renv::restore()'
COPY mycomicslibrary_*.tar.gz /app.tar.gz
RUN R -e 'remotes::install_local("/app.tar.gz",upgrade="never")'
RUN rm /app.tar.gz
RUN mkdir storage
RUN mkdir storage/db
RUN mkdir storage/covers
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');options(golem.app.prod = TRUE);Sys.setenv('COMICS_SQL_PATH'='storage/db/db.sqlite');Sys.setenv('COVERS_PATH'='storage/covers/');library(mycomicslibrary);mycomicslibrary::run_app()"


# mv /home/yohann/Documents/perso/mycomicslibrary_0.0.0.9000.tar.gz deploy/