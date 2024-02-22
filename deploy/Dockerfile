FROM mycomicslibrary_base
COPY renv.lock.prod renv.lock
RUN R -e 'renv::restore()'
COPY mycomicslibrary_*.tar.gz /app.tar.gz
RUN R -e 'remotes::install_local("/app.tar.gz",upgrade="never")'
#RUN R -q -e 'reticulate::install_miniconda()'
#RUN R -q -e 'reticulate::conda_create(envname = "r-app")'
#RUN R -q -e 'reticulate::conda_install(envname = "r-app", packages = "pillow", pip = TRUE)'
#RUN R -q -e 'reticulate::conda_install(envname = "r-app", packages = "pyzbar", pip = TRUE)'
RUN R -q -e 'reticulate::install_python()'
RUN R -q -e 'reticulate::virtualenv_create("r-reticulate")'
# install SciPy
RUN R -q -e 'reticulate::virtualenv_install("r-reticulate", "pillow")'
RUN R -q -e 'reticulate::virtualenv_install("r-reticulate", "pyzbar")'
RUN rm /app.tar.gz
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');library(mycomicslibrary);mycomicslibrary::run_app()"
