# MySQL with data
MySQL with data

## Requirements
It requires the following apps installed:
- docker
- docker-compose
- make
- mysql client

## Make file
| CMD             | ACTION                                                     |
|-----------------|------------------------------------------------------------|
|`make help`      | shows all available targets                                |
|`make run`       | runs mysql server (if you want data run `make build` first |
|`make data_load` | starts mysql, loads data and stops mysql                   |
|`make test`      | run tests                                                  |
|`make clear`     | stops mysql and clears data                                |

