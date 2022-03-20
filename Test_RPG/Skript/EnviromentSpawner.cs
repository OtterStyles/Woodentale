using Godot;

public class EnviromentSpawner : YSort
{

    [Export()] public PackedScene spawnScene = ResourceLoader.Load<PackedScene>("res://PreFab/Enviroment/Grass.tscn");
    [Export()] public int offsetX = 0;
    [Export()] public int offsetY = 0;
    private TileMap _tileMap = null;
    public override void _Ready()
    {
        _tileMap = GetNode<TileMap>("TileMap");
        _tileMap.Visible = false;
        foreach (Vector2 ob in _tileMap.GetUsedCells())
        {
            var scene = spawnScene.Instance<Node2D>();
            var pos = _tileMap.MapToWorld(ob);
            scene.GlobalPosition = new Vector2(pos.x + offsetX, pos.y + offsetY);
            AddChild(scene);
            
        }
    }
}
