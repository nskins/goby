## Tile Class

So let's start with the basics. The first thing you are going to need when building
your game is a map. In Goby, a map is composed of several Tiles (instances of the
Tile class), so it is important to first understand how a Tile works.

When initializing a new Tile, it is possible to simply call `Tile.new` without any
arguments. Doing so will create a instance of Tile that has the following basic
default attributes:

- It will be passable (@passable === true)
- It won't be seen (@seen === false)
- It will have a blank description (@description === "")
- It will have no events (@events === [])
- It will have no monsters (@monsters === [])
- It will use the default graphic (@graphic === ".")

Also, it is important to note that the Tile class has an instance method called
`clone`. I'll go into the details of this method later, but for now just remember
that it is a method within this class.

Many of these attributes mean nothing now, and we will get to them, but let's focus
on the simplest way in which we can extend this class. The defaults of the Tile class
can be thought of as representing unremarkable blank space on your map. But what if
we wanted to create a grassy meadow? That is where extending the `Goby::Tile` class
comes in. Here is a small example:

```
class Grass < Goby::Tile
  def initialize(passable: true, seen: false, description: "", events: [], monsters: [])
    super(passable, seen, description, events, monsters)
    @graphic = default_graphic
  end

  private

  def default_graphic
    return "ǂ"
  end
end
```

Here, we extend the `Goby::Tile` class, and replace the behavior of the
`#default_graphic` method, so that it returns a different unicode symbol. We also
make a change to the constructor so that `@graphic` is set to the unicode symbol
returned from the invocation of `#default_graphic`. Now, when we instantiate an
object of type `Grass`, and include it into our map, that tile will be represented by
the `ǂ` character. This will provide a bit more visual context to the player of where
they are on the map.

So now let's say we want to customize this Grass tile a bit further by creating a
grass tile that is not passable. We could create a new class called something like
`BlockedGrass`, or we could further customize our existing `Grass` class. Let's go
with the latter for now.

```
class Grass < Goby::Tile
  def initialize(passable: true, seen: false, description: "", events: [], monsters: [])
    super(passable, seen, description, events, monsters)
    @graphic = set_graphic(passable)
  end

  private

  def default_graphic
    return "ǂ"
  end

  def set_graphic(passable)
    passable ? default_graphic : "¥"
  end
end
```

So here what we've done is added another private method called `#set_graphic`.
This method is responsible for setting the `@graphic` property of the `Grass`
instance. When an instance is created that is passable, the "ǂ" character will
represent that tile, but when an instance is created that is not passable, the "¥"
character will be displayed instead.

## Map Class

So now we arrive at the point in which we want to assemble our tiles into something
cohesive. This is the responsibility of the `Map` class. The `Map` class is quite
simple, with just 3 properties and 3 methods. The properties are:

- name (defaults to "Map")
- tiles (defaults to [[Tile.new]])
- music (defaults to nil)

For now, we will ignore these methods as they aren't something that you will be
actively working with at this point.

Now that we know the properties of the `Map` class, we are ready to start
constructing our own maps. Let's start by creating a map called `Meadow`.

```
class Meadow < Map
  def initialize
    super(name: "Open Meadow")

    # Define the main tiles on this map.
    grass = Grass.new(description: "You are standing on some grass.")
    blocked_grass = Grass.new(passable: false)

    # Fill the map with "grass."
    @tiles = Array.new(9)

    normal_row = [grass.clone, grass.clone, grass.clone, grass.clone, grass.clone]
    blocked_row = [grass.clone, blocked_grass.clone, blocked_grass.clone, blocked_grass.clone, grass.clone]

    @tiles[0] = normal_row
    @tiles[1] = normal_row
    @tiles[2] = normal_row
    @tiles[3] = blocked_row
    @tiles[4] = blocked_row
    @tiles[5] = blocked_row
    @tiles[6] = normal_row
    @tiles[7] = normal_row
    @tiles[8] = normal_row

  end
end
```

When we create an instance of `Meadow`, what we end up with is a map that has
passable grass on its borders, and blocked grass in the middle, as a result of
adding tiles to the `@tiles` property in a specific order.

You'll notice that I am calling the `clone` method that I mentioned earlier when
describing the Tile class. This is very important with regards to constructing
a map that behaves the way you would expect. If I had build my `normal_row` and
`blocked_row` arrays as such:

```
grass = Grass.new(description: "You are standing on some grass.")
blocked_grass = Grass.new(passable: false)

normal_row = [grass, grass, grass, grass, grass]
blocked_row = [grass, blocked_grass, blocked_grass, blocked_grass, grass]
```

I would have run into issues because each `grass` and `blocked_grass` variable
would have been a reference to the same object. If that referenced object were
to change in any way, all references to that object would reflect those changes.
A practical way to think about this is if the original Tile object had a monster
in its monsters property, then every tile in the map that referenced that
original Tile object would have a monster as well. Then, if a player engaged
in battle with that monster and defeated it, the monster would be removed from
not only the Tile the user was on, but also every other Tile that referenced the
original.

The short version? Be sure to clone any Tiles that you wish to reuse and you'll
get the behavior you expect.
