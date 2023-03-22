FROM ruby:3.0.4

RUN apt update -qq && apt install -y vim

ARG deploy_to=sequra-assignment

RUN mkdir /${deploy_to}

WORKDIR /${deploy_to}
COPY Gemfile Gemfile.lock /${deploy_to}/

RUN bundle install
COPY . /${deploy_to}

EXPOSE 3000

CMD ["sh"]
