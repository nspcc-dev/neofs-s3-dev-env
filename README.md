# neofs-s3-tests
Extension for https://github.com/nspcc-dev/neofs-dev-env to compare s3 compatible object storages

## How it's organized

Main commands and targets to manage devenv's services are in `Makefile`.

Each service is defined in it's own directory under `services/` with all
required files to run and scripts to get external artifacts or dependencies.

The list of services and the starting order is defined in `.services` file. You
can comment out services you don't want to start or add your own new services.

## Notable make targets

`make help` will print the brief description of available targets. Here we
describe some of them in a more detailed way.

### up

Start all Devenv services.

This target call `pull` to get container images, `get` to download required
artifacts, `vendor/hosts` to generate hosts file and then starts all services in
the order defined in `.services` file.

### down

Shutdowns all services. This will destroy all containers and networks. All
changes made inside containers will be lost.

### hosts

Display addresses and host names for each running service, if available.

### clean

Clean up `vendor` directory.

# License

- [GNU General Public License v3.0](LICENSE)
