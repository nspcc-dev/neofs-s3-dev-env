# neofs-s3-tests
Extension for https://github.com/nspcc-dev/neofs-dev-env to compare s3 compatible object storages

## How it's organized

Main commands and targets to manage devenv's services are in `Makefile`.

Each service is defined in it's own directory under `services/` with all
required files to run and scripts to get external artifacts or dependencies.

The list of services and the starting order is defined in `.services` file. You
can comment out services you don't want to start or add your own new services.

## Get started

### Prerequisites
Ensure you have the following software installed:
* python-virtualenv
* docker-compose 
* docker
* make 
* git

To run tests on minio storage run:

```
$ make up
Pulling minio ... done
Pulling mc    ... done
Creating minio ... done
Creating mc    ... done

$ make tests.minio
Forming s3tests.conf
Preparing s3-tests
Tests are already downloaded. Nothing to do
Run s3tests_boto3.functional tests
s3tests_boto3.functional.test_headers.test_object_create_bad_md5_invalid_short ... ok
s3tests_boto3.functional.test_headers.test_object_create_bad_md5_bad ... ok
s3tests_boto3.functional.test_headers.test_object_create_bad_md5_empty ... ok
...
s3tests_boto3.functional.test_headers.test_object_create_bad_md5_none ... ok
```

## Notable make targets

`make help` will print the brief description of available targets. Here we
describe some of them in a more detailed way.

### up

Start all Devenv services.

This target call `pull` to get container images, `get` to download required
artifacts, `vendor/hosts` to generate hosts file and then starts all services in
the order defined in `.services` file.

### prepare.tests

Downloads compatibility tests and forming configuration files for services.

### tests.minio

Run compatibility tests on minio storage.

### down

Shutdowns all services. This will destroy all containers and networks. All
changes made inside containers will be lost.

### clean

Clean up `vendor` and `tests` directories.

# License

- [GNU General Public License v3.0](LICENSE)
