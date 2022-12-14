# :whale: Containers 101 - Workshop

The goal of this workshop is to provide a basic understanding of containers.  
We will be using a ASP.NET Core 6.0 sample application provided by Microsoft.


## Requirements

- .NET SDK 6.0
- Git
- Rancher Desktop
 
Offical rancher documentation:  
https://docs.rancherdesktop.io/getting-started/installation



## Get started

Clone the following repository:  
```bash
$ git clone https://github.com/Nmbrs/containers-101-workshop.git
```

### Run the application `without` Docker:
```bash
$ cd containers-101-workshop/aspnetapp
$ dotnet publish -c Release -o published
$ dotnet published/aspnetapp.dll
```
We can then check the application there: http://localhost:5000



### Run the application with Docker using published data

```bash
$ cd containers-101-workshop
$ docker build -t nmbrs/aspnetapp:0.1.0 .
$ docker run -it --rm -p 5001:80 --name aspnetapp nmbrs/aspnetapp:0.1.0
```
We can then check the application there: http://localhost:5001

***Dockerfile***
```Dockerfile
# This base image contains the ASP.NET Core and .NET runtimes and libraries
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Define a working directory where you store your application files
WORKDIR /app

# Copy local files previously generated inside your working directory
COPY aspnetapp/published/ ./

# Command run when the container is initiated
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
```

### Build and run the application only using Docker

```bash
$ cd containers-101-workshop
$ docker build -f Dockerfile-multistage -t nmbrs/aspnetapp:0.2.0 .
$ docker run -it --rm -p 5001:80 --name aspnetapp-multistage nmbrs/aspnetapp:0.2.0
```
We can then check the application there: http://localhost:5001

***Dockerfile with Multistage Builds***
```Dockerfile
# Stage 1
# This base image contains the .NET CLI, .NET runtime, ASP.NET Core 
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Define a working directory where you store files during the build process
WORKDIR /source

# Copy csproj and restore as distinct layers (caching)
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# Copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app --no-restore

# Stage 2
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
```



### Docker commands

Docker `build` context:
- the `-t` flag is there to tag your docker image.

Docker `run` context:

- The `-it` flag tells docker that it should open an interactive container instance.
- The `--rm` flag tells docker that the container should automatically be removed after we exit docker.
- The `-p` flag specifies which port we want to make available for docker (*external_port*:*internal_port*).  
The port on the left side is the local port and on the right side the port your docker application listen to.
