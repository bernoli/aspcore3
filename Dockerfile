FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY web/*.csproj ./web/
RUN dotnet restore

# copy everything else and build app
COPY web/. ./web/
WORKDIR /app/web
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine AS runtime
WORKDIR /app
COPY --from=build /app/web/out ./
ENTRYPOINT ["dotnet", "web.dll"]
