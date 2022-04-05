using Godot;
using System;

public class EnviromentSpawner : YSort
{

	[Export()] public PackedScene spawnScene = ResourceLoader.Load<PackedScene>("res://PreFab/Enviroment/Grass.tscn");
	[Export(PropertyHint.Range, "0,100,")] public int Percentage = 50;
	private TileMap _tileMap = null;
	public override void _Ready()
	{
		_tileMap = GetNode<TileMap>("TileMap");
		_tileMap.Visible = false;
		foreach (Vector2 ob in _tileMap.GetUsedCells())
		{
			if (new Random().Next(100) < Percentage)
			{
				var scene = spawnScene.Instance<Node2D>();
				var pos = _tileMap.MapToWorld(ob);
				scene.GlobalPosition = new Vector2(pos.x + 64, pos.y + 64);
				AddChild(scene);
			}
			
		}
	}
}

