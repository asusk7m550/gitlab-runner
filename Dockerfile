FROM gitlab/gitlab-runner:v12.2.0

ADD entrypoint /
RUN chmod +x /entrypoint
