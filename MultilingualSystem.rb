#==============================================================================
# ** Multilingual System
#------------------------------------------------------------------------------
# ★ Yamashi Fenikkusu - v0.3
# https://github.com/YamashiFenikkusu/RMVXace-multilingual-system/tree/main
#------------------------------------------------------------------------------
# This script able your game to be multilingual by using csv file.
# A good comprehension of programmation and csv system are required.
#------------------------------------------------------------------------------
# How to use:
# -You need to have a "CSV" named folder in the project root.
# -You have to put MultilingualSystem.init_language at the end of Main script.
# -A CSV folder are offered on the GitHub page, it's containing a csv file for
#  Vocab module. Files csv for actors, weapons will come later. The csv files
#  offered on the Github page contain translation in English and French.
# -For messages event comand and choice, use this format for display a message
#  contained in a csv file: (tableName, keyName)
#==============================================================================
# /!\ DISCLAIMER /!\
# This script don't integrate AI translator, you've the charge of yours translations.
#==============================================================================

#==============================================================================
# * Multilingual System
#==============================================================================
class MultilingualSystem
	#--------------------------------------------------------------------------
	# * Useful scripts commands
	#  -MultilingualSystem.read_key(tableName, keyName):
	#     Read a key in a csv file
	#  -MultilingualSystem.set_language(desiredLanguage)
	#			Set a new language. The desiredLanguage parameter must be same as the
	#			one in @@languages array and csv files.
	#  -MultilingualSystem.current_language
	#     Return the current language.
	#--------------------------------------------------------------------------
	# * Variables
	#  -ROOT_FOLDER:
	#     The folder where csv files are located. By delfaut in the project root.
	#  -@@languages:
	#     The languages of the game. The headers keys must be the same as the keys in the array.
	#  -@default_lang:
	#     The default language of game.
	#  -$current_language:
	#     The current language of the game. By default, this variable is equal to @default_lang.
	#--------------------------------------------------------------------------
	ROOT_FOLDER = "CSV/"
	@@languages = ["EN", "FR"]
	@default_lang = @@languages[0]
	$current_language = @default_lang
	
	#--------------------------------------------------------------------------
	# * Read a key from CSV file
	#--------------------------------------------------------------------------
	def self.read_key(table, key)
		file_path = ROOT_FOLDER + table + ".csv"
		csv_reader = CSVReader.new(file_path)
		csv_reader.get_value(key, $current_language)
	end
	
	#--------------------------------------------------------------------------
	# * Set language
	#--------------------------------------------------------------------------
	def self.set_language(lang)
		#Set language parameter
		$current_language = @@languages.include?(lang) ? lang : $current_language
		apply_translation
		#Write in Game.ini
		return unless @@languages.include?(lang)
		lines = []
		language_written = false
		File.open("Game.ini", "r") do |file|
			file.each_line do |line|
				if line =~ /^Language=/
					lines << "Language=#{lang}\n"
					language_written = true
				else
					lines << line
				end
			end
		end
		lines << "Language=#{lang}\n" unless language_written
		File.open("Game.ini", "w") do |file|
			lines.each { |line| file.write(line) }
		end
		@@current_language = lang
	end
	
	#--------------------------------------------------------------------------
	# * Read language in Game.ini
	#--------------------------------------------------------------------------
	def self.read_ini_language
		lang = nil
		lines = []
		found = false
		File.readlines("Game.ini").each do |line|
			if line =~ /^Language=(.+)$/i
				lang = $1.strip
				if @@languages.include?($1.strip) == false
					lang = @default_lang
				end
				found = true
			end
			lines << line
		end
		unless found
			lines << "Language=#{@default_lang}\n"
			File.open("Game.ini", "w") { |f| f.puts lines }
			lang = @default_lang
		end
		lang
	end
	
	#--------------------------------------------------------------------------
	# * Current language
	#--------------------------------------------------------------------------
	def self.current_language
		return $current_language
	end
	
	#--------------------------------------------------------------------------
	# * Apply translation
	#--------------------------------------------------------------------------
	def self.apply_translation
		#Apply translations to vocab
		(0..7).each  { |i| Vocab.basic(i) }
		(0..10).each { |i| Vocab.command(i) }
		(12..22).each { |i| Vocab.command(i) }
		Vocab.override_constants
	end
	
	#
	def self.first_initialize
		$current_language = read_ini_language
		apply_translation
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
	
	VOCAB_DYNAMIC_CONSTANTS =
	{
		ShopBuy: "shop_buy",   ShopSell: "shop_sell",
		ShopCancel: "shop_cancel",
		Possession: "shop_possesion",
		ExpTotal: "exp_total",
		ExpNext: "exp_next",
		SaveMessage: "save_message",
		LoadMessage: "load_message",
		File: "file",
		PartyName: "party_name",
		Emerge: "emerge",
		Preemptive: "preepmtive",
		Surprise: "suprise",
		EscapeStart: "escape_start",
		EscapeFailure: "escape_failure",
		Victory: "victory",
		Defeat: "defeat",
		ObtainExp: "obtain_exp",
		ObtainGold: "obtain_gold",
		ObtainItem: "obtain_item",
		LevelUp: "level_up",
		ObtainSkill: "obtain_skill",
		UseItem: "use_item",
		CriticalToEnemy: "critical_to_enemy",
		CriticalToActor: "critical_to_actor",
		ActorDamage: "actor_damage",
		ActorRecovery: "actor_recovery",
		ActorGain: "actor_gain",
		ActorLoss: "actor_loss",
		ActorDrain: "actor_drain",
		ActorNoDamage: "actor_no_damage",
		ActorNoHit: "actor_no_hit",
		EnemyDamage: "enemy_damage",
		EnemyRecovery: "enemy_recovery",
		EnemyGain: "enemy_gain",
		EnemyLoss: "enemy_loss",
		EnemyDrain: "enemy_drain",
		EnemyNoDamage: "enemy_no_damage",
		EnemyNoHit: "enemy_no_hit",
		Evasion: "evasion",
		MagicEvasion: "magic_evasion",
		MagicReflection: "magic_reflection",
		CounterAttack: "counter_attack",
		Substitute: "substitute",
		BuffAdd: "buff_add",
		DebuffAdd: "debuf_add",
		BuffRemove: "buff_remove",
		ActionFailure: "action_failure",
		PlayerPosError: "player_pos_error",
		Eradicator: "eradicator",
		EventOverflow: "event_overflow"
	}
	
	#--------------------------------------------------------------------------
	# * Vocab reference
	#--------------------------------------------------------------------------
	class << self
		#Basic and command
		alias_method :original_basic, :basic
		alias_method :original_command, :command
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
	
	#--------------------------------------------------------------------------
	# * Override constants
	#--------------------------------------------------------------------------
	def self.override_constants
		VOCAB_DYNAMIC_CONSTANTS.each do |const_name, key_name|
			remove_const(const_name) if const_defined?(const_name)
			translation = MultilingualSystem.read_key("Vocab", key_name) || "Default_#{const_name}"
			const_set(const_name, translation)
		end
	end
