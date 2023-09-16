FROM dokken/fedora-latest

# This image provides a Node.JS environment you can use to run your Node.JS
# applications.

EXPOSE 8080

USER 0

RUN dnf search nodejs
RUN dnf -y install nodejs

ENV APP_ROOT=/opt/app-root
RUN mkdir -p ${APP_ROOT}/{bin,src} && \
    chmod -R u+x ${APP_ROOT}/bin && chgrp -R 0 ${APP_ROOT} && chmod -R g=u ${APP_ROOT}
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

WORKDIR ${APP_ROOT}/src
COPY . ${APP_ROOT}/src

USER 1001

RUN npm install

VOLUME ${APP_ROOT}/logs ${APP_ROOT}/models

CMD npm run dev

