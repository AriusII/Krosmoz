using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Krosmoz.Servers.AuthServer.Database.Migrations
{
    /// <inheritdoc />
    public partial class Accounts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "accounts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Username = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Password = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Hierarchy = table.Column<int>(type: "int", nullable: false),
                    Language = table.Column<int>(type: "int", nullable: false),
                    SecretQuestion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SecretAnswer = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    SubscriptionExpireAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Nickname = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    MacAddress = table.Column<string>(type: "nvarchar(20)", nullable: true),
                    IpAddress = table.Column<string>(type: "nvarchar(45)", nullable: true),
                    Ticket = table.Column<string>(type: "nvarchar(450)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_accounts", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "servers_characters",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ServerId = table.Column<int>(type: "int", nullable: false),
                    AccountId = table.Column<int>(type: "int", nullable: false),
                    CharacterId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_servers_characters", x => x.Id);
                    table.ForeignKey(
                        name: "FK_servers_characters_accounts_AccountId",
                        column: x => x.AccountId,
                        principalTable: "accounts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "accounts",
                columns: new[] { "Id", "CreatedAt", "Hierarchy", "IpAddress", "Language", "MacAddress", "Nickname", "Password", "SecretAnswer", "SecretQuestion", "SubscriptionExpireAt", "Ticket", "UpdatedAt", "Username" },
                values: new object[] { 1, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 40, null, 0, null, null, "21232f297a57a5a743894a0e4a801fc3", "blue", "What is your favorite color?", null, null, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "admin" });

            migrationBuilder.CreateIndex(
                name: "IX_accounts_Nickname",
                table: "accounts",
                column: "Nickname",
                unique: true,
                filter: "[Nickname] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_accounts_Ticket",
                table: "accounts",
                column: "Ticket",
                unique: true,
                filter: "[Ticket] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_accounts_Username",
                table: "accounts",
                column: "Username",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_servers_characters_AccountId",
                table: "servers_characters",
                column: "AccountId");

            migrationBuilder.CreateIndex(
                name: "IX_servers_characters_ServerId",
                table: "servers_characters",
                column: "ServerId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "servers_characters");

            migrationBuilder.DropTable(
                name: "accounts");
        }
    }
}
