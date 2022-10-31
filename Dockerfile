# This base image contains the ASP.NET Core and .NET runtimes and libraries
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Define a working directory where you store your application files
WORKDIR /app

# Copy local files previously generated inside your working directory
COPY aspnetapp/published/ ./

# Command run when the container is initiated
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
