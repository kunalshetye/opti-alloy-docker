FROM node:alpine3.20
RUN apk add dotnet6-runtime dotnet8-sdk wget yq
EXPOSE 5000
COPY --chmod=777 scripts/startup.sh /startup.sh
WORKDIR /app
USER 1000
CMD ["sh", "-c", "/startup.sh"]