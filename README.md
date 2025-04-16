# Optimizely Alloy on Docker

```sh
docker compose up --build 
```
Browse to http://localhost:4747 , set up an admin account and you are off to the races!

# script.sh
Controls the cms application creation process
You can modify the SQL Server wait (in seconds) on Line 7 with 10 seconds being the default

# docker-compose.yml

- SQL Server
- CMS Application