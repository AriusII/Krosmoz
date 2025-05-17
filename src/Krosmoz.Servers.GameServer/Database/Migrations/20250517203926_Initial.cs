using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Krosmoz.Servers.GameServer.Database.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
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
                    ElementId = table.Column<int>(type: "integer", nullable: false),
                    MapsData = table.Column<byte[]>(type: "bytea", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_interactives", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "maps",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    X = table.Column<int>(type: "integer", nullable: false),
                    Y = table.Column<int>(type: "integer", nullable: false),
                    Outdoor = table.Column<bool>(type: "boolean", nullable: false),
                    Capabilities = table.Column<int>(type: "integer", nullable: false),
                    SubAreaId = table.Column<int>(type: "integer", nullable: false),
                    WorldMap = table.Column<int>(type: "integer", nullable: false),
                    HasPriorityOnWorldMap = table.Column<bool>(type: "boolean", nullable: false),
                    PrismAllowed = table.Column<bool>(type: "boolean", nullable: false),
                    PvpDisabled = table.Column<bool>(type: "boolean", nullable: false),
                    PlacementGenDisabled = table.Column<bool>(type: "boolean", nullable: false),
                    MerchantsMax = table.Column<int>(type: "integer", nullable: false),
                    SpawnDisabled = table.Column<bool>(type: "boolean", nullable: false),
                    RedCells = table.Column<short[]>(type: "smallint[]", nullable: false),
                    BlueCells = table.Column<short[]>(type: "smallint[]", nullable: false),
                    Cells = table.Column<byte[]>(type: "bytea", nullable: false),
                    TopNeighborId = table.Column<int>(type: "integer", nullable: false),
                    BottomNeighborId = table.Column<int>(type: "integer", nullable: false),
                    LeftNeighborId = table.Column<int>(type: "integer", nullable: false),
                    RightNeighborId = table.Column<int>(type: "integer", nullable: false),
                    TopCellId = table.Column<short>(type: "smallint", nullable: true),
                    BottomCellId = table.Column<short>(type: "smallint", nullable: true),
                    LeftCellId = table.Column<short>(type: "smallint", nullable: true),
                    RightCellId = table.Column<short>(type: "smallint", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_maps", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "interactives");

            migrationBuilder.DropTable(
                name: "maps");
        }
    }
}
