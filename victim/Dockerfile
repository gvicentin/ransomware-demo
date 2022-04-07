FROM ubuntu:20.04

# create user for demo
RUN useradd -ms /bin/bash victim

# installing complement packages
RUN apt update 
RUN apt install -y curl
RUN apt install -y gpg

# using new user
USER victim
WORKDIR /home/victim

# don't exit
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