end

#==============================================================================
# * Game Message modifier
#==============================================================================
class Game_Message
	alias multilingual_add add
	
	#--------------------------------------------------------------------------
	# * Override add
	#--------------------------------------------------------------------------
	def add(text)
		result = text
		if text.is_a?(String) && text.strip.start_with?("(") && text.strip.end_with?(")")
			begin
				inner = text.strip[1..-2].strip
				parts = inner.split(",").map { |s| s.strip.gsub(/^["']|["']$/, "") }
				if parts.size == 2
					table, key = parts
					translated = MultilingualSystem.read_key(table, key)
					result = translated || "#{table}.#{key}"
				end
			rescue => e
				result = "[ERROR: Translation failed]"
			end
		end
		multilingual_add(result)
	end
end

#==============================================================================
# * Window ChoiceList modifier
#==============================================================================
class Window_ChoiceList < Window_Command
	alias multilingual_make_command_list make_command_list
	
	#--------------------------------------------------------------------------
	# * Override make command list
	#--------------------------------------------------------------------------
	def make_command_list
		$game_message.choices.each do |choice|
			if choice.is_a?(String) && choice.strip.start_with?("(") && choice.strip.end_with?(")")
				begin
					inner = choice.strip[1..-2].strip
					parts = inner.split(",").map { |s| s.strip.gsub(/^["']|["']$/, "") }
					if parts.size == 2
						table, key = parts
						translated = MultilingualSystem.read_key(table, key)
						result = translated || "#{table}.#{key}"
					end
				rescue => e
					result = "[ERROR: Translation failed]"
				end
			end
			add_command(result, :choice)
		end
	end
end

#==============================================================================
# * Scene Manager modifier
#==============================================================================
module SceneManager
	class << self
		alias multilingual_run run
		
		#--------------------------------------------------------------------------
		# * Override run
		#--------------------------------------------------------------------------
		def run
			MultilingualSystem.first_initialize
			multilingual_run
		end
	end
end
