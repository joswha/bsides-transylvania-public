FROM ubuntu:23.04 as builder

# Non inreractive
ENV DEBIAN_FRONTEND=noninteractive

# Update stuff to latest
RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y zsh
RUN apt-get install -y git

RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
RUN chmod +x install.sh
RUN ./install.sh --unattended
RUN rm install.sh

# Install foundry
RUN curl -L https://foundry.paradigm.xyz | bash
RUN echo "export PATH=\$PATH:/root/.foundry/bin" >> ~/.zshrc
RUN /root/.foundry/bin/foundryup

WORKDIR /workshop

FROM scratch
COPY --from=builder / /

WORKDIR /workshop

CMD [ "zsh" ]