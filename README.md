# docker-nutanix-cli-tools
Dockerfile to build a container image with your favourite Nutanix Command-Line Interface Tools

## Dependencies
- Internet
- Docker CE or EE
- Nutanix favourite CLI tools

## Cloning the repo
Clone this repo and move into the directory
```bash
$ git clone https://github.com/pipoe2h/docker-nutanix-cli-tools.git
$ cd docker-nutanix-cli-tools
```

## Downloading the CLI tools
This Dockerfile has been developed to use the following CLI tools (all the CLI tools must be saved into the tools directory):
- **nCLI (Nutanix CLI)**. Download the **ncli.zip** file from Prism.
- **aCLI (Acropolis CLI)**. You can get this tool using SFTP/SCP (nutanix@<CVM_IP_ADDRESS>:/usr/local/nutanix/bin/acli). aCLI requires the **mincli** tool. Please copy both tools (nutanix@<CVM_IP_ADDRESS>:/usr/local/nutanix/bin/mincli)
- **NuCLEI (Nutanix CLI for Expression of Intents)**. You can get this tool using SFTP/SCP (nutanix@<CVM_IP_ADDRESS>:/usr/local/nutanix/bin/nuclei).

```bash
$ ls tools
acli     mincli   ncli.zip nuclei
```

## Building the Docker image
To build the image run the following command within the repo directory. I have used the tag latest, feel free to use your own tagging.

```bash
$ docker build . -t docker-nutanix-cli-tools:latest
```

## Testing the image
To test this image you need access to a CVM.

Also, this image uses variables to pass the required values:
- NTNX_IP (CVM or cluster IP)
- NTNX_USERNAME (UI username)
- NTNX_PASSWORD (UI password)

Finally you must choose as a command what Nutanix CLI tool you want to use. Currently the available choices are:
- ncli
- acli
- nuclei

**Note:** If you would like to have more Nutanix CLI tools included on this Dockerfile, please open an issue in GitHub and I'll take a look.

### nCLI
```bash
$ docker run -it --rm -e NTNX_IP=192.168.1.1 -e NTNX_USERNAME=admin -e NTNX_PASSWORD=admin docker-nutanix-cli-tools:latest ncli


Welcome, admin
You're now connected to 00000afa-0b00-0a0e-000c-0000000000a0 (JoseGomez.io) at 192.168.1.1
```

### aCLI
```bash
$ docker run -it --rm -e NTNX_IP=192.168.1.1 -e NTNX_USERNAME=admin -e NTNX_PASSWORD=admin docker-nutanix-cli-tools:latest acli

<acropolis>
```

### NuCLEI
```bash
$ docker run -it --rm -e NTNX_IP=192.168.1.1 -e NTNX_USERNAME=admin -e NTNX_PASSWORD=admin docker-nutanix-cli-tools:latest nuclei

<nuclei>
```

The arguments used are:
- -it (Interactive + Allocate a pseudo-TTY)
- --rm (Automatically remove the container when it exits)
- -e (Set environment variables)
- ncli/acli/nuclei (tool to run)

## Recommendations
Create a dedicated folder where you can save the credentials for each of your Nutanix clusters on its own file. This example shows a single cluster (*cluster1*), but you can repeat the same steps for multiple clusters. Also, remember to set the permissions of your credential files to 600 so only you have read/write access.

```bash
$ mkdir credentials
$ cd credentials
$ cat <<EOF> cluster1
NTNX_IP=192.168.1.1
NTNX_USERNAME=admin
NTNX_PASSWORD=admin
EOF
$ chmod 600 cluster1
```

Now you can run a new container and pass the variables as a file.
```bash
$ docker run -it --rm --env-file cluster1 docker-nutanix-cli-tools:latest <ncli/acli/nuclei>
```

**Disclaimer:** Containerised Nutanix CLI tools are not officially supported by Nutanix. Please use at your own risk.