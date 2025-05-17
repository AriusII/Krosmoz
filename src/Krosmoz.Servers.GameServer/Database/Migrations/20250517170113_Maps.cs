using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Krosmoz.Servers.GameServer.Database.Migrations
{
    /// <inheritdoc />
    public partial class Maps : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "maps",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    X = table.Column<int>(type: "int", nullable: false),
                    Y = table.Column<int>(type: "int", nullable: false),
                    Outdoor = table.Column<bool>(type: "bit", nullable: false),
                    Capabilities = table.Column<int>(type: "int", nullable: false),
                    SubAreaId = table.Column<int>(type: "int", nullable: false),
                    WorldMap = table.Column<int>(type: "int", nullable: false),
                    HasPriorityOnWorldMap = table.Column<bool>(type: "bit", nullable: false),
                    PrismAllowed = table.Column<bool>(type: "bit", nullable: false),
                    PvpDisabled = table.Column<bool>(type: "bit", nullable: false),
                    PlacementGenDisabled = table.Column<bool>(type: "bit", nullable: false),
                    MerchantsMax = table.Column<int>(type: "int", nullable: false),
                    SpawnDisabled = table.Column<int>(type: "int", nullable: false),
                    RedCells = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    BlueCells = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Cells = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TopNeighborId = table.Column<int>(type: "int", nullable: false),
                    BottomNeighborId = table.Column<int>(type: "int", nullable: false),
                    LeftNeighborId = table.Column<int>(type: "int", nullable: false),
                    RightNeighborId = table.Column<int>(type: "int", nullable: false),
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
                name: "maps");
        }
    }
}
