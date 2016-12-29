# Removes 'Battle' preset data.

rm -f lib/Battle/BattleCommand/Attack/kick.rb
rm -f lib/Battle/BattleCommand/Attack/smash.rb

# Removes 'Entity' preset data.

rm -f lib/Entity/Monster/alien.rb

# Removes 'Event' preset data.

rm -f lib/Event/box.rb
rm -f lib/Event/hole.rb
rm -f lib/Event/NPC/dan.rb
rm -f lib/Event/Shop/bakery.rb
rm -f lib/Event/Shop/wacky_clothes.rb

# Removes 'Item' preset data.

rm -f lib/Item/shovel.rb
rm -f lib/Item/Food/donut.rb
rm -f lib/Item/Equippable/Helmet/bucket.rb
rm -f lib/Item/Equippable/Legs/ripped_pants.rb
rm -f lib/Item/Equippable/Shield/riot_shield.rb
rm -f lib/Item/Equippable/Torso/parka.rb
rm -f lib/Item/Equippable/Weapon/baguette.rb

# Removes 'Map' preset data.

rm -f lib/Map/Map/donut_field.rb
rm -f lib/Map/Tile/dirt.rb
rm -f lib/Map/Tile/wall.rb

# Removes 'Story' preset data.

rm -f lib/Story/introduction.rb

# Removes content references in 'main.rb'.

sed -i '/Battle/d' lib/main.rb
sed -i '/Map/d' lib/main.rb
sed -i '/introduction/d' lib/main.rb
sed -i '/name/d' lib/main.rb
sed -i '/max_hp/d' lib/main.rb
sed -i '/attack/d' lib/main.rb
sed -i '/battle/d' lib/main.rb
sed -i '/agility/d' lib/main.rb
sed -i '/map/d' lib/main.rb
sed -i '/location/d' lib/main.rb
