# terminator

Put terminator in front of your services to terminate SSL and redirect traffic from HTTP to HTTPS.

## How to use

Run the `ahaines/terminator` Docker image, providing the target service's address (`hostname:port`) as the `BACKEND_ADDRESS` environment variable.

For example, to proxy traffic to a service listening on port 8000 on the host (assuming you are running Docker for Mac or Docker for Windows):

```console
$ docker run \
    --detach \
    --env BACKEND_ADDRESS=host.docker.internal:8000 \
    --name terminator \
    --publish 80:80 \
    --publish 433:443 \
    --rm \
    ahaines/terminator
```

Your service is now available at https://localhost, and http://localhost will redirect to HTTPS.

## Certificates

terminator will generate a self-signed certificate at startup, unless a certificate is provided.

To provide a certificate, mount a certificate chain file into the container in concatenated PEM format – the certificate, followed by intermediate CA certificates (if any), followed by the private key, in a single file.

Tell terminator the path where you mounted the certificate chain file by setting the `CERTIFICATE_CHAIN_PATH` environment variable.

## Configuration

Configuration may be specified with the following environment variables:

| Variable | Default | Description |
| --- | --- | --- |
| `BACKEND_ADDRESS` | _required_ | The host and port to proxy HTTP traffic to.<br>e.g `my-backend.service:80` |
| `CERTIFICATE_COMMON_NAME` | `localhost` | The hostname to issue a self-signed certificate for. |
| `CERTIFICATE_CHAIN_PATH` | _none_ | The path to a certificate chain file to use instead of generating a self-signed certificate. |
