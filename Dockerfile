FROM node:16
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
RUN echo "pavithra"
COPY . .
EXPOSE 80
CMD [ "npm", "start" ]
