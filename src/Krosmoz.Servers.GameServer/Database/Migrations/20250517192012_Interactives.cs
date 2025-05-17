using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Krosmoz.Servers.GameServer.Database.Migrations
{
    /// <inheritdoc />
    public partial class Interactives : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "interactives",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    GfxId = table.Column<int>(type: "integer", nullable: false),
                    Animated = table.Column<bool>(type: "boolean", nullable: false),
                    MapId = table.Column<int>(type: "integer", nullable: false),
                    ElementId = table.Column<int>(type: "integer", nullable: true),
                    MapsData = table.Column<long[]>(type: "bigint[]", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_interactives", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "interactives");
        }
    }
}
