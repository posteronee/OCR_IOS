FROM swift:5.3

WORKDIR /app

COPY . .

RUN swift package resolve

CMD ["swift", "run"]
