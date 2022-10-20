# neofs-s3-dev-env

Extension for https://github.com/nspcc-dev/neofs-dev-env to compare s3 compatible object storages: NeoFS S3 GW and minio. 

## Prerequisites

Ensure you have the following software installed:
* docker-compose 
* docker
* make 
* git
* jq 
* python3.6 -- quick tutorials for some distros see [here](https://github.com/nspcc-dev/s3-tests/blob/master/NEOFS_README.md)

## Quick Start

### NeoFS S3 GW

Make sure that `neofs-dev-env` is started with zero fees. To set zero fees, go to folder of `neofs-dev-env` and execute:
```bash
$ make update.container_fee val=0 && make update.container_alias_fee val=0
```
Then inside a folder `neofs-s3-dev-env` run the tests:
```bash
$ make tests.s3-gw
```

You can set a variable `TEST` and specify a file which you want to run tests from:
```bash
$ make tests.s3-gw TEST=test_s3 
```
Or specify a test: 
```bash
$ make tests.s3-gw TEST=test_s3:test_object_copy_versioned_bucket          
```

After execution, you can find results in `s3-gw.results`:
```shell
$ cat s3-gw.results
...
s3tests_boto3.functional.test_s3.test_object_copy_versioned_bucket ... ok
...
```

### Other services

Supported services:
* minio

To start services execute:
```bash
$ make up
```

### Minio

To run testing of minio:
```bash
$ make tests.minio
```

After execution, you can find results in `minio.results`:
```shell
$ cat minio.results
...
s3tests_boto3.functional.test_s3.test_bucket_create_naming_bad_short_one ... ok
...
```

## Notable make targets

`make help` will print the brief description of available targets. Here we
describe some of them in a more detailed way.

### prepare.tests

Clones repository [nspcc-dev/s3-test](https://github.com/nspcc-dev/s3-tests), creates isolated Python environment using `virtualenv` in subdirectory `tests`. 

### prepare.s3-gw

Issues secrets for two wallets with [authmate](https://github.com/nspcc-dev/neofs-s3-gw/blob/master/docs/authmate.md) and creates a `.conf` file with filled credentials for `s3-tests`.

### tests.s3-gw

Runs tests on S3-GW from `neofs-dev-env`.

### prepare.minio

Creates a `.conf` file with filled credentials for `s3-tests`.

### tests.minio 

Runs tests on minio.

### up

Starts all Devenv services.

This target call `pull` to get container images, `get` to download required
artifacts, `vendor/hosts` to generate hosts file and then starts all services in the order defined in `.services` file.

### down

Shutdowns all services. This will destroy all containers and networks. All
changes made inside containers will be lost.

### clean

Clean up `vendor` and `tests` directories and created `.conf` files.



# License

- [GNU General Public License v3.0](LICENSE)
