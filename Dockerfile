FROM microsoft/aspnetcore-build-nightly:2.1.300-preview1 AS base
WORKDIR /app
#EXPOSE 28200:80
#EXPOSE 44347:443

FROM base AS build
WORKDIR /src
COPY *.sln ./
COPY razortest.csproj ./
RUN dotnet restore
COPY . .
WORKDIR /src/
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "razortest.dll"]
