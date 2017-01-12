# Removes 'Battle' preset data.

rm -f lib/Battle/BattleCommand/Attack/flying_kick.rb
rm -f lib/Battle/BattleCommand/Attack/punch.rb

# Removes 'Entity' preset data.

rm -f lib/Entity/Monster/sensei.rb

# Removes 'Event' preset data.

rm -f lib/Event/ayara.rb
rm -f lib/Event/basketball.rb
rm -f lib/Event/house.rb
rm -f lib/Event/pool.rb
rm -f lib/Event/rest.rb
rm -f lib/Event/sign.rb
rm -f lib/Event/stove.rb
rm -f lib/Event/NPC/ayara.rb
rm -f lib/Event/Shop/ayara.rb

# Removes 'Item' preset data.

rm -f lib/Item/bait.rb
rm -f lib/Item/basketball.rb
rm -f lib/Item/bucket.rb
rm -f lib/Item/cookable.rb
rm -f lib/Item/fishing_pole.rb
rm -f lib/Item/recipe_book.rb
rm -f lib/Item/Food/egg.rb
rm -f lib/Item/Food/fish.rb
rm -f lib/Item/Food/fruits.rb
rm -f lib/Item/Food/veggies.rb
rm -f lib/Item/Equippable/Legs/karate_legs.rb
rm -f lib/Item/Equippable/Torso/karate_top.rb

# Removes 'Map' preset data.

rm -f lib/Map/Map/ayara.rb
rm -f lib/Map/Tile/standard.rb

# Removes 'Story' preset data.

rm -f lib/Story/intro.rb

# Removes content references in 'main.rb'.

sed -i '/Battle/d' lib/main.rb
sed -i '/Map/d' lib/main.rb
sed -i '/intro/d' lib/main.rb
sed -i '/max_hp/d' lib/main.rb
sed -i '/attack/d' lib/main.rb
sed -i '/map/d' lib/main.rb
sed -i '/location/d' lib/main.rb
sed -i '/battle/d' lib/main.rb