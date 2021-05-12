FROM gitlab/gitlab-runner:v13.11.0

ADD entrypoint /
RUN chmod +x /entrypoint
