using Godot;
using System;

public class BasicItem : Node2D
{
	[Export]
	public Item _item;
	
	public override void _Ready(){
		
	}
	
	public struct Item
	{
		[Export]
		public int ID;
		[Export]
		public string NAME;
		[Export]
		public Texture texture;
	}
	
}

