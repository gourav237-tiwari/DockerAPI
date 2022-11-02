#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
FROM ubuntu:22.04.1
RUN apt-get update && apt-get upgrade -y
RUN apt-get install libssl-dev

RUN apt-get install -y -q build-essential curl
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /command-agent
COPY ./src/. /command-agent/src/
COPY .env /command-agent/
COPY Cargo.toml /command-agent/
COPY Cargo.lock /command-agent/
RUN cargo build --release

EXPOSE 8080
ENTRYPOINT /command-agent/target/release/command-agent
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DockerWebAPI.csproj", "."]
RUN dotnet restore "./DockerWebAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DockerWebAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerWebAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerWebAPI.dll"]