require_relative '../../../../lib/Battle/BattleCommand/Attack/attack.rb'
require_relative '../../../../lib/Entity/player.rb'
require_relative '../../../../lib/Entity/Monster/monster.rb'

RSpec.describe Attack do

  before(:each) do
    @user = Player.new(max_hp: 50, attack: 6, defense: 4)
    @enemy = Monster.new(max_hp: 30, attack: 3, defense: 2)
    @attack = Attack.new(strength: 5)
    @cry = Attack.new(name: "Cry", success_rate: 0)
  end

  context "constructor" do
    it "has the correct default parameters" do
      attack = Attack.new
      expect(attack.name).to eq "Attack"
      expect(attack.strength).to eq 1
      expect(attack.success_rate).to eq 100
    end

    it "correctly assigns all custom parameters" do
      poke = Attack.new(name: "Poke",
                        strength: 12,
                        success_rate: 95)
      expect(poke.name).to eq "Poke"
      expect(poke.strength).to eq 12
      expect(poke.success_rate).to eq 95
    end

    it "correctly assigns only one custom parameter" do
      attack = Attack.new(success_rate: 77)
      expect(attack.name).to eq "Attack"
      expect(attack.strength).to eq 1
      expect(attack.success_rate).to eq 77
    end
  end

  context "equality operator" do
    it "returns true for the seemingly trivial case" do
      expect(Attack.new).to eq Attack.new
    end

    it "returns false for commands with different names" do
      poke = Attack.new(name: "Poke")
      kick = Attack.new(name: "Kick")
      expect(poke).not_to eq kick
    end
  end

  context "run" do
    it "does the appropriate amount of damage for attack > defense" do
      @attack.run(@user, @enemy)
      expect(@enemy.hp).to be_between(21, 24)
    end

    it "prevents the enemy's HP from falling below 0" do
      @user.attack = 1000
      @attack.run(@user, @enemy)
      expect(@enemy.hp).to be_zero
    end

    it "does the appropriate amount of damage for defense > attack" do
      @attack.run(@enemy, @user)
      expect(@user.hp).to be_between(45, 46)
    end

    it "prints an appropriate message for a failed attack" do
      expect { @cry.run(@user, @enemy) }.to output(
        "Player tries to use Cry, but it fails.\n\n"
      ).to_stdout
    end
  end

  context "calculate damage" do
    it "returns within the appropriate range for attack > defense" do
      damage = @attack.calculate_damage(@user, @enemy)
      expect(damage).to be_between(6, 9)
    end

    it "returns within the appropriate range for defense > attack" do
      damage = @attack.calculate_damage(@enemy, @user)
      expect(damage).to be_between(4, 5)
    end

    it "defaults to 0 when the defense is very high" do
      @enemy.defense = 100
      damage = @attack.calculate_damage(@user, @enemy)
      expect(damage).to be_zero
    end
  end

end
