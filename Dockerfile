FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY ./website/index.html /usr/share/nginx/html/index.html
COPY ./website/script.js /usr/share/nginx/html/script.js
COPY ./website/style.css /usr/share/nginx/html/style.css

EXPOSE 80