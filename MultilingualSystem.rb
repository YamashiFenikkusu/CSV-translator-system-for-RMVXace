#==============================================================================
# ** Multilingual System
#------------------------------------------------------------------------------
# ★ Yamashi Fenikkusu - v0.1
# https://github.com/YamashiFenikkusu/RMVXace-multilingual-system/tree/main
#------------------------------------------------------------------------------
# This script able your game to be multilingual. It's using csv file.
# A good comprehension of programmation and csv system are required.
#------------------------------------------------------------------------------
# How to use:
# -You need to have a "CSV" named folder in the project root.
# -You have to put MultilingualSystem.init_language at the end of Main script.
# -A CSV folder are offered on the GitHub page, it's containing a CSV for Vocab module.
#==============================================================================

#==============================================================================
# * Multilingual System
#==============================================================================
class MultilingualSystem
  #--------------------------------------------------------------------------
  # * Commands
  #  -MultilingualSystem.read_key("tableName", "keyName"):
  #     Read a key in a csv file
  #  -MultilingualSystem.set_language("desiredLanguage)
  #--------------------------------------------------------------------------
  # * Variables
  #  -ROOT_FOLDER:
  #     The folder where csv files are located. By delfaut in the project root.
  #  -@@languages:
  #     The languages of the game. The headers keys must be the same as the keys in the array.
  #  -@@current_language:
  #     The current language of the game. "EN" by delfaut.
  #--------------------------------------------------------------------------
  ROOT_FOLDER = "CSV/"
  @@languages = ["EN", "FR"]
  @@current_language = @@languages[0]

  #--------------------------------------------------------------------------
  # * Set language
  #--------------------------------------------------------------------------
  def self.set_language(lang)
    @@current_language = @@languages.include?(lang) ? lang : @@current_language
  end

  #--------------------------------------------------------------------------
  # * Read a key from CSV file
  #--------------------------------------------------------------------------
  def self.read_key(table, key)
    file_path = ROOT_FOLDER + table + ".csv"
    csv_reader = CSVReader.new(file_path)
    csv_reader.get_value(key, @@current_language)
  end
end

#==============================================================================
# * CSV reader
#==============================================================================
class CSVReader
  attr_reader :data, :headers
  
  #--------------------------------------------------------------------------
  # * Initialize key
  #--------------------------------------------------------------------------
  def initialize(file_path, delimiter = ",")
    @data = []
    return unless File.exist?(file_path)
    File.open(file_path, "r:BOM|UTF-8") do |file|
      file.each_with_index do |line, index|
        next if line.strip.empty?
        row = line.strip.split(delimiter)
        if index == 0
          @headers = row
        else
          @data << row
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Search key
  #--------------------------------------------------------------------------
  def get_value(key, language)
    lang_index = @headers.index(language)
    return nil unless lang_index
    @data.each do |row|
      return row[lang_index] if row[0] == key
    end
    nil
  end
end

#==============================================================================
# * Vocab modifier
#==============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  VOCAB_KEY_BASIC =
  {
    0 => "level",   1 => "level_a",   2 => "hp",   3 => "hp_a",   4 => "mp",
    5 => "mp_a",   6 => "tp",   7 => "tp_a"
  }
  
  VOCAB_KEY_COMMAND =
  {
    0 => "fight",   1 => "escape",   2 => "attack",   3 => "guard",   4 => "item",
    5 => "skill",   6 => "equip",    7 => "status",   8 => "formation",   9 => "save",
    10 => "game_end",   12 => "weapon",   13 => "armor",   14 => "key_item",   15 => "equip2",
    16 => "optimize",   17 => "clear",   18 => "new_game",   19 => "continue",   20 => "shutdown",
    21 => "to_title",   22 => "cancel"
  }
  
  VOCAB_DYNAMIC_METHODS = %w[
    ShopBuy  ShopSell ShopCancel Possession
    ExpTotal ExpNext
    SaveMessage LoadMessage File
    PartyName
    Emerge Preemptive Surprise EscapeStart EscapeFailure
    Victory Defeat ObtainExp ObtainGold ObtainItem LevelUp ObtainSkill
    UseItem
    CriticalToEnemy CriticalToActor
    ActorDamage ActorRecovery ActorGain ActorLoss ActorDrain ActorNoDamage ActorNoHit
    EnemyDamage EnemyRecovery EnemyGain EnemyLoss EnemyDrain  EnemyNoDamage EnemyNoHit
    Evasion MagicEvasion MagicReflection CounterAttack Substitute
    BuffAdd DebuffAdd BuffRemove
    ActionFailure
    PlayerPosError Eradicator EventOverflow
  ]
  
  #--------------------------------------------------------------------------
  # * Vocab reference
  #--------------------------------------------------------------------------
  class << self
    #Basic and command
    alias_method :original_basic, :basic
    alias_method :original_command, :command
    #Vocab dynamic methods
    VOCAB_DYNAMIC_METHODS.each do |name|
      define_method(name) do
        MultilingualSystem.read_key("Vocab", name.downcase) || "Default_#{name}"
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Override basic
  #--------------------------------------------------------------------------
  def self.basic(basic_id)
    key = VOCAB_KEY_BASIC[basic_id]
    return original_basic(basic_id) unless key
    translation = MultilingualSystem.read_key("Vocab", key)
    translation.nil? ? original_basic(basic_id) : translation
  end
  
  #--------------------------------------------------------------------------
  # * Override command
  #--------------------------------------------------------------------------
  def self.command(command_id)
    key = VOCAB_KEY_COMMAND[command_id]
    return original_command(command_id) unless key
    translation = MultilingualSystem.read_key("Vocab", key)
    translation.nil? ? original_command(command_id) : translation
  end
end

#==============================================================================
# * Scene Title modifier
#==============================================================================
class Scene_Title
  alias multilingual_start start

  def start
    multilingual_start
    # Charge les vocabulaires traduits
    Vocab::VOCAB_DYNAMIC_METHODS.each { |m| Vocab.send(m) }
    0.upto(7)  { |i| Vocab.basic(i) }
    (0..10).each { |i| Vocab.command(i) }
    (12..22).each { |i| Vocab.command(i) }
  end
end
