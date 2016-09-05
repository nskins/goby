# Removes 'Battle' preset data.

rm -f src/Battle/BattleCommand/escape.rb
rm -f src/Battle/BattleCommand/Attack/kick.rb
rm -f src/Battle/BattleCommand/Attack/smash.rb

# Removes 'Entity' preset data.

rm -f src/Entity/Monster/alien.rb

# Removes 'Event' preset data.

rm -f src/Event/box.rb
rm -f src/Event/Shop/bakery.rb

# Removes 'Item' preset data.

rm -f .src/Item/Food/donut.rb
rm -f src/Item/Equippable/Weapon/baguette.rb

# Removes 'Map' preset data.

rm -f src/Map/Map/donut_field.rb
rm -f src/Map/Tile/dirt.rb
rm -f src/Map/Tile/wall.rb

# Removes 'Story' preset data.

rm -f src/Story/introduction.rb

# Removes content references in 'driver.rb'.
sed -i '/introduction/d' src/driver.rb

# Removes content references in 'main.rb'.
sed -i '/Battle/d' src/main.rb
sed -i '/Map/d' src/main.rb
sed -i '/name/d' src/main.rb
sed -i '/max_hp/d' src/main.rb
sed -i '/attack/d' src/main.rb
sed -i '/battle/d' src/main.rb
sed -i '/map/d' src/main.rb
sed -i '/location/d' src/main.rb
