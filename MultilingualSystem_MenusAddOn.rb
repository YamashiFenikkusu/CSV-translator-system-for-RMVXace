#==============================================================================
# ** Multilingual System - Simple Add on for menus
#------------------------------------------------------------------------------
# ★ Yamashi Fenikkusu - v0.5
# https://github.com/YamashiFenikkusu/CSV-translator-system-for-RMVXace/tree/main
#------------------------------------------------------------------------------
# This add on set an option on title screen and pause menu to changing the
# language game during a game session. It's needing the Multilingual System v1.0
# (available on the main Github page). Put this script under the Multilingual System.
#==============================================================================

#==============================================================================
# * Multilingual System - Menus add on
#==============================================================================
class MultilingualSystem
	@SHOW_OPTION_TITLE_SCREEN = true
	@SHOW_OPTION_PAUSE_MENU = true
	
	#--------------------------------------------------------------------------
	# * Return show option
	#--------------------------------------------------------------------------
	def self.return_show_option_title_screen; return @SHOW_OPTION_TITLE_SCREEN end
	def self.return_show_option_pause_menu; return @SHOW_OPTION_PAUSE_MENU end
end

#==============================================================================
# * Vocab - Menus add on
#==============================================================================
module Vocab
	@VOCAB_MENU_LANG = "menu_lang"
	
	#--------------------------------------------------------------------------
	# * Menu lang
	#--------------------------------------------------------------------------
	def self.menu_lang; return MultilingualSystem.read_key("Database_Vocab", @VOCAB_MENU_LANG) end
end

#==============================================================================
# * Window_MenuCommand modifier
#==============================================================================
class Window_MenuCommand < Window_Command
	#--------------------------------------------------------------------------
  # * Override create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands
    add_formation_command
    add_original_commands
    add_save_command
		if MultilingualSystem.return_show_option_pause_menu == true; add_set_lang_command end
    add_game_end_command
  end
	
	#--------------------------------------------------------------------------
	# * Add set lang command
	#--------------------------------------------------------------------------
	def add_set_lang_command; add_command(Vocab::menu_lang, :menu_lang) end
end

#==============================================================================
# * Scene_Menu modifier
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Override create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_personal))
    @command_window.set_handler(:equip,     method(:command_personal))
    @command_window.set_handler(:status,    method(:command_personal))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:save,      method(:command_save))
		if MultilingualSystem.return_show_option_pause_menu == true
			@command_window.set_handler(:menu_lang,      method(:command_lang))
		end
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
  end
	
	#--------------------------------------------------------------------------
  # * Command lang
  #--------------------------------------------------------------------------
  def command_lang; SceneManager.call(Scene_Language) end
end

#==============================================================================
# * Window_MenuCommand modifier
#==============================================================================
class Window_TitleCommand < Window_Command
	#--------------------------------------------------------------------------
  # * Override create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::new_game, :new_game)
    add_command(Vocab::continue, :continue, continue_enabled)
		if MultilingualSystem.return_show_option_title_screen == true; add_set_lang_command end
    add_command(Vocab::shutdown, :shutdown)
  end
	
	#--------------------------------------------------------------------------
	# * Add set lang command
	#--------------------------------------------------------------------------
	def add_set_lang_command; add_command(Vocab::menu_lang, :menu_lang) end
end

#==============================================================================
# * Scene_Title modifier
#==============================================================================
class Scene_Title < Scene_Base
	#--------------------------------------------------------------------------
  # * Override create Command Window
  #--------------------------------------------------------------------------
	def create_command_window
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:new_game, method(:command_new_game))
    @command_window.set_handler(:continue, method(:command_continue))
		if MultilingualSystem.return_show_option_title_screen == true
			@command_window.set_handler(:menu_lang, method(:command_lang))
		end
    @command_window.set_handler(:shutdown, method(:command_shutdown))
  end
	
	#--------------------------------------------------------------------------
  # * Command lang
  #--------------------------------------------------------------------------
  def command_lang; SceneManager.call(Scene_Language) end
end

#==============================================================================
# * Window_LanguageMenu
#==============================================================================
class Window_LanguageMenu < Window_Command
	#--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
		@commands_to_add = []
    super(0, 0)
    update_placement
    self.openness = 0
    open
  end
	
  #--------------------------------------------------------------------------
  # * Window width
  #--------------------------------------------------------------------------
  def window_width; return 200 end
	
  #--------------------------------------------------------------------------
  # * Update placement
  #--------------------------------------------------------------------------
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end
	
  #--------------------------------------------------------------------------
  # * Make command list
  #--------------------------------------------------------------------------
  def make_command_list
		MultilingualSystem.return_lang_count.times do |i|
      lang = MultilingualSystem.return_specific_language(i)
			translated_key = MultilingualSystem.read_key("Database_Vocab", "menu_lang"<<lang)
			add_command(translated_key, :"switch_to_#{lang}")
    end
    add_command(Vocab::cancel, :cancel)
  end
end

#==============================================================================
# * Scene_Language
#==============================================================================
class Scene_Language < Scene_Base
	#--------------------------------------------------------------------------
  # * Start
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
  end
	
	#--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_LanguageMenu.new
		MultilingualSystem.return_lang_count.times do |i|
			lang = MultilingualSystem.return_specific_language(i)
			@command_window.set_handler(:"switch_to_#{lang}", method(:command_lang))
		end
		@command_window.set_handler(:cancel, method(:return_scene))
  end
	
	#--------------------------------------------------------------------------
  # * Command lang
  #--------------------------------------------------------------------------
	def command_lang
    lang = @command_window.current_symbol.to_s.sub("switch_to_", "")
		MultilingualSystem.set_language(lang)
		return_scene
  end
end
