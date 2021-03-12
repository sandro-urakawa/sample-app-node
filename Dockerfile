FROM node:15.11.0-alpine3.13
USER node
EXPOSE 8080
COPY app.js /home/node
CMD ["node","/home/node/app.js"]
