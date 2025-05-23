using Projects;

var builder = DistributedApplication.CreateBuilder(args);

var postgresql = builder
    .AddPostgres("postgres")
    .WithDataVolume("postgres-data-volume");

var authDatabase = postgresql.AddDatabase("auth");
var gameDatabase = postgresql.AddDatabase("game");

/*
var databaseServer = builder.AddProject<Krosmoz_Tools_Database>("DatabaseServer")
    .WaitFor(authDatabase)
    .WaitFor(gameDatabase)
    .WithReference(authDatabase)
    .WithReference(gameDatabase);
*/

var authServer = builder.AddProject<Krosmoz_Servers_AuthServer>("AuthServer")
    .WaitFor(authDatabase)
    .WithReference(authDatabase);

var gameServer = builder.AddProject<Krosmoz_Servers_GameServer>("GameServer")
    .WaitFor(gameDatabase)
    .WithReference(gameDatabase);

builder.Build().Run();
