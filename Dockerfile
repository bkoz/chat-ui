# Build the chat-ui container
# FROM dokken/fedora-latest
FROM registry.fedoraproject.org/fedora:latest

USER 0

RUN dnf -y install nodejs nodejs20

ENV APP_ROOT=/opt/app-root
RUN mkdir -p ${APP_ROOT}/{bin,src} && \
    chmod -R u+x ${APP_ROOT}/bin && chgrp -R 0 ${APP_ROOT} && chmod -R g=u ${APP_ROOT}
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

WORKDIR ${APP_ROOT}/src
COPY . ${APP_ROOT}/src

RUN npm install

RUN chmod -R ug+rw ${APP_ROOT}/src

EXPOSE 5173
CMD npm run dev -- --host=0.0.0.0

