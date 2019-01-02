FROM gitlab/gitlab-runner:latest

ADD entrypoint /
RUN chmod +x /entrypoint
