# syntax=docker/dockerfile:1.4

# Create image based on the official Node image from dockerhub
FROM node:16-buster AS development

# Create app directory
WORKDIR /usr/src/HamBackend

# Copy dependency definitions
COPY package.json /usr/src/HamBackend
COPY package-lock.json /usr/src/HamBackend

# Install dependecies
#RUN npm set progress=false \
#    && npm config set depth 0 \
#    && npm i install
RUN npm i

# Get all the code needed to run the qzkraftfront
COPY . /usr/src/HamBackend

# Expose the port the app runs in
EXPOSE 8080

# Serve the app
CMD ["npm", "start"]

FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "start" ]
